
  
    

  create  table "instacart_db"."public"."fact_order_items__dbt_tmp"
  
  
    as
  
  (
    -- models/marts/fact/fact_order_items.sql

-- Tujuan:
-- Fakta granular, 1 baris per item produk dalam order.
-- Mereferensikan dimensi: user, order, product, time.

with orders as (
    select * 
    from "instacart_db"."public"."stg_orders"
),

order_products as (
    select * 
    from "instacart_db"."public"."stg_order_products"
),

dim_time as (
    select
        time_id,
        order_day_of_week,
        order_hour
    from "instacart_db"."public"."dim_time"
),

-- Gabungkan order dengan item dan waktu
joined as (
    select
        -- Foreign Key ke dim_user
        o.user_id,

        -- Foreign Key ke dim_order
        o.order_id,
        o.order_number,
        o.days_since_prior_order,

        -- Foreign Key ke dim_product
        op.product_id,
        op.add_to_cart_order,
        op.reordered,

        -- Foreign Key ke dim_time
        t.time_id

    from orders o
    join order_products op 
        on o.order_id = op.order_id

    -- Join waktu berdasarkan kombinasi hari dan jam order
    left join dim_time t
        on o.order_day_of_week = t.order_day_of_week
       and o.order_hour = t.order_hour
)

-- Output akhir: fakta penjualan item per order
select
    user_id,                -- FK ke dim_user
    order_id,               -- FK ke dim_order
    product_id,             -- FK ke dim_product
    time_id,                -- FK ke dim_time

    order_number,
    days_since_prior_order,
    add_to_cart_order,
    reordered
from joined
  );
  