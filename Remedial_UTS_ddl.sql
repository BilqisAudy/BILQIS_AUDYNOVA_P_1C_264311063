-- =====================================================================
-- REMEDI UTS - SCPMK0320703
-- NAMA  : BILQIS AUDYNOVA PRASANTY
-- KELAS : 1C
-- NIM   : 264311063
-- PRODI : TEKNOLOGI REKAYASA PERANGKAT LUNAK
-- Basis data : replika etle_db (pekerjaan UTS) + 1 tabel tambahan
-- =====================================================================

-- =====================================================================
-- PENAMBAHAN PROSES BISNIS
--   Setiap pelanggaran ETLE wajib disertai satu atau lebih foto bukti
--   (foto kendaraan, foto plat nomor, foto situasi).
--
-- Aturan bisnis:
--   1. Satu pelanggaran (detail_pelanggaran) memiliki 1..N foto bukti.
--   2. Foto bukti tidak dapat berdiri sendiri tanpa pelanggarannya
--      (entitas lemah).
--   3. Jika pelanggaran dihapus, foto buktinya ikut terhapus.
-- =====================================================================

-- =====================================================================
-- TAHAP 1 - PEMODELAN KONSEPTUAL (ERD)
-- =====================================================================
--   Entitas lama : KAMERA, ATURAN_PASAL, DETAIL_PELANGGARAN
--   Entitas baru : BUKTI_FOTO (entitas LEMAH)
--   Pemilik      : DETAIL_PELANGGARAN (identifying owner)
--   Atribut baru : urutan_foto (diskriminator), jenis_foto, nama_file,
--                  ukuran_kb, waktu_rekam
--
--   Relasi dan kardinalitas:
--     KAMERA       1 : N  DETAIL_PELANGGARAN   (merekam)
--     ATURAN_PASAL 1 : N  DETAIL_PELANGGARAN   (mendasari)
--     DETAIL_PELANGGARAN 1 : N  BUKTI_FOTO     (memiliki, identifying,
--                                               partisipasi total di BUKTI_FOTO)
--
--   ERD teks:
--     [KAMERA]--1:N--<merekam>--[DETAIL_PELANGGARAN]--1:N--<memiliki>==[[BUKTI_FOTO]]
--     [ATURAN_PASAL]--1:N--<mendasari>--[DETAIL_PELANGGARAN]
--     ([[ ]] dan == = entitas lemah dan relasi identifying)

-- =====================================================================
-- TAHAP 2 - PEMODELAN LOGIS
-- =====================================================================
--   Skema relasional:
--     KAMERA (id_kamera PK, lokasi_kamera, batas_kecepatan)
--     ATURAN_PASAL (kode_pelanggaran PK, kategori_pelanggaran, pasal_pelanggaran)
--     DETAIL_PELANGGARAN (no_referensi_sistem PK, id_kamera FK,
--                         kode_pelanggaran FK, waktu_capture, kecepatan_tercatat)
--     BUKTI_FOTO (no_referensi_sistem PK/FK, urutan_foto PK, jenis_foto,
--                 nama_file, ukuran_kb, waktu_rekam)            <- BARU
--
-- Normalisasi:
--
--   UNF : satu baris pelanggaran berisi banyak foto bukti sekaligus.
--     no_referensi_sistem | id_kamera   | lokasi_kamera                | waktu_capture       | kecepatan | foto
--     910-50639-AE1270CR  | CAM-TOL-548 | SPEEDCAM TOL KM 548+450 A JSN | 2026-03-04 09:42:11 | 144       | (1 Kendaraan: depan.jpg), (2 Plat Nomor: plat.jpg), (3 Situasi: situasi.jpg)
--
--   1NF : satu baris = satu foto di satu pelanggaran.
--         Kunci (no_referensi_sistem, urutan_foto).
--     no_referensi_sistem | urutan_foto | id_kamera   | lokasi_kamera                 | waktu_capture       | kecepatan | jenis_foto | nama_file
--     910-50639-AE1270CR  | 1           | CAM-TOL-548 | SPEEDCAM TOL KM 548+450 A JSN | 2026-03-04 09:42:11 | 144       | Kendaraan  | ae1270cr_depan.jpg
--     910-50639-AE1270CR  | 2           | CAM-TOL-548 | SPEEDCAM TOL KM 548+450 A JSN | 2026-03-04 09:42:11 | 144       | Plat Nomor | ae1270cr_plat.jpg
--     910-50639-AE1270CR  | 3           | CAM-TOL-548 | SPEEDCAM TOL KM 548+450 A JSN | 2026-03-04 09:42:11 | 144       | Situasi    | ae1270cr_situasi.jpg
--
--   2NF : id_kamera, lokasi_kamera, waktu_capture, kecepatan hanya bergantung
--         pada no_referensi_sistem (sebagian kunci), jadi dipindah ke tabel
--         DETAIL_PELANGGARAN. BUKTI_FOTO hanya menyimpan atribut yang
--         bergantung pada seluruh kunci:
--     BUKTI_FOTO (no_referensi_sistem, urutan_foto, jenis_foto, nama_file, ukuran_kb, waktu_rekam)
--
--   3NF : lokasi_kamera bergantung pada id_kamera, bukan langsung pada
--         no_referensi_sistem (transitif), jadi dipisah ke tabel KAMERA.
--         Hasil akhir: KAMERA, ATURAN_PASAL, DETAIL_PELANGGARAN, BUKTI_FOTO.

-- =====================================================================
-- TAHAP 3 - PEMODELAN FISIK (DDL)
-- =====================================================================
DROP DATABASE IF EXISTS etle_remedi;
CREATE DATABASE etle_remedi;
USE etle_remedi;

-- ---------------------------------------------------------------------
-- A. STRUKTUR DATABASE UTS (REPLIKA)
-- ---------------------------------------------------------------------

-- Tabel Induk 1
CREATE TABLE kamera (
    id_kamera        VARCHAR(20)  NOT NULL,
    lokasi_kamera    VARCHAR(150) NOT NULL,
    batas_kecepatan  SMALLINT UNSIGNED NOT NULL,  -- km/jam
    PRIMARY KEY (id_kamera)
);

-- Tabel Induk 2
CREATE TABLE aturan_pasal (
    kode_pelanggaran      VARCHAR(10)  NOT NULL,
    kategori_pelanggaran  VARCHAR(100) NOT NULL,
    pasal_pelanggaran     VARCHAR(255) NOT NULL,
    PRIMARY KEY (kode_pelanggaran)
);

-- Tabel Transaksi
CREATE TABLE detail_pelanggaran (
    no_referensi_sistem  VARCHAR(40)  NOT NULL,
    id_kamera            VARCHAR(20)  NOT NULL,
    kode_pelanggaran     VARCHAR(10)  NOT NULL,
    waktu_capture        DATETIME     NOT NULL,
    kecepatan_tercatat   SMALLINT UNSIGNED NOT NULL,  -- km/jam
    PRIMARY KEY (no_referensi_sistem),
    CONSTRAINT fk_detail_kamera
        FOREIGN KEY (id_kamera) REFERENCES kamera(id_kamera)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_detail_pasal
        FOREIGN KEY (kode_pelanggaran) REFERENCES aturan_pasal(kode_pelanggaran)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------------------
-- B. TABEL TAMBAHAN REMEDI: bukti_foto (ENTITAS LEMAH)
-- ---------------------------------------------------------------------
CREATE TABLE bukti_foto (
    no_referensi_sistem  VARCHAR(40)  NOT NULL,
    urutan_foto          TINYINT UNSIGNED NOT NULL,
    jenis_foto           VARCHAR(20)  NOT NULL,
    nama_file            VARCHAR(150) NOT NULL,
    ukuran_kb            INT UNSIGNED NOT NULL,
    waktu_rekam          DATETIME     NOT NULL,
    PRIMARY KEY (no_referensi_sistem, urutan_foto),
    CONSTRAINT chk_urutan_foto CHECK (urutan_foto BETWEEN 1 AND 10),
    CONSTRAINT chk_jenis_foto  CHECK (jenis_foto IN ('Kendaraan','Plat Nomor','Situasi')),
    CONSTRAINT chk_ukuran_kb   CHECK (ukuran_kb > 0),
    CONSTRAINT uq_nama_file    UNIQUE (nama_file),
    CONSTRAINT fk_bukti_detail
        FOREIGN KEY (no_referensi_sistem) REFERENCES detail_pelanggaran(no_referensi_sistem)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- C. INDEX
-- ---------------------------------------------------------------------
CREATE INDEX idx_bukti_waktu ON bukti_foto(waktu_rekam);

-- ---------------------------------------------------------------------
-- D. DATA UJI
-- ---------------------------------------------------------------------
INSERT INTO kamera (id_kamera, lokasi_kamera, batas_kecepatan) VALUES
('CAM-TOL-548', 'SPEEDCAM TOL KM 548+450 A JSN', 120),
('CAM-TOL-549', 'SPEEDCAM TOL KM 548+300 A JSN', 120),
('CAM-MDN-001', 'SPEEDCAM JL. A. YANI MADIUN', 60);

INSERT INTO aturan_pasal (kode_pelanggaran, kategori_pelanggaran, pasal_pelanggaran) VALUES
('PLG-01', 'Melanggar Batas Kecepatan', 'Pasal 287 ayat (5) jo Pasal 106'),
('PLG-02', 'Tidak Menggunakan Sabuk Pengaman', 'Pasal 289'),
('PLG-03', 'Menerobos Lampu Merah', 'Pasal 287 ayat (2)');

INSERT INTO detail_pelanggaran
(no_referensi_sistem, id_kamera, kode_pelanggaran, waktu_capture, kecepatan_tercatat) VALUES
('910-50639-AE1270CR', 'CAM-TOL-548', 'PLG-01', '2026-03-04 09:42:11', 144),
('910-50640-AE1270CR', 'CAM-TOL-548', 'PLG-02', '2026-03-04 09:42:11', 144),
('910-50641-N4321AB',  'CAM-MDN-001', 'PLG-03', '2026-03-05 07:15:20', 35);

INSERT INTO bukti_foto
(no_referensi_sistem, urutan_foto, jenis_foto, nama_file, ukuran_kb, waktu_rekam) VALUES
('910-50639-AE1270CR', 1, 'Kendaraan',  'ae1270cr_depan.jpg',   820,  '2026-03-04 09:42:11'),
('910-50639-AE1270CR', 2, 'Plat Nomor', 'ae1270cr_plat.jpg',    310,  '2026-03-04 09:42:11'),
('910-50639-AE1270CR', 3, 'Situasi',    'ae1270cr_situasi.jpg', 1050, '2026-03-04 09:42:12'),
('910-50641-N4321AB',  1, 'Plat Nomor', 'n4321ab_plat.jpg',     295,  '2026-03-05 07:15:20');

-- ---------------------------------------------------------------------
-- E. PENGUJIAN
-- ---------------------------------------------------------------------
-- [READ] pelanggaran beserta jumlah foto buktinya
SELECT d.no_referensi_sistem, k.lokasi_kamera, d.waktu_capture,
       d.kecepatan_tercatat, COUNT(b.urutan_foto) AS jumlah_foto
FROM detail_pelanggaran d
JOIN kamera k ON d.id_kamera = k.id_kamera
LEFT JOIN bukti_foto b ON b.no_referensi_sistem = d.no_referensi_sistem
GROUP BY d.no_referensi_sistem, k.lokasi_kamera, d.waktu_capture, d.kecepatan_tercatat;

-- [DELETE] uji CASCADE: foto ikut terhapus bersama pelanggarannya
DELETE FROM detail_pelanggaran WHERE no_referensi_sistem = '910-50641-N4321AB';
SELECT * FROM bukti_foto;
