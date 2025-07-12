-- models/marts/dim/dim_order.sql

-- Tujuan:
-- Dimensi order yang menyimpan informasi urutan, waktu, dan jeda antar order.
-- Menggunakan nama kolom hasil dari stg_orders (tanpa rename ulang).

select
    order_id,
    user_id,
    order_number,
    order_day,
    order_hour,
    order_days_gap
from {{ ref('stg_orders') }}
