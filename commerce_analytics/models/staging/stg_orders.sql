with source as (

    select * from {{ source('tpch', 'orders') }}

),

renamed as (

    select
        -- primary key
        o_orderkey          as order_key,

        -- foreign keys
        o_custkey           as customer_key,

        -- order details
        o_orderstatus       as status_code,
        o_totalprice        as total_price,
        o_orderdate         as order_date,
        o_orderpriority     as priority_code,
        o_clerk             as clerk_name,
        o_shippriority      as ship_priority,
        o_comment           as order_comment

    from source

)

select * from renamed