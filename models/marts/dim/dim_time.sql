-- models/marts/dim/dim_time.sql

-- Tujuan:
-- Membuat dimensi waktu berdasarkan kombinasi hari dan jam pemesanan.
-- Menambahkan surrogate key 'time_id' agar dapat direlasikan secara eksplisit dengan tabel fakta.

with time_base as (

    -- Ambil kombinasi unik hari dan jam dari data orders
    select distinct
        order_day_of_week,
        order_hour
    from {{ ref('stg_orders') }}

),

enriched as (

    select
        -- Gunakan dbt_utils untuk membuat surrogate key time_id
        {{ dbt_utils.generate_surrogate_key(['order_day_of_week', 'order_hour']) }} as time_id,

        order_day_of_week,

        -- Mapping angka ke nama hari
        case order_day_of_week
            when 0 then 'Sunday'
            when 1 then 'Monday'
            when 2 then 'Tuesday'
            when 3 then 'Wednesday'
            when 4 then 'Thursday'
            when 5 then 'Friday'
            when 6 then 'Saturday'
        end as day_name,

        order_hour,

        -- Format waktu dalam HH:00
        lpad(order_hour::text, 2, '0') || ':00' as time_hour

    from time_base

)

select * from enriched
