-- models/marts/dim/dim_user.sql

-- Tujuan:
-- Membangun dimensi pengguna berdasarkan riwayat pemesanan.
-- Fokus pada total order, rata-rata jeda antar order, dan order terakhir.

with base as (
    select
        user_id,
        order_number,
        days_gap
    from {{ ref('stg_orders') }}
),

agg as (
    select
        user_id,

        -- Total jumlah order yang dilakukan user
        count(*) as total_orders,

        -- Rata-rata hari antar order (dibulatkan 0 angka desimal)
        round(avg(days_gap)::numeric, 0) as avg_days_between_orders,

        -- Nomor order terakhir yang dilakukan user
        max(order_number) as last_order_number,

        -- Jeda hari dari order terakhir yang tercatat
        max(days_gap) as days_since_last_order
    from base
    group by user_id
)

select * from agg
