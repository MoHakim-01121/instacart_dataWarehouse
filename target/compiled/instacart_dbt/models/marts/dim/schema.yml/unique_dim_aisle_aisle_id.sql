
    
    

select
    aisle_id as unique_field,
    count(*) as n_records

from "instacart_db"."public"."dim_aisle"
where aisle_id is not null
group by aisle_id
having count(*) > 1


