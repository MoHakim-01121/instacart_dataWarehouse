-- models/marts/dim/dim_product.sql

-- Ambil data dari staging table `stg_products`
with source as (

    select * from "instacart_db"."public"."stg_products"

),

-- Gunakan langsung hasil staging karena pembersihan nama dan validasi FK sudah dilakukan
final as (

    select
        product_id,
        product_name,
        aisle_id,         -- foreign key ke dim_aisle
        department_id     -- foreign key ke dim_department
    from source

)

-- Output akhir berupa dimensi produk
select * from final