
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select add_to_cart_order
from "instacart_db"."public"."fact_order_items"
where add_to_cart_order is null



  
  
      
    ) dbt_internal_test