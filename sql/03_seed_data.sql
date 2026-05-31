-- ============================================================
-- DML: Data Awal (Seed) — Inventaris Laboratorium
-- ============================================================
-- Password di-hash dengan BCrypt (contoh hash untuk "admin123"
-- dan seterusnya).  Di aplikasi Spring Boot, seeder sebenarnya
-- menggunakan PasswordEncoder.encode().  Hash di sini adalah
-- contoh representasi — pada environment riil gunakan hasil
-- encode dari aplikasi atau bcrypt CLI.
-- ============================================================

USE inventori_lab;

-- ---------------------------------------------------------
-- Users
-- ---------------------------------------------------------
-- NOTE: Hash berikut adalah contoh; ganti dengan hasil
-- bcrypt yang sesuai jika ingin login via aplikasi.
INSERT INTO users (nama, email, password, role) VALUES
    ('Admin Lab Utama',  'admin@lab.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN'),
    ('Petugas Lab Satu', 'petugas@lab.com',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'PETUGAS'),
    ('Mahasiswa Teknik', 'mahasiswa@lab.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'MAHASISWA');

-- ---------------------------------------------------------
-- Kategori
-- ---------------------------------------------------------
INSERT INTO kategori (nama_kategori, deskripsi) VALUES
    ('Alat Elektronik', 'Peralatan elektronik laboratorium termasuk osiloskop, catu daya, dsb.'),
    ('Alat Gelas',      'Peralatan glassware laboratorium kimia dasar.');

-- ---------------------------------------------------------
-- Barang (dengan harga default untuk menghindari NULL)
-- ---------------------------------------------------------
INSERT INTO barang (id_kategori, nama_barang, kode_barang, jumlah_total, jumlah_tersedia, kondisi, lokasi, harga) VALUES
    (1, 'Oscilloscope Digital', 'EL-OSC-001', 5,  5,  'BAIK', 'Lemari A1', 1500000.00),
    (1, 'Digital Multimeter',   'EL-DMM-002', 10, 10, 'BAIK', 'Lemari A2', 750000.00),
    (2, 'Beaker Glass 250ml',   'GL-BKR-003', 25, 25, 'BAIK', 'Rak B1',    35000.00);
