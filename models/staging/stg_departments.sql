with source as (

    select *
    from {{ source('instacart', 'departments') }}

),

cleaned as (

    select
        department_id,
        case 
            when trim(department) = 'missing' then 'Unknown'
            else trim(department)
        end as department_name
    from source

)

select * from cleaned
