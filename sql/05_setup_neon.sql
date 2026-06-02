-- ============================================================
-- PostgreSQL Setup for Neon — Sistem Inventaris Laboratorium
-- ============================================================
-- Cara pakai:
--   1. Buat project di https://neon.tech
--   2. Dapatkan connection string (contoh di bawah)
--   3. Hubungkan via psql:
--        psql "postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/inventori_lab?sslmode=require"
--   4. Jalankan file ini:
--        \i sql/05_setup_neon.sql
-- ============================================================

-- ============================================================
-- Drop existing tables (urutan child ke parent)
-- ============================================================
DROP TABLE IF EXISTS detail_peminjaman CASCADE;
DROP TABLE IF EXISTS peminjaman       CASCADE;
DROP TABLE IF EXISTS barang           CASCADE;
DROP TABLE IF EXISTS kategori         CASCADE;
DROP TABLE IF EXISTS users            CASCADE;

-- ============================================================
-- 1. users
-- ============================================================
CREATE TABLE users (
    id         BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama       VARCHAR(255) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    password   VARCHAR(255) NOT NULL,
    role       VARCHAR(20)  NOT NULL CHECK (role IN ('ADMIN', 'PETUGAS', 'MAHASISWA')),
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT uk_users_email UNIQUE (email)
);

-- ============================================================
-- 2. kategori
-- ============================================================
CREATE TABLE kategori (
    id            BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_kategori VARCHAR(255) NOT NULL,
    deskripsi     TEXT
);

-- ============================================================
-- 3. barang
-- ============================================================
CREATE TABLE barang (
    id               BIGINT        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_kategori      BIGINT        NOT NULL,
    nama_barang      VARCHAR(255)  NOT NULL,
    kode_barang      VARCHAR(255)  NOT NULL,
    jumlah_total     INT           NOT NULL DEFAULT 0,
    jumlah_tersedia  INT           NOT NULL DEFAULT 0,
    kondisi          VARCHAR(20)   NOT NULL CHECK (kondisi IN ('BAIK', 'RUSAK_RINGAN', 'RUSAK_BERAT')),
    lokasi           VARCHAR(255)  NOT NULL,
    harga            DECIMAL(15,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT pk_barang PRIMARY KEY (id),
    CONSTRAINT uk_barang_kode_barang UNIQUE (kode_barang),
    CONSTRAINT fk_barang_kategori
        FOREIGN KEY (id_kategori) REFERENCES kategori (id)
);

-- ============================================================
-- 4. peminjaman
-- ============================================================
CREATE TABLE peminjaman (
    id           BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_peminjam  BIGINT       NOT NULL,
    id_petugas   BIGINT,
    tgl_pinjam   DATE         NOT NULL,
    tgl_kembali  DATE         NOT NULL,
    status       VARCHAR(20)  NOT NULL CHECK (status IN ('MENUNGGU', 'DISETUJUI', 'DITOLAK', 'DIKEMBALIKAN')),
    catatan      TEXT,

    CONSTRAINT fk_peminjaman_peminjam
        FOREIGN KEY (id_peminjam) REFERENCES users (id),
    CONSTRAINT fk_peminjaman_petugas
        FOREIGN KEY (id_petugas)  REFERENCES users (id)
);

-- ============================================================
-- 5. detail_peminjaman
-- ============================================================
CREATE TABLE detail_peminjaman (
    id               BIGINT      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_peminjaman    BIGINT      NOT NULL,
    id_barang        BIGINT      NOT NULL,
    jumlah           INT         NOT NULL,
    kondisi_kembali  VARCHAR(20) CHECK (kondisi_kembali IN ('BAIK', 'RUSAK_RINGAN', 'RUSAK_BERAT')),

    CONSTRAINT fk_detail_peminjaman_peminjaman
        FOREIGN KEY (id_peminjaman) REFERENCES peminjaman (id),
    CONSTRAINT fk_detail_peminjaman_barang
        FOREIGN KEY (id_barang) REFERENCES barang (id)
);

-- ============================================================
-- Seed Data
-- ============================================================

-- Users (password: admin123 — hash bcrypt)
INSERT INTO users (nama, email, password, role) VALUES
    ('Admin Lab Utama',  'admin@lab.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN'),
    ('Petugas Lab Satu', 'petugas@lab.com',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'PETUGAS'),
    ('Mahasiswa Teknik', 'mahasiswa@lab.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'MAHASISWA');

-- Kategori
INSERT INTO kategori (nama_kategori, deskripsi) VALUES
    ('Alat Elektronik', 'Peralatan elektronik laboratorium termasuk osiloskop, catu daya, dsb.'),
    ('Alat Gelas',      'Peralatan glassware laboratorium kimia dasar.');

-- Barang
INSERT INTO barang (id_kategori, nama_barang, kode_barang, jumlah_total, jumlah_tersedia, kondisi, lokasi, harga) VALUES
    (1, 'Oscilloscope Digital', 'EL-OSC-001', 5,  5,  'BAIK', 'Lemari A1', 1500000.00),
    (1, 'Digital Multimeter',   'EL-DMM-002', 10, 10, 'BAIK', 'Lemari A2', 750000.00),
    (2, 'Beaker Glass 250ml',   'GL-BKR-003', 25, 25, 'BAIK', 'Rak B1',    35000.00);

-- ============================================================
-- Contoh Query & Laporan (PostgreSQL)
-- ============================================================

-- 1. Laporan Stok Barang
SELECT
    b.id,
    b.kode_barang,
    b.nama_barang,
    k.nama_kategori,
    b.jumlah_total,
    b.jumlah_tersedia,
    (b.jumlah_total - b.jumlah_tersedia) AS jumlah_dipinjam,
    b.kondisi,
    b.lokasi,
    b.harga
FROM barang b
JOIN kategori k ON k.id = b.id_kategori
ORDER BY k.nama_kategori, b.nama_barang;

-- 2. Barang dengan stok menipis
SELECT
    b.kode_barang,
    b.nama_barang,
    b.jumlah_total,
    b.jumlah_tersedia,
    ROUND(b.jumlah_tersedia * 100.0 / b.jumlah_total, 1) AS persen_tersedia
FROM barang b
WHERE b.jumlah_tersedia * 1.0 / b.jumlah_total <= 0.2
ORDER BY persen_tersedia;

-- 3. Riwayat Peminjaman per Pengguna
SELECT
    u.nama                    AS peminjam,
    p.id                      AS id_peminjaman,
    p.tgl_pinjam,
    p.tgl_kembali,
    p.status,
    COALESCE(pt.nama, '-')    AS petugas,
    COUNT(dp.id)              AS jumlah_item,
    SUM(dp.jumlah)            AS total_kuantitas
FROM peminjaman p
JOIN users u              ON u.id = p.id_peminjam
LEFT JOIN users pt        ON pt.id = p.id_petugas
LEFT JOIN detail_peminjaman dp ON dp.id_peminjaman = p.id
GROUP BY p.id, u.nama, pt.nama
ORDER BY p.tgl_pinjam DESC;

-- 4. Detail Peminjaman
SELECT
    p.id                    AS id_peminjaman,
    u.nama                  AS peminjam,
    p.tgl_pinjam,
    b.kode_barang,
    b.nama_barang,
    dp.jumlah,
    dp.kondisi_kembali
FROM detail_peminjaman dp
JOIN peminjaman p  ON p.id = dp.id_peminjaman
JOIN users u       ON u.id = p.id_peminjam
JOIN barang b      ON b.id = dp.id_barang
ORDER BY p.tgl_pinjam DESC, p.id;

-- 5. Laporan Peminjaman per Periode
SELECT
    TO_CHAR(p.tgl_pinjam, 'YYYY-MM')        AS bulan,
    COUNT(DISTINCT p.id)                    AS total_peminjaman,
    COUNT(DISTINCT p.id_peminjam)           AS peminjam_unik,
    SUM(dp.jumlah)                          AS total_barang_dipinjam
FROM peminjaman p
JOIN detail_peminjaman dp ON dp.id_peminjaman = p.id
WHERE p.tgl_pinjam BETWEEN $1 AND $2
GROUP BY TO_CHAR(p.tgl_pinjam, 'YYYY-MM')
ORDER BY bulan;

-- 6. Barang paling sering dipinjam
SELECT
    b.kode_barang,
    b.nama_barang,
    COUNT(dp.id)          AS kali_dipinjam,
    SUM(dp.jumlah)        AS total_kuantitas
FROM detail_peminjaman dp
JOIN barang b ON b.id = dp.id_barang
GROUP BY b.id, b.kode_barang, b.nama_barang
ORDER BY total_kuantitas DESC
LIMIT 10;

-- 7. Statistik Dashboard
SELECT 'Total Barang'           AS metric, COUNT(*)::TEXT AS value FROM barang
UNION ALL
SELECT 'Total Kategori'         AS metric, COUNT(*)::TEXT AS value FROM kategori
UNION ALL
SELECT 'Total Pengguna'         AS metric, COUNT(*)::TEXT AS value FROM users
UNION ALL
SELECT 'Peminjaman Aktif'       AS metric, COUNT(*)::TEXT AS value FROM peminjaman WHERE status = 'DISETUJUI'
UNION ALL
SELECT 'Peminjaman Menunggu'    AS metric, COUNT(*)::TEXT AS value FROM peminjaman WHERE status = 'MENUNGGU';

-- 8. Status peminjaman per role
SELECT
    p.status,
    COUNT(*)                                AS jumlah,
    COUNT(DISTINCT p.id_peminjam)           AS peminjam_berbeda
FROM peminjaman p
GROUP BY p.status
ORDER BY
    CASE p.status
        WHEN 'MENUNGGU'     THEN 1
        WHEN 'DISETUJUI'    THEN 2
        WHEN 'DIKEMBALIKAN' THEN 3
        WHEN 'DITOLAK'      THEN 4
    END;
