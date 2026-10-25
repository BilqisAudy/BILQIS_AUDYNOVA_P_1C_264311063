# UTS: Fitur Bukti Foto Pelanggaran

## 1. Pemodelan Konseptual: ERD Fitur Bukti Foto Pelanggaran

**Nama:** Bilqis Audynova Prasanty | **NIM:** 264311063 | **Kelas:** 1C | **Prodi:** TRPL

**Penambahan proses bisnis:** setiap pelanggaran ETLE wajib disertai satu atau lebih foto bukti (foto kendaraan, foto plat nomor, foto situasi).

```mermaid
erDiagram
    KAMERA ||--o{ DETAIL_PELANGGARAN : menangkap
    ATURAN_PASAL ||--o{ DETAIL_PELANGGARAN : mengatur
    DETAIL_PELANGGARAN ||--|{ BUKTI_FOTO : memiliki

    KAMERA {
        varchar id_kamera PK
        varchar lokasi_kamera
        int batas_kecepatan
    }

    ATURAN_PASAL {
        varchar kode_pelanggaran PK
        varchar kategori_pelanggaran
        varchar pasal_pelanggaran
    }

    DETAIL_PELANGGARAN {
        varchar no_referensi_sistem PK
        varchar id_kamera FK
        varchar kode_pelanggaran FK
        datetime waktu_capture
        int kecepatan_tercatat
    }

    BUKTI_FOTO {
        varchar no_referensi_sistem PK, FK
        int urutan_foto PK
        varchar jenis_foto
        varchar nama_file UK
        int ukuran_kb
        datetime waktu_rekam
    }
```

## Keterangan

| Relasi | Kardinalitas | Keterangan |
|---|---|---|
| KAMERA - DETAIL_PELANGGARAN | 1 : N | Satu kamera menangkap banyak pelanggaran |
| ATURAN_PASAL - DETAIL_PELANGGARAN | 1 : N | Satu pasal mengatur banyak pelanggaran |
| DETAIL_PELANGGARAN - BUKTI_FOTO | 1 : N | Satu pelanggaran memiliki 1..N foto bukti |

`BUKTI_FOTO` adalah **entitas lemah**: tidak dapat berdiri sendiri tanpa `DETAIL_PELANGGARAN`, sehingga primary key-nya gabungan (`no_referensi_sistem` + `urutan_foto`).

Script SQL: [uts_remedi_bilqis.sql](uts_remedi_bilqis.sql)
