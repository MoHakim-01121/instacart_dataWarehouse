
    
    

select
    department_id as unique_field,
    count(*) as n_records

from "instacart_db"."public"."dim_department"
where department_id is not null
group by department_id
having count(*) > 1


