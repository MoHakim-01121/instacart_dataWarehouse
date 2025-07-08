
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_day_of_week
from "instacart_db"."public"."dim_time"
where order_day_of_week is null



  
  
      
    ) dbt_internal_test