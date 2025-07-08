# 📦 Instacart Data Warehouse with dbt & PostgreSQL

Proyek ini membangun **Data Warehouse** dari dataset **Instacart** menggunakan **dbt (Data Build Tool)** dan **PostgreSQL**. Proyek mencakup proses **ETL/ELT** lengkap: mulai dari pemuatan data mentah, pembersihan, transformasi, pembuatan tabel dimensi & fakta (star schema), hingga testing dan dokumentasi otomatis.

---

## 🧭 Roadmap Tahapan Proyek

| Tahap | Nama Tahap                      | Tujuan                                                                 |
|-------|----------------------------------|------------------------------------------------------------------------|
| 1     | **Analisis & Perancangan**      | Memahami struktur data & merancang **star schema**                    |
| 2     | **Load Raw Data**               | Memuat data CSV ke PostgreSQL atau menggunakan `dbt seed`             |
| 3     | **Staging Layer**               | Membersihkan, menstandarisasi, dan memvalidasi data mentah            |
| 4     | **Intermediate Layer** (Opsional) | Transformasi tambahan sebelum masuk ke mart                         |
| 5     | **Dimensi dan Fakta (Mart)**    | Membangun tabel **dimensi dan fakta** (berbasis star schema)          |
| 6     | **Testing & Dokumentasi**       | Menambahkan test di `schema.yml` dan dokumentasi dengan `dbt docs`    |
| 7     | **Deployment & Automasi** (Opsional) | Deploy lokal, atau automasi via scheduler/dbt Cloud               |

---

## 📦 Dataset

[Dataset](https://www.kaggle.com/datasets/psparks/instacart-market-basket-analysis) berasal dari kompetisi Instacart Market Basket Analysis. Tabel-tabel mentah dimuat melalui `dbt seed` dan `psql`.

### Tabel Mentah:
- `aisles`: Data rak tempat produk berada
- `departments`: Kategori produk tingkat atas
- `products`: Produk individual
- `orders`: Informasi pesanan (user_id, waktu, urutan)
- `order_products`: Detail produk per pesanan (gabungan prior + train)

---


## 🧰 Teknologi dan Tools

- **dbt**: Data Build Tool untuk transformasi SQL modular
- **PostgreSQL**: Data warehouse tempat penyimpanan data
- **VSCode** / Terminal: Pengembangan lokal
- **dbt Docs**: Dokumentasi otomatis model SQL
- **metabase**: untuk visualisasi /BI (contoh)

---

## 📊 Star Schema

![Star Schema](images/image1.png)

Fakta utama:
- `fact_order_items` (1 baris per produk dalam 1 order)

Dimensi:
- `dim_user`
- `dim_product` (snowflake ke `dim_aisle` dan `dim_department`)
- `dim_order`
- `dim_time`

## 🛠️ Proses ELT

1. Load file CSV ke PostgreSQL (via `dbt seed` dan `psql`)
2. Bersihkan dan validasi di **layer staging**
3. Bangun dimensi dan fakta di **mart layer**
4. Tambahkan **test otomatis** dan **dokumentasi**
5. Generate dokumentasi dengan `dbt docs generate`

## 📌 Tujuan Analisis

- Mengetahui produk dan kategori paling laris
- Menganalisis perilaku pelanggan (reorder, frekuensi belanja)
- Distribusi waktu pembelian (jam dan hari)
- Rekomendasi produk dan loyalitas

## 🚀 Cara Menjalankan

```bash
# Jalankan di environment dbt
dbt seed
dbt run
dbt test
dbt docs generate && dbt docs serve




