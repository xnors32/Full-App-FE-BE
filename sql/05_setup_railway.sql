-- ============================================================
-- PostgreSQL Setup for Railway — Sistem Inventaris Laboratorium
-- ============================================================
-- Cara pakai:
--   1. Deploy PostgreSQL di Railway
--   2. Dapatkan connection string dari Railway Dashboard
--   3. Hubungkan via psql:
--        psql "postgresql://user:pass@host:port/railway?sslmode=require"
--   4. Jalankan file ini:
--        \i sql/05_setup_railway.sql
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
