with order_items as (

    select * from {{ ref('fct_order_items') }}

),

final as (

    select
        -- time dimensions
        order_date,
        order_month,
        order_quarter,
        order_year,

        -- dimensions
        ship_mode,
        supplier_name,
        manufacturer,

        -- volume metrics
        count(*)                                as total_line_items,
        count(distinct order_key)               as total_orders,

        -- delivery metrics
        sum(case when is_late_delivery 
            then 1 else 0 end)                  as total_late_deliveries,

        round(
            sum(case when is_late_delivery 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as late_delivery_rate_pct,

        round(
            sum(case when not is_late_delivery 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as on_time_delivery_rate_pct,

        avg(days_to_ship)                       as avg_days_to_ship,
        avg(days_to_deliver)                    as avg_days_to_deliver,
        avg(days_late)                          as avg_days_late,
        max(days_late)                          as max_days_late,

        -- revenue impact
        sum(net_revenue)                        as total_revenue,
        sum(case when is_late_delivery 
            then net_revenue else 0 end)        as revenue_from_late_orders

    from order_items
    group by 1,2,3,4,5,6,7

)

select * from final