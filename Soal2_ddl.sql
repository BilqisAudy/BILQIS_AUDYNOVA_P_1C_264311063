-- NAMA   : BILQIS AUDYNOVA PRASANTY
-- KELAS  : 1C
-- NIM    : 264311063
-- PRODI  : TEKNOLOGI REKAYASA PERANGKAT LUNAK

USE etle_db;

-- Tabel induk: kamera
INSERT INTO kamera (id_kamera, lokasi_kamera, batas_kecepatan) VALUES
('CAM-TOL-548', 'SPEEDCAM TOL KM 548+450 A JSN', 120),
('CAM-TOL-549', 'SPEEDCAM TOL KM 548+300 A JSN', 120),
('CAM-MDN-001', 'SPEEDCAM JL. A. YANI MADIUN', 60);

-- Tabel induk: aturan_pasal
INSERT INTO aturan_pasal (kode_pelanggaran, kategori_pelanggaran, pasal_pelanggaran) VALUES
('PLG-01', 'Melanggar Batas Kecepatan', 'Pasal 287 ayat (5) jo Pasal 106'),
('PLG-02', 'Tidak Menggunakan Sabuk Pengaman', 'Pasal 289'),
('PLG-03', 'Menerobos Lampu Merah', 'Pasal 287 ayat (2)');

-- Tabel transaksi: detail_pelanggaran
INSERT INTO detail_pelanggaran
(no_referensi_sistem, id_kamera, kode_pelanggaran, waktu_capture, kecepatan_tercatat) VALUES
('910-50639-AE1270CR', 'CAM-TOL-548', 'PLG-01', '2026-03-04 09:42:11', 144),
('910-50640-AE1270CR', 'CAM-TOL-548', 'PLG-02', '2026-03-04 09:42:11', 144),
('910-50641-N4321AB',  'CAM-MDN-001', 'PLG-03', '2026-03-05 07:15:20', 35);

-- [READ] Tampilkan seluruh isi salah satu tabel induk
SELECT * FROM kamera;

-- [UPDATE] Ubah satu nilai di tabel transaksi 
UPDATE detail_pelanggaran
SET kecepatan_tercatat = 150
WHERE no_referensi_sistem = '910-50639-AE1270CR';

-- [DELETE] Hapus satu baris di tabel transaksi 
DELETE FROM detail_pelanggaran
WHERE no_referensi_sistem = '910-50641-N4321AB';
