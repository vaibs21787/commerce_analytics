with order_items as (

    select * from {{ ref('fct_order_items') }}

),

suppliers as (

    select * from {{ ref('dim_suppliers') }}

),

final as (

    select
        -- supplier details
        s.supplier_key,
        s.supplier_name,
        s.nation_name,
        s.region_name,
        s.account_balance,
        s.balance_segment,

        -- volume metrics
        count(*)                                as total_line_items,
        count(distinct oi.order_key)            as total_orders,
        sum(oi.quantity)                        as total_quantity,

        -- revenue metrics
        sum(oi.net_revenue)                     as total_revenue,
        sum(oi.supply_cost)                     as total_supply_cost,
        sum(oi.profit_margin)                   as total_profit,
        avg(oi.margin_percentage)               as avg_margin_pct,

        -- delivery metrics
        sum(case when oi.is_late_delivery 
            then 1 else 0 end)                  as total_late_deliveries,

        round(
            sum(case when oi.is_late_delivery 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as late_delivery_rate_pct,

        round(
            sum(case when not oi.is_late_delivery 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as on_time_rate_pct,

        avg(oi.days_to_deliver)                 as avg_delivery_days,

        -- return metrics
        sum(case when oi.is_returned 
            then 1 else 0 end)                  as total_returns,

        round(
            sum(case when oi.is_returned 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as return_rate_pct,

        sum(oi.revenue_lost_to_returns)         as revenue_lost_to_returns

    from order_items oi
    left join suppliers s
        on oi.supplier_key = s.supplier_key

    group by 1,2,3,4,5,6

)

select * from final