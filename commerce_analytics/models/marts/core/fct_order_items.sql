with order_items as (

    select * from {{ ref('int_order_items_enriched') }}

),

final as (

    select
        -- primary key (composite)
        order_key,
        line_number,

        -- foreign keys
        part_key,
        supplier_key,
        customer_key,

        -- order context
        order_date,
        order_month,
        order_quarter,
        order_year,
        priority_code,

        -- product details
        part_name,
        manufacturer,
        brand,
        part_type,
        retail_price,

        -- supplier details
        supplier_name,

        -- shipping details
        ship_mode,
        ship_date,
        commit_date,
        receipt_date,
        return_flag,
        line_status,

        -- raw financials
        quantity,
        extended_price,
        discount_percentage,
        tax_rate,

        -- revenue metrics
        net_revenue,
        gross_revenue,
        supply_cost,
        profit_margin,
        margin_percentage,

        -- delivery metrics
        is_late_delivery,
        days_to_ship,
        days_to_deliver,
        days_late,

        -- return metrics
        is_returned,
        revenue_lost_to_returns

    from order_items

)

select * from final