with equipment as (

    select
      plant_key,
      sum(failure_count) as failure_count,
      sum(unplanned_downtime_hours) as unplanned_downtime_hours,
      sum(maintenance_cost) as maintenance_cost
    from {{ ref('BANKING_MAINTENANCE', 'dim_maintenance_equipment') }}
    group by 1

)

select
  work_centers.plant_key,
  work_centers.work_center_id,
  work_centers.work_center_status as maintenance_status,
  equipment.failure_count,
  equipment.unplanned_downtime_hours,
  equipment.maintenance_cost
from {{ ref('BANKING_MAINTENANCE', 'dim_maintenance_work_centers') }} as work_centers
left join equipment
  on work_centers.plant_key = equipment.plant_key
