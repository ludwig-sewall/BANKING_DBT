with source as (

    select * from {{ source('maintenance', 'work_centers') }}

),

renamed as (

    select
        work_center_id::varchar as work_center_id,
        plant_key::varchar as plant_key,
        work_center_name::varchar as work_center_name,
        work_center_status::varchar as work_center_status,
        technician_count::integer as technician_count,
        loaded_at::timestamp as loaded_at
    from source

)

select * from renamed
