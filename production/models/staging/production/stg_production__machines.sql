with source as (

    select * from {{ source('production', 'machines') }}

),

renamed as (

    select
        machine_id::varchar as machine_id,
        production_plant_id::varchar as production_plant_id,
        machine_type::varchar as machine_type,
        commissioned_date::date as commissioned_date,
        machine_status::varchar as machine_status,
        rated_units_per_hour::integer as rated_units_per_hour
    from source

)

select * from renamed
