with source as (

    select * from {{ source('production', 'production_runs') }}

),

renamed as (

    select
        run_id::varchar as run_id,
        machine_id::varchar as machine_id,
        run_date::date as run_date,
        product_line::varchar as product_line,
        run_status::varchar as run_status,
        {{ platform.money('planned_hours') }} as planned_hours,
        {{ platform.money('runtime_hours') }} as runtime_hours,
        planned_units::integer as planned_units,
        units_produced::integer as units_produced,
        scrap_units::integer as scrap_units
    from source

)

select * from renamed
