with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

nations as (

    select * from {{ ref('stg_nation') }}

),

regions as (

    select * from {{ ref('stg_region') }}

),

final as (

    select
        -- order details
        o.order_key,
        o.status_code,
        o.total_price,
        o.order_date,
        o.priority_code,
        o.clerk_name,

        -- customer details
        c.customer_key,
        c.customer_name,
        c.market_segment,
        c.account_balance as customer_balance,

        -- geography
        n.nation_name,
        r.region_name

    from orders o
    left join customers c
        on o.customer_key = c.customer_key
    left join nations n
        on c.nation_key = n.nation_key
    left join regions r
        on n.region_key = r.region_key

)

select * from final