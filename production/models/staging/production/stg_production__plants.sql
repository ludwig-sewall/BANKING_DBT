with source as (

    select * from {{ source('production', 'plants') }}

),

renamed as (

    select
        production_plant_id::varchar as production_plant_id,
        plant_key::varchar as plant_key,
        plant_name::varchar as plant_name,
        country::varchar as country,
        plant_status::varchar as plant_status,
        shifts_per_day::integer as shifts_per_day,
        loaded_at::timestamp as loaded_at
    from source

)

select * from renamed
