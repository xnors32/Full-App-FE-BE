-- ============================================================
-- Contoh Query & Laporan — Inventaris Laboratorium
-- ============================================================

USE inventori_lab;

-- ---------------------------------------------------------
-- 1. Laporan Stok Barang (detail per barang + kategori)
-- ---------------------------------------------------------
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

-- ---------------------------------------------------------
-- 2. Barang dengan stok menipis (tersedia <= 20% total)
-- ---------------------------------------------------------
SELECT
    b.kode_barang,
    b.nama_barang,
    b.jumlah_total,
    b.jumlah_tersedia,
    ROUND(b.jumlah_tersedia * 100.0 / b.jumlah_total, 1) AS persen_tersedia
FROM barang b
WHERE b.jumlah_tersedia * 1.0 / b.jumlah_total <= 0.2
ORDER BY persen_tersedia;

-- ---------------------------------------------------------
-- 3. Riwayat Peminjaman per Pengguna
-- ---------------------------------------------------------
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

-- ---------------------------------------------------------
-- 4. Detail Peminjaman (barang-barang dalam satu peminjaman)
-- ---------------------------------------------------------
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

-- ---------------------------------------------------------
-- 5. Laporan Peminjaman per Periode
-- ---------------------------------------------------------
SELECT
    DATE_FORMAT(p.tgl_pinjam, '%Y-%m') AS bulan,
    COUNT(DISTINCT p.id)               AS total_peminjaman,
    COUNT(DISTINCT p.id_peminjam)      AS peminjam_unik,
    SUM(dp.jumlah)                     AS total_barang_dipinjam
FROM peminjaman p
JOIN detail_peminjaman dp ON dp.id_peminjaman = p.id
WHERE p.tgl_pinjam BETWEEN :start_date AND :end_date
GROUP BY DATE_FORMAT(p.tgl_pinjam, '%Y-%m')
ORDER BY bulan;

-- ---------------------------------------------------------
-- 6. Barang paling sering dipinjam
-- ---------------------------------------------------------
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

-- ---------------------------------------------------------
-- 7. Statistik Dashboard
-- ---------------------------------------------------------
SELECT 'Total Barang'           AS metric, COUNT(*)   AS value FROM barang
UNION ALL
SELECT 'Total Kategori'         AS metric, COUNT(*)   AS value FROM kategori
UNION ALL
SELECT 'Total Pengguna'         AS metric, COUNT(*)   AS value FROM users
UNION ALL
SELECT 'Peminjaman Aktif'       AS metric, COUNT(*)   AS value FROM peminjaman WHERE status = 'DISETUJUI'
UNION ALL
SELECT 'Peminjaman Menunggu'    AS metric, COUNT(*)   AS value FROM peminjaman WHERE status = 'MENUNGGU';

-- ---------------------------------------------------------
-- 8. Status peminjaman per role (contoh aggregasi)
-- ---------------------------------------------------------
SELECT
    p.status,
    COUNT(*)                                AS jumlah,
    COUNT(DISTINCT p.id_peminjam)           AS peminjam_berbeda
FROM peminjaman p
GROUP BY p.status
ORDER BY FIELD(p.status, 'MENUNGGU', 'DISETUJUI', 'DIKEMBALIKAN', 'DITOLAK');
