with source as (

    select * from {{ source('quality', 'defects') }}

),

renamed as (

    select
        defect_id::varchar as defect_id,
        inspection_id::varchar as inspection_id,
        defect_code::varchar as defect_code,
        severity::varchar as severity,
        defect_units::integer as defect_units
    from source

)

select * from renamed
