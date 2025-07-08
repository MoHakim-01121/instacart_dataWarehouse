
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select time_hour
from "instacart_db"."public"."fact_order_items"
where time_hour is null



  
  
      
    ) dbt_internal_test