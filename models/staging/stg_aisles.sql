{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * 
    from {{ source('instacart', 'aisles') }}

),

cleaned as (

    select
        aisle_id,
        
        -- Bersihkan whitespace, ubah ke lowercase, dan ganti 'missing' atau kosong menjadi 'Unknown'
        case 
            when trim(lower(aisle)) in ('missing', '') then 'Unknown'
            else lower(trim(aisle))
        end as aisle_name

    from source

)

select * from cleaned
