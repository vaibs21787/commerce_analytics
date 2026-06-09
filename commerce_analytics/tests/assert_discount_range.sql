-- Test: discount must be between 0 and 0.10 (0% to 10%)
-- Business rule: max discount allowed is 10%
-- If this returns any rows → test FAILS

select
    order_key,
    line_number,
    discount_percentage
from {{ ref('fct_order_items') }}
where discount_percentage < 0
   or discount_percentage > 0.10