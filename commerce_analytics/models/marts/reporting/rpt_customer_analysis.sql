with orders as (

    select * from {{ ref('fct_orders') }}

),

order_items as (

    select * from {{ ref('fct_order_items') }}

),

customer_metrics as (

    select
        -- customer details
        o.customer_key,
        o.customer_name,
        o.market_segment,
        o.nation_name,
        o.region_name,
        o.customer_balance,

        -- order metrics
        count(distinct o.order_key)         as total_orders,
        min(o.order_date)                   as first_order_date,
        max(o.order_date)                   as last_order_date,
        datediff('day', 
            min(o.order_date), 
            max(o.order_date))              as customer_tenure_days,

        -- revenue metrics
        sum(oi.net_revenue)                 as total_revenue,
        avg(oi.net_revenue)                 as avg_line_item_revenue,
        sum(oi.net_revenue) 
            / nullif(count(distinct o.order_key), 0) as avg_order_value,

        -- product metrics
        sum(oi.quantity)                    as total_items_purchased,

        -- return metrics
        sum(case when oi.is_returned 
            then 1 else 0 end)              as total_returns,
        sum(oi.revenue_lost_to_returns)     as total_revenue_lost,

        -- delivery metrics
        sum(case when oi.is_late_delivery 
            then 1 else 0 end)              as total_late_deliveries,
        avg(oi.days_to_deliver)             as avg_delivery_days

    from orders o
    left join order_items oi
        on o.order_key = oi.order_key

    group by 1,2,3,4,5,6

),

final as (

    select
        *,

        -- customer value segment
        case
            when total_revenue >= 5000000 then 'Platinum'
            when total_revenue >= 1000000 then 'Gold'
            when total_revenue >= 500000  then 'Silver'
            else                               'Bronze'
        end as customer_value_segment,

        -- return rate
        round(
            total_returns 
            / nullif(total_items_purchased, 0) * 100
        , 2) as return_rate_pct,

        -- late delivery rate
        round(
            total_late_deliveries 
            / nullif(total_orders, 0) * 100
        , 2) as late_delivery_rate_pct

    from customer_metrics

)

select * from final