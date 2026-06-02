-- ============================================================
-- MySQL Setup for Railway — Sistem Inventaris Laboratorium
-- ============================================================
-- Cara pakai:
--   1. Deploy MySQL di Railway
--   2. Dapatkan connection string dari Railway Dashboard
--   3. Jalankan via MySQL client:
--        mysql -h host -u user -p database < sql/05_setup_railway.sql
-- ============================================================

-- ============================================================
-- Drop existing tables (urutan child ke parent)
-- ============================================================
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS users;

-- ============================================================
-- 1. users
-- ============================================================
CREATE TABLE users (
    id         BIGINT       NOT NULL AUTO_INCREMENT,
    nama       VARCHAR(255) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    password   VARCHAR(255) NOT NULL,
    role       VARCHAR(20)  NOT NULL COMMENT 'ADMIN | PETUGAS | MAHASISWA',
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    CONSTRAINT uk_users_email UNIQUE (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. kategori
-- ============================================================
CREATE TABLE kategori (
    id            BIGINT       NOT NULL AUTO_INCREMENT,
    nama_kategori VARCHAR(255) NOT NULL,
    deskripsi     TEXT,

    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. barang
-- ============================================================
CREATE TABLE barang (
    id               BIGINT       NOT NULL AUTO_INCREMENT,
    id_kategori      BIGINT       NOT NULL,
    nama_barang      VARCHAR(255) NOT NULL,
    kode_barang      VARCHAR(255) NOT NULL,
    jumlah_total     INT          NOT NULL DEFAULT 0,
    jumlah_tersedia  INT          NOT NULL DEFAULT 0,
    kondisi          VARCHAR(20)  NOT NULL COMMENT 'BAIK | RUSAK_RINGAN | RUSAK_BERAT',
    lokasi           VARCHAR(255) NOT NULL,
    harga            DECIMAL(15,2) NOT NULL DEFAULT 0.00,

    PRIMARY KEY (id),
    CONSTRAINT uk_barang_kode_barang UNIQUE (kode_barang),
    CONSTRAINT fk_barang_kategori
        FOREIGN KEY (id_kategori) REFERENCES kategori (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. peminjaman
-- ============================================================
CREATE TABLE peminjaman (
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    id_peminjam  BIGINT       NOT NULL,
    id_petugas   BIGINT,
    tgl_pinjam   DATE         NOT NULL,
    tgl_kembali  DATE         NOT NULL,
    status       VARCHAR(20)  NOT NULL COMMENT 'MENUNGGU | DISETUJUI | DITOLAK | DIKEMBALIKAN',
    catatan      TEXT,

    PRIMARY KEY (id),
    CONSTRAINT fk_peminjaman_peminjam
        FOREIGN KEY (id_peminjam) REFERENCES users (id),
    CONSTRAINT fk_peminjaman_petugas
        FOREIGN KEY (id_petugas)  REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 5. detail_peminjaman
-- ============================================================
CREATE TABLE detail_peminjaman (
    id               BIGINT      NOT NULL AUTO_INCREMENT,
    id_peminjaman    BIGINT      NOT NULL,
    id_barang        BIGINT      NOT NULL,
    jumlah           INT         NOT NULL,
    kondisi_kembali  VARCHAR(20) COMMENT 'BAIK | RUSAK_RINGAN | RUSAK_BERAT',

    PRIMARY KEY (id),
    CONSTRAINT fk_detail_peminjaman_peminjaman
        FOREIGN KEY (id_peminjaman) REFERENCES peminjaman (id),
    CONSTRAINT fk_detail_peminjaman_barang
        FOREIGN KEY (id_barang) REFERENCES barang (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
