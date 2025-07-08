
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_hour
from "instacart_db"."public"."fact_order_items"
where order_hour is null



  
  
      
    ) dbt_internal_test