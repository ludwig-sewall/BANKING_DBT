with source as (

    select * from {{ source('quality', 'inspections') }}

),

renamed as (

    select
        inspection_id::varchar as inspection_id,
        inspection_site_id::varchar as inspection_site_id,
        inspection_date::date as inspection_date,
        product_line::varchar as product_line,
        inspection_type::varchar as inspection_type,
        inspection_status::varchar as inspection_status,
        sample_units::integer as sample_units,
        defective_units::integer as defective_units
    from source

)

select * from renamed
