select
  run_id,
  machine_id,
  production_plant_id,
  run_date,
  product_line,
  run_status,
  planned_hours,
  runtime_hours,
  units_produced,
  scrap_units,
  good_units::integer as good_units,
  {{ platform.safe_divide('scrap_units', 'units_produced') }} as scrap_rate
from {{ ref('int_production_runs__oee_inputs') }}
