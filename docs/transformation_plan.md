#  Rencana Transformasi Proyek Instacart Data Warehouse

Dokumen ini menjelaskan rencana transformasi data yang dilakukan dalam proyek 
Instacart Data Warehouse menggunakan dbt + PostgreSQL.


##  Pendekatan ELT

Transformasi dilakukan dengan pendekatan modern ELT (Extract, Load, Transform), memanfaatkan kekuatan 
SQL & dbt untuk melakukan pembersihan, validasi, dan model analitik.


##  Eksplorasi & Kualitas Data

Tahapan awal sebelum transformasi:
- Memahami dataset dan mengeksplor dataset
- Mengecek struktur dan kualitas data mentah dari CSV (jumlah baris, null values, distribusi data)
- Identifikasi anomali seperti nilai 'missing', data kosong, atau referensi FK yang tidak valid
- Memastikan tipe data sesuai (misal angka vs string)

##  Transformasi per Model

### Staging Layer (`models/staging/`)

| Model dbt              | Transformasi                                                                 |
|------------------------|------------------------------------------------------------------------------|
| `stg_orders.sql`       | - Rename kolom (`order_hour_of_day → order_hour`)                            |
|                        | - Cast tipe data ke integer                                                  |
|                        | - NULL handling kolom `days_since_prior_order` (tetap NULL jika order pertama)     |
| `stg_products.sql`     | - Trim spasi, lowercase dan Null handling kolom `product_name`                                   |
|                        | - Ganti `'missing'` jadi `'Unknown'`                                         |
|                        | - Validasi FK ke `aisle_id`, `department_id`                                 |
| `stg_aisles.sql`       | - Rename dari `aisle` menjadi `aisle_name`                                            |
|                        | - Trim dan lowercase `aisle_name`                                            |
|                        | - Ganti `'missing'` jadi `'Unknown'`                                         |
| `stg_departments.sql`  | - Rename `department` menjadi `department_name`                                       |
|                        | - Trim dan lowercase `department_name`                                       |
|                        | - Ganti `'missing'` jadi `'Unknown'`                                         |
| `stg_order_products.sql`| - Validasi FK ke `order_id`, `product_id`                                   |
|                        | - Cast tipe data, filter NULL                                                |



### Mart Layer - Dimensi (`models/marts/dim/`)


| Model dbt         | Transformasi                                                                           |
|-------------------|----------------------------------------------------------------------------------------|
| `dim_user.sql`    | - Agregasi `total_orders`, `max_order_number`, `avg_days_between_orders` per `user_id` |
| `dim_product.sql` | - Join ke `aisle` & `department` via FK (snowflake)                                   |
|                  | - Ambil `product_name`, `aisle_id`, `department_id`                                    |
| `dim_aisle.sql`   | - Ambil dari `stg_aisles` tanpa modifikasi tambahan                                   |
| `dim_department.sql`| - Ambil dari `stg_departments`                                                      |
| `dim_order.sql`   | - Ambil dari `stg_orders`, simpan info seperti `order_number`, `order_hour`, dll      |
| `dim_time.sql`    | - Turunan dari `order_hour`, `order_day_of_week` untuk mapping `time_id`, `day_name`, `time_hour` |



### Mart Layer - Fakta (`models/marts/fact/`)

| Model dbt              | Transformasi                                                                 |
|------------------------|------------------------------------------------------------------------------|
| `fact_order_items.sql` | - Join dari `stg_order_products` ke:                                         |
|                        |   - `dim_order` → ambil `order_number`, `days_since_prior_order`             |
|                        |   - `dim_user` → via `user_id`                                               |
|                        |   - `dim_product` → via `product_id`                                         |
|                        |   - `dim_time` → via `order_hour`, `order_day_of_week`                       |
|                        | - Simpan fakta granular: `add_to_cart_order`, `reordered`                    |



##  Jenis Transformasi Berdasarkan Fungsi

| Tipe Transformasi  | Contoh Model               | Penjelasan Singkat                        |
|-------------------|----------------------------|-------------------------------------------|
| **Standarisasi**   | Semua stg model            | Rename kolom, trim spasi, ubah nilai      |
| **Cleaning**       | stg_products, stg_orders,stg_aisle, stg_department  | Validasi FK, handling NULL                |
| **Validasi**       | schema.yml (tests)         | `not_null`, `unique`, `relationships`     |
| **Agregasi**       | dim_user                   | Agregasi metrik dari stg_orders           |
| **Join**           | fact_order_items           | Gabungkan semua dimensi ke tabel fakta    |
| **Mapping/Metrik** | dim_time                   | Mapping jam & hari jadi dimensi eksplisit |


