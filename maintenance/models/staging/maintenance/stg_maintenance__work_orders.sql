with source as (

    select * from {{ source('maintenance', 'work_orders') }}

),

renamed as (

    select
        work_order_id::varchar as work_order_id,
        equipment_id::varchar as equipment_id,
        work_order_type::varchar as work_order_type,
        priority::varchar as priority,
        reported_at::timestamp as reported_at,
        started_at::timestamp as started_at,
        completed_at::timestamp as completed_at,
        work_order_status::varchar as work_order_status,
        {{ platform.money('downtime_hours') }} as downtime_hours,
        {{ platform.money('labour_hours') }} as labour_hours
    from source

)

select * from renamed
