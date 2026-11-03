select
  machines.machine_id,
  machines.plant_key,
  machines.machine_type,
  machines.age_years,
  equipment.equipment_id,
  equipment.criticality,
  equipment.failure_count,
  equipment.mean_days_between_failures,
  equipment.mean_hours_to_repair,
  equipment.maintenance_cost
from {{ ref('BANKING_PRODUCTION', 'dim_production_machines') }} as machines
left join {{ ref('BANKING_MAINTENANCE', 'dim_maintenance_equipment') }} as equipment
  on machines.machine_id = equipment.machine_id
