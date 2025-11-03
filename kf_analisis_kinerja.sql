-- ============================================================
-- TABEL ANALISA KIMIA FARMA 2020-2023
-- Disimpan sebagai tabel baru: kimia_farma.kf_analisis_kinerja
-- Author: Rafika Az Zahra Kusumastuti
-- ============================================================

-- ============================================================
-- 1. KUERI UTAMA: MEMBUAT TABEL ANALISIS (DATA MART)
-- ============================================================

CREATE OR REPLACE TABLE `rakamin-kf-analytics-476004.kimia_farma.kf_analisis_kinerja` AS
SELECT
    -- Identitas transaksi dan waktu
    t.transaction_id,
    t.date,
    EXTRACT(YEAR FROM t.date) AS year, -- Kolom Tahun untuk filter dan tren
    
    -- Informasi cabang (dari kf_kantor_cabang)
    c.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang, -- Penilaian konsumen terhadap cabang
    
    -- Informasi customer & produk
    t.customer_name,
    t.product_id,
    p.product_name,
    
    -- Harga dan diskon
    t.price AS actual_price,
    t.discount_percentage, -- Persentase Diskon (diasumsikan dalam bentuk angka 0-100)
    
    -- Menghitung Persentase Gross Laba berdasarkan ketentuan harga
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS persentase_gross_laba,
    
    -- Menghitung Nett Sales (harga setelah diskon)
    (t.price * (1 - t.discount_percentage/100)) AS nett_sales,
    
    -- Menghitung Nett Profit (Keuntungan)
    (t.price * (1 - t.discount_percentage/100)) * (CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END) AS nett_profit,
    
    -- Mengambil rating dari tabel transaksi
    t.rating AS rating_transaksi
    
FROM 
    `rakamin-kf-analytics-476004.kimia_farma.kf_final_transaction` t
LEFT JOIN 
    `rakamin-kf-analytics-476004.kimia_farma.kf_product` p
    ON t.product_id = p.product_id
LEFT JOIN 
    `rakamin-kf-analytics-476004.kimia_farma.kf_kantor_cabang` c
    ON t.branch_id = c.branch_id;

-- ============================================================
-- 2. KUERI TAMBAHAN: TOP KATEGORI PRODUK BERDASARKAN NETT PROFIT
-- ============================================================
SELECT
    p.product_category,
    SUM(a.nett_profit) AS total_nett_profit
FROM
    -- Menggunakan tabel analisis yang sudah Anda buat
    `rakamin-kf-analytics-476004.kimia_farma.kf_analisis_kinerja` AS a
LEFT JOIN
    -- Menggabungkan dengan tabel produk untuk mendapatkan nama kategori
    `rakamin-kf-analytics-476004.kimia_farma.kf_product` AS p
    ON a.product_id = p.product_id -- Join pada product_id
GROUP BY
    p.product_category
ORDER BY
    total_nett_profit DESC
LIMIT 10;