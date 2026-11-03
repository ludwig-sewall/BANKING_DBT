with output as (

    select
      plant_key,
      sum(units_produced) as units_produced,
      sum(scrap_units) as scrap_units,
      avg(oee) as avg_oee
    from {{ ref('BANKING_PRODUCTION', 'fct_production_plant_monthly') }}
    group by 1

)

select
  plants.plant_key,
  plants.production_plant_id,
  plants.plant_name,
  plants.country,
  plants.plant_status as production_status,
  output.units_produced,
  output.scrap_units,
  output.avg_oee
from {{ ref('BANKING_PRODUCTION', 'dim_production_plants') }} as plants
left join output
  on plants.plant_key = output.plant_key
