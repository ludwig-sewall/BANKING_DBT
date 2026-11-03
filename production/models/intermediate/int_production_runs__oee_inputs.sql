select
  runs.run_id,
  runs.machine_id,
  machines.production_plant_id,
  runs.run_date,
  {{ platform.month_start('runs.run_date') }} as run_month,
  runs.product_line,
  runs.run_status,
  runs.planned_hours,
  runs.runtime_hours,
  runs.units_produced,
  runs.scrap_units,
  runs.units_produced - runs.scrap_units as good_units,
  machines.rated_units_per_hour * runs.runtime_hours as ideal_units
from {{ ref('stg_production__production_runs') }} as runs
inner join {{ ref('stg_production__machines') }} as machines
  on runs.machine_id = machines.machine_id
