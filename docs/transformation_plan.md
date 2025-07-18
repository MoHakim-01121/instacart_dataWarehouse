# Rencana Transformasi Proyek Instacart Data Warehouse

Dokumen ini menjelaskan rencana transformasi data yang dilakukan dalam proyek Instacart Data Warehouse menggunakan dbt dan PostgreSQL.

## Pendekatan ELT

Transformasi dilakukan dengan pendekatan modern ELT (Extract, Load, Transform), memanfaatkan kekuatan SQL dan dbt untuk:
- Pembersihan data
- Validasi struktur
- Pembentukan model analitik

## Eksplorasi dan Kualitas Data

Langkah awal sebelum transformasi:
- Memahami struktur dataset
- Mengecek kualitas data mentah (jumlah baris, nilai null, distribusi)
- Identifikasi anomali seperti nilai 'missing', referensi FK yang tidak valid
- Memastikan tipe data sudah sesuai

## HLD
![High level diagram](https://raw.githubusercontent.com/MoHakim-01121/instacart_dataWarehouse/main/image/imagerev.png)

## Transformasi per Model

### Staging Layer (`models/staging/`)

| Model dbt               | Transformasi                                                                 |
|-------------------------|------------------------------------------------------------------------------|
| `stg_orders.sql`        | - Rename kolom: `order_hour_of_day → order_hour`, `days_since_prior_order → order_days_gap`<br>- Cast tipe data ke integer<br>- NULL handling kolom `days_since_prior_order` |
| `stg_products.sql`      | - Trim spasi dan lowercase `product_name`<br>- Ganti `'missing'` menjadi `'Unknown'`<br>- Validasi FK ke `aisle_id`, `department_id` |
| `stg_aisles.sql`        | - Rename `aisle` menjadi `aisle_name`<br>- Trim dan lowercase `aisle_name`<br>- Ganti `'missing'` menjadi `'Unknown'` |
| `stg_departments.sql`   | - Rename `department` menjadi `department_name`<br>- Trim dan lowercase `department_name`<br>- Ganti `'missing'` menjadi `'Unknown'` |
| `stg_order_products.sql`| - Validasi FK ke `order_id`, `product_id`<br>- Cast tipe data, filter nilai NULL |

### Mart Layer - Dimensi (`models/marts/dim/`)

| Model dbt         | Transformasi                                                                           |
|-------------------|----------------------------------------------------------------------------------------|
| `dim_user.sql`    | - Agregasi: `total_orders`, `avg_days_between_orders`, `last_order_number`, `days_since_last_order`<br>- Berdasarkan data dari `stg_orders` |
| `dim_product.sql` | - Join ke `aisle` dan `department`<br>- Ambil `product_name`, `aisle_id`, `department_id` |
| `dim_aisle.sql`   | - Ambil langsung dari `stg_aisles` tanpa modifikasi tambahan                          |
| `dim_department.sql` | - Ambil dari `stg_departments`                                                    |
| `dim_order.sql`   | - Ambil dari `stg_orders`, simpan `order_number`, `order_hour`, `order_days_gap`       |
| `dim_time.sql`    | - Turunan dari `order_day_of_week` dan `order_hour` untuk mapping `time_id`, `day_name`, `time_hour` |

### Mart Layer - Fakta (`models/marts/fact/`)

| Model dbt              | Transformasi                                                                 |
|------------------------|------------------------------------------------------------------------------|
| `fact_order_items.sql` | - Join `stg_order_products` ke:<br> • `dim_order` → ambil `order_number`, `order_days_gap`, `user_id`<br> • `dim_product` → via `product_id`<br> • `dim_time` → via `order_day`, `order_hour`<br>- Simpan metrik: `add_to_cart_order`, `reordered`<br>- Struktur akhir: `user_id`, `order_id`, `product_id`, `time_id`, `order_number`, `order_days_gap`, `add_to_cart_order`, `reordered` |

## Jenis Transformasi Berdasarkan Fungsi

| Tipe Transformasi    | Contoh Model               | Penjelasan                                   |
|----------------------|----------------------------|----------------------------------------------|
| Standarisasi         | Semua model `stg_*`        | Rename kolom, trim spasi, ubah nilai         |
| Cleaning             | `stg_products`, `stg_orders`, `stg_aisles`, `stg_departments` | Validasi FK, handling NULL |
| Validasi             | `schema.yml`               | Tes otomatis: `not_null`, `unique`, `relationships` |
| Agregasi             | `dim_user`                 | Hitung metrik dari `stg_orders`              |
| Join                 | `fact_order_items`         | Gabungkan semua dimensi ke tabel fakta       |
| Mapping/Metrik       | `dim_time`                 | Mapping jam dan hari menjadi dimensi eksplisit |

## Struktur Data Mart

### Tabel Dimensi

- `dim_user`: Metrik perilaku pelanggan
- `dim_order`: Informasi order (user, waktu, urutan)
- `dim_product`: Produk dengan referensi ke `aisle` dan `department`
- `dim_aisle`: Kategori rak produk
- `dim_department`: Kategori department produk
- `dim_time`: Dimensi waktu berdasarkan kombinasi hari dan jam

### Tabel Fakta

- `fact_order_items`: Fakta granular transaksi berisi semua foreign key ke dimensi dan metrik transaksi (`add_to_cart_order`, `reordered`)

