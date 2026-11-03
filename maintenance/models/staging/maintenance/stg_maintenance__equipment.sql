with source as (

    select * from {{ source('maintenance', 'equipment') }}

),

renamed as (

    select
        equipment_id::varchar as equipment_id,
        work_center_id::varchar as work_center_id,
        machine_serial::varchar as machine_serial,
        criticality::varchar as criticality,
        install_date::date as install_date
    from source

)

select * from renamed
