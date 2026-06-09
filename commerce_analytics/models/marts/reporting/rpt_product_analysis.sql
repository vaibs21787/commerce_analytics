with order_items as (

    select * from {{ ref('fct_order_items') }}

),

parts as (

    select * from {{ ref('dim_parts') }}

),

final as (

    select
        -- product details
        p.part_key,
        p.part_name,
        p.manufacturer,
        p.brand,
        p.part_type,
        p.type_size,
        p.type_finish,
        p.type_material,
        p.retail_price,
        p.price_segment,

        -- volume metrics
        count(*)                                as total_line_items,
        count(distinct oi.order_key)            as total_orders,
        sum(oi.quantity)                        as total_quantity_sold,

        -- revenue metrics
        sum(oi.net_revenue)                     as total_revenue,
        sum(oi.profit_margin)                   as total_profit,
        avg(oi.margin_percentage)               as avg_margin_pct,
        avg(oi.discount_percentage) * 100       as avg_discount_pct,

        -- return metrics
        sum(case when oi.is_returned 
            then 1 else 0 end)                  as total_returns,

        round(
            sum(case when oi.is_returned 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as return_rate_pct,

        sum(oi.revenue_lost_to_returns)         as revenue_lost_to_returns,

        -- delivery metrics
        round(
            sum(case when not oi.is_late_delivery 
                then 1 else 0 end)
            / nullif(count(*), 0) * 100
        , 2)                                    as on_time_rate_pct

    from order_items oi
    left join parts p
        on oi.part_key = p.part_key

    group by 1,2,3,4,5,6,7,8,9,10

)

select * from final