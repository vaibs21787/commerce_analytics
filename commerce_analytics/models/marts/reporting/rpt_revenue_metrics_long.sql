with revenue_data as (

    select * from {{ ref('rpt_revenue_analysis') }}

),

unpivoted as (

    -- Revenue after discount
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'net_revenue'                   as metric_name,
        'Revenue'                       as metric_category,
        'USD'                           as metric_unit,
        net_revenue                     as metric_value
    from revenue_data

    union all

    -- Gross revenue after tax
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'gross_revenue_after_tax'       as metric_name,
        'Revenue'                       as metric_category,
        'USD'                           as metric_unit,
        gross_revenue_after_tax         as metric_value
    from revenue_data

    union all

    -- Total profit
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'total_profit'                  as metric_name,
        'Revenue'                       as metric_category,
        'USD'                           as metric_unit,
        total_profit                    as metric_value
    from revenue_data

    union all

    -- Total orders
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'total_orders'                  as metric_name,
        'Volume'                        as metric_category,
        'Count'                         as metric_unit,
        total_orders                    as metric_value
    from revenue_data

    union all

    -- Total quantity
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'total_quantity'                as metric_name,
        'Volume'                        as metric_category,
        'Count'                         as metric_unit,
        total_quantity                  as metric_value
    from revenue_data

    union all

    -- Average order value
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'avg_order_value'               as metric_name,
        'Efficiency'                    as metric_category,
        'USD'                           as metric_unit,
        avg_order_value                 as metric_value
    from revenue_data

    union all

    -- Average margin %
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'avg_margin_pct'                as metric_name,
        'Efficiency'                    as metric_category,
        'Percentage'                    as metric_unit,
        avg_margin_pct                  as metric_value
    from revenue_data

    union all

    -- Average discount %
    select
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,
        'avg_discount_pct'              as metric_name,
        'Efficiency'                    as metric_category,
        'Percentage'                    as metric_unit,
        avg_discount_pct                as metric_value
    from revenue_data

),

final as (

    select
        -- dimensions
        order_date,
        order_month,
        order_quarter,
        order_year,
        region_name,
        nation_name,
        market_segment,
        manufacturer,
        ship_mode,

        -- metric details
        metric_name,
        metric_category,
        metric_unit,
        metric_value,

        -- rounded value for display
        round(metric_value, 2)          as metric_value_rounded

    from unpivoted
    where metric_value is not null

)

select * from final