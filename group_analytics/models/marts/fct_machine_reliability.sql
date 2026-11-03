with output as (

    select
      machine_id,
      sum(units_produced) as units_produced,
      avg(oee) as avg_oee,
      sum(aborted_runs) as aborted_runs
    from {{ ref('BANKING_PRODUCTION', 'fct_production_machine_monthly') }}
    group by 1

)

select
  machines.machine_id,
  machines.plant_key as plant_id,
  machines.machine_type,
  machines.age_years,
  machines.equipment_id,
  machines.criticality,
  coalesce(output.units_produced, 0)::integer as units_produced,
  cast(output.avg_oee as numeric(18, 4)) as avg_oee,
  coalesce(output.aborted_runs, 0)::integer as aborted_runs,
  coalesce(machines.failure_count, 0)::integer as failure_count,
  machines.mean_days_between_failures,
  machines.mean_hours_to_repair,
  {{ platform.money('coalesce(machines.maintenance_cost, 0)') }} as maintenance_cost,
  {{ platform.safe_divide('machines.maintenance_cost', 'output.units_produced', 4) }} as maintenance_cost_per_unit,
  machines.equipment_id is null as is_unmaintained
from {{ ref('int_machine_360__joined') }} as machines
left join output
  on machines.machine_id = output.machine_id
