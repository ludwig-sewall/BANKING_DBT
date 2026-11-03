with monthly as (

    select
      *,
      {{ platform.safe_divide('runtime_hours', 'planned_hours') }} as availability,
      {{ platform.safe_divide('units_produced', 'ideal_units') }} as performance,
      {{ platform.safe_divide('good_units', 'units_produced') }} as quality
    from {{ ref('int_production_machines__monthly') }}

)

select
  machine_id || '|' || cast(run_month as varchar) as machine_month_id,
  machine_id,
  production_plant_id,
  run_month,
  run_count,
  aborted_runs,
  {{ platform.money('planned_hours') }} as planned_hours,
  {{ platform.money('runtime_hours') }} as runtime_hours,
  units_produced,
  good_units,
  availability,
  performance,
  quality,
  cast(availability * performance * quality as numeric(18, 4)) as oee
from monthly
