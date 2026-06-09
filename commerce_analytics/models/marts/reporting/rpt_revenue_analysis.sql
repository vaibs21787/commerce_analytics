with order_items as (

    select * from {{ ref('fct_order_items') }}

),

orders as (

    select
        order_key,
        market_segment,
        nation_name,
        region_name

    from {{ ref('fct_orders') }}

),

final as (

    select
        -- time dimensions
        oi.order_date,
        oi.order_month,
        oi.order_quarter,
        oi.order_year,

        -- geographic dimensions
        o.region_name,
        o.nation_name,
        o.market_segment,

        -- product dimensions
        oi.manufacturer,
        oi.brand,
        oi.ship_mode,

        -- revenue metrics
        count(distinct oi.order_key)        as total_orders,
        count(*)                            as total_line_items,
        sum(oi.quantity)                    as total_quantity,
        sum(oi.extended_price)              as gross_revenue_before_discount,
        sum(oi.net_revenue)                 as net_revenue,
        sum(oi.gross_revenue)               as gross_revenue_after_tax,
        sum(oi.profit_margin)               as total_profit,
        avg(oi.margin_percentage)           as avg_margin_pct,
        avg(oi.discount_percentage) * 100   as avg_discount_pct,

        -- order value metrics
        sum(oi.net_revenue)
            / nullif(count(distinct oi.order_key), 0) as avg_order_value

    from order_items oi
    left join orders o
        on oi.order_key = o.order_key

    group by 1,2,3,4,5,6,7,8,9,10

)

select * from final