-- NAMA   :BILQIS AUDYNOVA PRASANTY
-- KELAS  : 1C
-- NIM    : 264311063
-- PRODI  : TEKNOLOGI REKAYASA PERANGKAT LUNAK

USE etle_db;

SELECT
    k.lokasi_kamera,
    COUNT(d.no_referensi_sistem)  AS total_pelanggaran,
    AVG(d.kecepatan_tercatat)     AS rata_rata_kecepatan
FROM detail_pelanggaran d
JOIN kamera k ON d.id_kamera = k.id_kamera
WHERE d.kecepatan_tercatat > k.batas_kecepatan
GROUP BY k.lokasi_kamera;
