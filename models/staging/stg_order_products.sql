-- Tujuan staging:
-- 1. Menstandarisasi nama kolom agar konsisten dan readable
-- 2. Memastikan tipe data eksplisit (integer)
-- 3. Validasi foreign key ke orders dan products
-- 4. Menyaring baris NULL jika diperlukan

with source as (

    select *
    from {{ source('instacart', 'order_products') }}

),

cleaned as (

    select
        cast(order_id as integer) as order_id,
        cast(product_id as integer) as product_id,
        cast(add_to_cart_order as integer) as add_to_cart_order,
        cast(reordered as integer) as reordered
    from source
    where order_id is not null
      and product_id is not null

)

select * from cleaned
