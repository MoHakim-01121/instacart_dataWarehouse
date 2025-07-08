-- models/marts/dim/dim_department.sql

-- Ambil data dari staging table `stg_departments`
with source as (

    select * from {{ ref('stg_departments') }}

),

-- Tidak ada transformasi tambahan karena sudah dibersihkan di staging
final as (

    select
        department_id,
        department_name
    from source

)

-- Output akhir berupa dimensi department
select * from final
