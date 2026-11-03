select
  plants.plant_key,
  monthly.production_plant_id,
  monthly.run_month,
  monthly.machines_running,
  monthly.run_count,
  monthly.aborted_runs,
  monthly.units_produced,
  monthly.scrap_units,
  monthly.good_units,
  {{ platform.safe_divide('monthly.scrap_units', 'monthly.units_produced') }} as scrap_rate,
  cast(
    {{ platform.safe_divide('monthly.runtime_hours', 'monthly.planned_hours', 6) }}
    * {{ platform.safe_divide('monthly.units_produced', 'monthly.ideal_units', 6) }}
    * {{ platform.safe_divide('monthly.good_units', 'monthly.units_produced', 6) }}
  as numeric(18, 4)) as oee
from {{ ref('int_production_plants__monthly') }} as monthly
inner join {{ ref('dim_production_plants') }} as plants
  on monthly.production_plant_id = plants.production_plant_id
