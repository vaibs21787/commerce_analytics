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
        manufacturer,
        brand,
        part_type,
        supplier_name,
        ship_mode,

        -- volume metrics
        count(*)                                as total_line_items,
        sum(quantity)                           as total_quantity,

        -- return metrics
        sum(case when is_returned 
            then 1 else 0 end)                  as total_returns,

        round(
            sum(case when is_returned 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as return_rate_pct,

        -- revenue metrics
        sum(net_revenue)                        as total_revenue,
        sum(revenue_lost_to_returns)            as total_revenue_lost,

        round(
            sum(revenue_lost_to_returns)
            / nullif(sum(net_revenue), 0) * 100
        , 2)                                    as revenue_lost_pct,

        avg(net_revenue)                        as avg_revenue_per_line

    from order_items
    group by 1,2,3,4,5,6,7,8,9

)

select * from final