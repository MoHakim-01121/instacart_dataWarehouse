-- models/staging/stg_orders.sql

-- Tujuan staging:
-- 1. Menyelaraskan penamaan kolom agar lebih readable
-- 2. Menjaga NULL pada kolom `days_since_prior_order`
-- 3. Mapping hari dari angka ke nama (Sunday–Saturday)
-- 4. Konsistensi struktur dan tipe data untuk model downstream

with source as (

    select *
    from {{ source('instacart', 'orders') }}

),

renamed as (

    select
        order_id,
        user_id,
        order_number,

        -- Mapping 0-6 menjadi nama hari (Bahasa Inggris)
        case order_day_of_week
            when 0 then 'Sunday'
            when 1 then 'Monday'
            when 2 then 'Tuesday'
            when 3 then 'Wednesday'
            when 4 then 'Thursday'
            when 5 then 'Friday'
            when 6 then 'Saturday'
        end as order_day,
        order_hour_of_day as order_hour,
        days_since_prior_order as order_days_gap
    from source

)

select * from renamed
