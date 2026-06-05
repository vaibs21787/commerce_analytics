with line_items as (

    select * from {{ ref('stg_lineitem') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

parts as (

    select * from {{ ref('stg_parts') }}

),

suppliers as (

    select * from {{ ref('stg_suppliers') }}

),

part_suppliers as (

    select * from {{ ref('stg_partsupp') }}

),

final as (

    select
        -- primary key (composite)
        li.order_key,
        li.line_number,

        -- foreign keys
        li.part_key,
        li.supplier_key,
        o.customer_key,

        -- order context
        o.order_date,
        o.priority_code,

        -- product details
        p.part_name,
        p.manufacturer,
        p.brand,
        p.part_type,
        p.retail_price,

        -- supplier details
        s.supplier_name,

        -- shipping details
        li.ship_mode,
        li.ship_date,
        li.commit_date,
        li.receipt_date,
        li.return_flag,
        li.line_status,

        -- raw financials
        li.quantity,
        li.extended_price,
        li.discount_percentage,
        li.tax_rate,

        -- REVENUE CALCULATIONS (Finance Team)
        round(
            li.extended_price * (1 - li.discount_percentage)
        , 2) as net_revenue,

        round(
            li.extended_price * (1 - li.discount_percentage) * (1 + li.tax_rate)
        , 2) as gross_revenue,

        ps.supply_cost,

        round(
            li.extended_price * (1 - li.discount_percentage) - ps.supply_cost
        , 2) as profit_margin,

        round(
            (li.extended_price * (1 - li.discount_percentage) - ps.supply_cost)
            / nullif(li.extended_price * (1 - li.discount_percentage), 0) * 100
        , 2) as margin_percentage,

        -- DELIVERY FLAGS (Operations Team)
        case
            when li.receipt_date > li.commit_date then true
            else false
        end as is_late_delivery,

        datediff('day', o.order_date, li.ship_date)     as days_to_ship,
        datediff('day', o.order_date, li.receipt_date)  as days_to_deliver,

        case
            when li.receipt_date > li.commit_date
            then datediff('day', li.commit_date, li.receipt_date)
            else 0
        end as days_late,

        -- RETURN FLAGS (Operations + Finance)
        case
            when li.return_flag = 'R' then true
            else false
        end as is_returned,

        case
            when li.return_flag = 'R'
            then round(li.extended_price * (1 - li.discount_percentage), 2)
            else 0
        end as revenue_lost_to_returns

    from line_items li
    left join orders o
        on li.order_key = o.order_key
    left join parts p
        on li.part_key = p.part_key
    left join suppliers s
        on li.supplier_key = s.supplier_key
    left join part_suppliers ps
        on li.part_key = ps.part_key
        and li.supplier_key = ps.supplier_key

)

select * from final