select
  machine_id,
  production_plant_id,
  run_month,
  count(*)::integer as run_count,
  sum(case when run_status = 'aborted' then 1 else 0 end)::integer as aborted_runs,
  sum(planned_hours) as planned_hours,
  sum(runtime_hours) as runtime_hours,
  sum(units_produced)::integer as units_produced,
  sum(scrap_units)::integer as scrap_units,
  sum(good_units)::integer as good_units,
  sum(ideal_units) as ideal_units
from {{ ref('int_production_runs__oee_inputs') }}
group by 1, 2, 3
