
    
    

select
    time_id as unique_field,
    count(*) as n_records

from "instacart_db"."public"."dim_time"
where time_id is not null
group by time_id
having count(*) > 1


