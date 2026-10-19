-- NAMA   : BILQIS AUDYNOVA PRASANTY
-- KELAS  : 1C
-- NIM    : 264311063
-- PRODI  : TEKNOLOGI REKAYASA PERANGKAT LUNAK
-- UTS PRAKTIK BASIS DATA (Studi Kasus ETLE)

CREATE DATABASE IF NOT EXISTS etle_db;
USE etle_db;

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
