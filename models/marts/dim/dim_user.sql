  -- models/marts/dim_user.sql

  -- Tujuan:
  -- Model ini membentuk dimensi pengguna berdasarkan data order.
  -- Setiap baris mewakili satu user, disertai agregasi statistik perilaku belanja:
  -- 1. total_orders: jumlah pesanan yang pernah dilakukan user
  -- 2. max_order_number: urutan order terakhir (maksimal)
  -- 3. avg_days_between_orders: rata-rata selisih hari antar order (tidak termasuk NULL)

  with orders as (

      -- Mengambil seluruh data dari model staging orders
      select * 
      from {{ ref('stg_orders') }}

  ),

  aggregated as (

      -- Melakukan agregasi per user
      select
          user_id,

          -- Total pesanan (order_id) yang dilakukan user
          count(order_id) as total_orders,

          -- Order terakhir (urutan ke berapa yang paling akhir)
          max(order_number) as max_order_number,

          -- Rata-rata jeda antar order (hanya dihitung jika tidak NULL)
          avg(days_since_prior_order) as avg_days_between_orders

      from orders
      group by user_id

  )

  -- Final result: satu baris per user
  select * from aggregated
    