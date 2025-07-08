-- models/marts/dim/dim_order.sql

-- Tujuan:
-- Membuat dimensi order lengkap dengan informasi waktu dan urutan order.
-- Digunakan sebagai FK di tabel fakta dan berguna untuk analisis behavior per transaksi/order.

with source as (

    -- Ambil dari hasil staging orders
    select * 
    from "instacart_db"."public"."stg_orders"

),

final as (

    select
        order_id,
        user_id,
        order_number,
        order_day_of_week,
        order_hour,
        days_since_prior_order
    from source

)

-- Output akhir: satu baris per order
select * from final