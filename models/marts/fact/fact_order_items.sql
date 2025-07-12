-- models/marts/fact/fact_order_items.sql

-- Tujuan:
-- Fakta granular per item produk dalam order.
-- Dibentuk dari dimensi yang sudah dibersihkan: dim_order, dim_product, dim_time.

with order_products as (

    -- Masih dari stg karena belum ada dim_order_products
    select
        order_id,
        product_id,
        add_to_cart_order,
        reordered
    from {{ ref('stg_order_products') }}

),

dim_order as (
    select
        order_id,
        user_id,
        order_number,
        order_day,
        order_hour,
        order_days_gap
    from {{ ref('dim_order') }}
),

dim_product as (
    select
        product_id
    from {{ ref('dim_product') }}
),

dim_time as (
    select
        time_id,
        day_of_week,
        hour_of_day
    from {{ ref('dim_time') }}
),

joined as (

    select
        -- FK ke dim_user (via dim_order)
        o.user_id,

        -- FK ke dim_order
        o.order_id,
        o.order_number,
        o.order_days_gap,

        -- FK ke dim_product
        op.product_id,
        op.add_to_cart_order,
        op.reordered,

        -- FK ke dim_time
        t.time_id

    from order_products op
    inner join dim_order o
        on o.order_id = op.order_id

    inner join dim_product p
        on p.product_id = op.product_id

    left join dim_time t
        on o.order_day = t.day_of_week
       and o.order_hour = t.hour_of_day
)

select
    user_id,               -- FK ke dim_user
    order_id,              -- FK ke dim_order
    product_id,            -- FK ke dim_product
    time_id,               -- FK ke dim_time
    order_number,
    order_days_gap,
    add_to_cart_order,
    reordered
from joined
