select
  equipment.equipment_id,
  equipment.work_center_id,
  work_centers.plant_key,
  equipment.machine_serial as machine_id,
  equipment.criticality,
  equipment.install_date,
  coalesce(reliability.failure_count, 0)::integer as failure_count,
  coalesce(reliability.preventive_count, 0)::integer as preventive_count,
  {{ platform.money('coalesce(reliability.unplanned_downtime_hours, 0)') }} as unplanned_downtime_hours,
  {{ platform.money('reliability.mean_hours_to_repair') }} as mean_hours_to_repair,
  {{ platform.safe_divide('365', 'reliability.failure_count', 1) }} as mean_days_between_failures,
  {{ platform.money('coalesce(reliability.maintenance_cost, 0)') }} as maintenance_cost
from {{ ref('stg_maintenance__equipment') }} as equipment
inner join {{ ref('dim_maintenance_work_centers') }} as work_centers
  on equipment.work_center_id = work_centers.work_center_id
left join {{ ref('int_maintenance_equipment__reliability') }} as reliability
  on equipment.equipment_id = reliability.equipment_id
