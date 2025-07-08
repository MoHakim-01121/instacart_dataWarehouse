with source as (

    select *
    from "instacart_db"."public"."aisles"

),

cleaned as (

    select
        aisle_id,
        case 
            when trim(aisle) = 'missing' then 'Unknown'
            else trim(aisle)
        end as aisle_name
    from source

)

select * from cleaned