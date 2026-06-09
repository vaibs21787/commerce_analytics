-- Test: net_revenue must never be negative
-- Business rule: discounts cannot exceed 100%
-- If this returns any rows → test FAILS

select
    order_key,
    line_number,
    extended_price,
    discount_percentage,
    net_revenue
from {{ ref('fct_order_items') }}
where net_revenue < 0