-- models/marts/dim/dim_aisle.sql

with source as (

    select * from "instacart_db"."public"."stg_aisles"

),

final as (

    select
        aisle_id,
        aisle_name
    from source

)

select * from final