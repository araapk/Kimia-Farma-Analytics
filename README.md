## Author
**Rafika Az Zahra Kusumastuti**

Big Data Analytics - Rakamin Academy

Mahasiswa Teknologi Informasi, Institut Teknologi Sepuluh Nopember (ITS)

# Analisis Kinerja Bisnis Kimia Farma (2020–2023)
Repositori ini berisi proyek analisis data end-to-end untuk mengevaluasi performa bisnis Kimia Farma selama tahun 2020–2023.
Proyek ini dilakukan menggunakan **Google BigQuery** untuk pemrosesan data dan **Looker Studio** untuk visualisasi dashboard interaktif.

Analisis mencakup pembuatan data mart, perhitungan metrik bisnis (nett sales, nett profit, rating, dan lainnya), hingga eksplorasi performa cabang, provinsi, dan kategori produk.

---
## Tujuan Proyek
* Mengolah data mentah menjadi **tabel analisis (data mart)** yang siap digunakan untuk reporting
* Mengidentifikasi **tren penjualan dan profitabilitas** dari tahun ke tahun
* Menentukan **kategori produk dan cabang dengan kinerja terbaik**
* Menyediakan **dashboard interaktif** untuk kebutuhan monitoring bisnis
---
## Struktur Repository
```
PERFORMANCE ANALYTICS KIMIA FARMA BUSINESS YEAR 2020-2023/
│
├── kf_analisis_kinerja.sql
│       └─ Query utama: pembuatan data mart + query analisis lanjutan
│
├── TABEL ANALISIS (DATA MART).xlsx
│       └─ Export tabel kf_analisis_kinerja (sample data hasil query)
│
└── TOP KATEGORI PRODUK BERDASARKAN NETT PROFIT.xlsx
        └─ Hasil query Top 8 kategori produk berdasarkan nett profit
```

---
## Dataset yang Digunakan
Seluruh dataset berasal dari BigQuery dengan schema: `kimia_farma`
| Tabel                  | Fungsi                                                                                     |
| ---------------------- | ------------------------------------------------------------------------------------------ |
| `kf_final_transaction` | Data transaksi lengkap (harga, diskon, rating, customer, tanggal, branch_id, dsb)          |
| `kf_product`           | Dimensi produk (product_id, product_name, product_category)                                |
| `kf_kantor_cabang`     | Dimensi cabang (lokasi, provinsi, rating cabang, dsb)                                      |
| `kf_inventory`         | Data stok per cabang per produk (**tersedia tetapi tidak digunakan dalam analisis akhir**) |

---

## SQL Utama: Pembuatan Data Mart
File: `kf_analisis_kinerja.sql`

### Transformasi yang dilakukan:
* Join transaksi + produk + cabang
* Penambahan kolom turunan:
  * `persentase_gross_laba` (10–30% tergantung harga)
  * `nett_sales` (harga akhir setelah diskon)
  * `nett_profit` (nett_sales × persentase_gross_laba)
  * `year` (ekstraksi tahun)
* Tabel final disimpan sebagai:
```
kimia_farma.kf_analisis_kinerja
```

---
## Query Analisis Tambahan
Masih dalam file yang sama ditambahkan visualisasi untuk **Top 8 kategori produk berdasarkan total nett profit**

Output disimpan dalam file `TOP KATEGORI PRODUK BERDASARKAN NETT PROFIT.xlsx`

---
## Dashboard Looker Studio
Dashboard berisi visualisasi berikut:
| Komponen Dashboard                                 | Visualisasi                                                                                               |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Branch Name, Date, Provinsi, Kota                  | Dropdown                                                                                                  |
| Total Nett Sales, Total Nett Profit, Total Transaksi, Rata-rata Rating Transaksi, Rata-rata Rating Cabang                                         | KPI Bisnis |
| Peta Profit per Provinsi                           | Bubble Map                                                                                                |
| Tren Penjualan                                     | Time Series Chart (Nett Sales Over Time)                                                                  |
| Top 10 Cabang berdasarkan Profit                   | Bar Chart                                                                                                 |
| Top 10 Cabang berdasarkan Total Transaksi          | Bar Chart                                                                                                 |
| Top 5 Cabang: Rating Tinggi namun Transaksi Rendah | Table                                                                                                     |
| Top 8 Kategori Produk berdasarkan Nett Profit      | Table                                                                                                     |

Dashboard:
[https://lookerstudio.google.com/reporting/88884276-d846-49f2-bc2e-edd2c72b463a](https://lookerstudio.google.com/reporting/88884276-d846-49f2-bc2e-edd2c72b463a)

---
## Business Metrics yang Dihitung
| Kolom                   | Perhitungan                               |
| ----------------------- | ----------------------------------------- |
| `nett_sales`            | `price * (1 - discount_percentage/100)`   |
| `persentase_gross_laba` | CASE harga (10–30%)                       |
| `nett_profit`           | `nett_sales * persentase_gross_laba`      |
| `year`                  | `EXTRACT(YEAR FROM date)`                 |
| `rating_transaksi`      | Rating per transaksi                      |
| `rating_cabang`         | Rating cabang dari tabel kf_kantor_cabang |

---
## Tools & Teknologi
| Tools              | Kegunaan                               |
| ------------------ | -------------------------------------- |
| Google BigQuery    | Processing data, SQL, data warehouse   |
| Looker Studio      | Dashboard dan visualisasi data         |
| SQL                | Transformasi data dan kalkulasi bisnis |
| Visual Studio Code | Penulisan query & manajemen file       |
| GitHub             | Dokumentasi & version control          |

---
## Cara Menjalankan Proyek
1. Import dataset ke BigQuery
2. Jalankan query `kf_analisis_kinerja.sql` untuk membuat data mart
3. Hubungkan Looker Studio ke tabel `kimia_farma.kf_analisis_kinerja`
4. Buat visualisasi dashboard atau gunakan link dashboard yang telah disediakan
5. (Opsional) Jalankan query analisis tambahan untuk eksplorasi data lanjutan

---


