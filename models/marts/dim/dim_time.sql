-- models/marts/dim/dim_time.sql

-- Tujuan:
-- Membangun dimensi waktu dari kombinasi hari dan jam order,
-- digunakan sebagai dimensi waktu granular (harian dan jam) untuk analisis performa waktu.

with base as (

    -- Ambil kombinasi unik hari dan jam order dari staging
    select distinct
        order_day,
        order_hour
    from {{ ref('stg_orders') }}

),

final as (

    select
        -- Surrogate key untuk kombinasi waktu
        {{ dbt_utils.generate_surrogate_key(['order_day', 'order_hour']) }} as time_id,

        -- Rename agar lebih konsisten
        order_day        as day_of_week,
        order_hour       as hour_of_day

    from base

)

select * from final
