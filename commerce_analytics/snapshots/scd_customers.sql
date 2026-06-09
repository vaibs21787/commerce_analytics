{% snapshot scd_customers %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_key',
        strategy='check',
        check_cols=[
            'market_segment',
            'account_balance',
            'nation_key'
        ]
    )
}}

select
    customer_key,
    customer_name,
    customer_address,
    nation_key,
    phone_number,
    account_balance,
    market_segment

from {{ ref('stg_customers') }}

{% endsnapshot %}