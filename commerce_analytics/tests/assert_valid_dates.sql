-- Test: receipt_date must be after ship_date
-- Business rule: you cannot receive before shipping
-- If this returns any rows → test FAILS

select
    order_key,
    line_number,
    ship_date,
    receipt_date,
    commit_date
from {{ ref('fct_order_items') }}
where receipt_date < ship_date