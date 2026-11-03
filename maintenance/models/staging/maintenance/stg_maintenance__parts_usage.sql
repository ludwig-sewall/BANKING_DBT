with source as (

    select * from {{ source('maintenance', 'parts_usage') }}

),

renamed as (

    select
        usage_id::varchar as usage_id,
        work_order_id::varchar as work_order_id,
        part_number::varchar as part_number,
        quantity::integer as quantity,
        {{ platform.money('unit_cost') }} as unit_cost
    from source

)

select * from renamed
