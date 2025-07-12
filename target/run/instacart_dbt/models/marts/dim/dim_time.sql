
  
    

  create  table "instacart_db"."public"."dim_time__dbt_tmp"
  
  
    as
  
  (
    -- models/marts/dim/dim_time.sql

-- Tujuan:
-- Membangun dimensi waktu dari kombinasi hari dan jam order,
-- digunakan sebagai dimensi waktu granular (harian dan jam) untuk analisis performa waktu.

with base as (

    -- Ambil kombinasi unik hari dan jam order dari staging
    select distinct
        order_day,
        order_hour
    from "instacart_db"."public"."stg_orders"

),

final as (

    select
        -- Surrogate key untuk kombinasi waktu
        md5(cast(coalesce(cast(order_day as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(order_hour as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as time_id,

        -- Rename agar lebih konsisten
        order_day        as day_of_week,
        order_hour       as hour_of_day

    from base

)

select * from final
  );
  