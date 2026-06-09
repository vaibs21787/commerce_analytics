{{
    config(
        materialized='incremental',
        unique_key='order_key',
        incremental_strategy='merge'
    )
}}

with orders as (

    select * from {{ ref('int_orders_with_customers') }}

    {% if is_incremental() %}
        -- only process new orders since last run
        where order_date > (
            select max(order_date) from {{ this }}
        )
    {% endif %}

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

        -- date parts
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
        end as is_pending,

        -- audit columns
        current_timestamp() as dbt_updated_at

    from orders

)

select * from final