with suppliers as (

    select * from {{ ref('stg_suppliers') }}

),

nations as (

    select * from {{ ref('stg_nation') }}

),

regions as (

    select * from {{ ref('stg_region') }}

),

final as (

    select
        s.supplier_key,
        s.supplier_name,
        s.supplier_address,
        s.phone_number,
        s.account_balance,
        n.nation_name,
        r.region_name

    from suppliers s
    left join nations n
        on s.nation_key = n.nation_key
    left join regions r
        on n.region_key = r.region_key

)

select * from final