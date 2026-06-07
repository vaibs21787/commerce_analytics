with orders_with_customers as (

    select * from {{ ref('int_orders_with_customers') }}

),

final as (

    select distinct
        -- primary key
        customer_key,

        -- customer details
        customer_name,
        market_segment,
        customer_balance,

        -- geography
        nation_name,
        region_name,

        -- account status
        {{ get_balance_segment('customer_balance') }} as balance_segment

    from orders_with_customers

)

select * from final