with orders as (

    select * from {{ ref('int_orders_with_customers') }}

),

final as (

    select
        -- primary key
        order_key,

        -- foreign keys
        customer_key,

        -- order details
        status_code,
        priority_code,
        clerk_name,
        order_date,

        -- customer context
        customer_name,
        market_segment,
        customer_balance,

        -- geography
        nation_name,
        region_name,

        -- financials
        total_price,

        -- date parts (useful for BI tools)
        date_trunc('month', order_date)   as order_month,
        date_trunc('quarter', order_date) as order_quarter,
        year(order_date)                  as order_year,

        -- order status flags
        case
            when status_code = 'F' then true
            else false
        end as is_fulfilled,

        case
            when status_code = 'O' then true
            else false
        end as is_open,

        case
            when status_code = 'P' then true
            else false
        end as is_pending

    from orders

)

select * from final
