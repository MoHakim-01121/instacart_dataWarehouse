
    
    

with child as (
    select time_id as from_field
    from "instacart_db"."public"."fact_order_items"
    where time_id is not null
),

parent as (
    select time_id as to_field
    from "instacart_db"."public"."dim_time"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


