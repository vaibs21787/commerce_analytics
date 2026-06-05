with source as (

    select * from {{ source('tpch', 'partsupp') }}

),

renamed as (

    select
        -- composite primary key
        ps_partkey          as part_key,
        ps_suppkey          as supplier_key,

        -- part supplier details
        ps_availqty         as available_quantity,
        ps_supplycost       as supply_cost,
        ps_comment          as partsupp_comment

    from source

)

select * from renamed