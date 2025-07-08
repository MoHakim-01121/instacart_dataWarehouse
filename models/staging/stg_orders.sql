-- models/staging/stg_orders.sql

-- Tujuan staging:
-- 1. Menyelaraskan penamaan kolom agar lebih readable
-- 2. Menjaga NULL pada kolom `days_since_prior_order`
-- 3. Konsistensi struktur dan tipe data untuk model downstream

with source as (

    select *
    from {{ source('instacart', 'orders') }}

),

renamed as (

    select
        order_id,
        user_id,
        order_number,
        order_day_of_week,       -- Sudah sesuai, tidak perlu rename
        order_hour_of_day as order_hour,    -- Rename untuk konsistensi
        days_since_prior_order
    from source

)

select * from renamed
