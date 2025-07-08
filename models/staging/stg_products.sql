-- Tujuan staging:
-- 1. Membersihkan spasi di nama produk
-- 2. Menstandarisasi nilai 'missing' menjadi 'Unknown'
-- 3. Menjaga tipe data dan validasi foreign key (aisle_id, department_id)
-- 4. Mengikuti pattern dbt: source → cleaned → final select

with source as (

    select *
    from {{ source('instacart', 'products') }}

),

cleaned as (

    select
        product_id,
        case 
            when trim(product_name) = 'missing' then 'Unknown'
            else trim(product_name)
        end as product_name,
        aisle_id,
        department_id
    from source

)

select * from cleaned
