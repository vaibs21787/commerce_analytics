with suppliers as (

    select * from {{ ref('int_suppliers_with_geography') }}

),

final as (

    select
        -- primary key
        supplier_key,

        -- supplier details
        supplier_name,
        supplier_address,
        phone_number,
        account_balance,

        -- geography
        nation_name,
        region_name,

        -- account status
        {{ get_balance_segment('account_balance') }} as balance_segment

    from suppliers

)

select * from final