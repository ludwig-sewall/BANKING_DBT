with source as (

    select * from {{ source('quality', 'inspection_sites') }}

),

renamed as (

    select
        inspection_site_id::varchar as inspection_site_id,
        plant_key::varchar as plant_key,
        site_name::varchar as site_name,
        site_status::varchar as site_status,
        iso_certified_until::date as iso_certified_until,
        loaded_at::timestamp as loaded_at
    from source

)

select * from renamed
