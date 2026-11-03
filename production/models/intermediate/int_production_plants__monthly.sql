select
  production_plant_id,
  run_month,
  count(distinct machine_id)::integer as machines_running,
  sum(run_count)::integer as run_count,
  sum(aborted_runs)::integer as aborted_runs,
  sum(planned_hours) as planned_hours,
  sum(runtime_hours) as runtime_hours,
  sum(units_produced)::integer as units_produced,
  sum(scrap_units)::integer as scrap_units,
  sum(good_units)::integer as good_units,
  sum(ideal_units) as ideal_units
from {{ ref('int_production_machines__monthly') }}
group by 1, 2
