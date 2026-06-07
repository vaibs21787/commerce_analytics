with parts as (

    select * from {{ ref('stg_parts') }}

),

final as (

    select
        -- primary key
        part_key,

        -- part details
        part_name,
        manufacturer,
        brand,
        part_type,
        part_size,
        container_type,
        retail_price,

        -- extract components from part_type using macro
        {{ get_part_type_component('part_type', 'size') }}     as type_size,
        {{ get_part_type_component('part_type', 'finish') }}   as type_finish,
        {{ get_part_type_component('part_type', 'material') }} as type_material,

        -- price segments
        case
            when retail_price < 900  then 'Budget'
            when retail_price < 1200 then 'Standard'
            when retail_price < 1500 then 'Premium'
            else                          'Luxury'
        end as price_segment

    from parts

)

select * from final