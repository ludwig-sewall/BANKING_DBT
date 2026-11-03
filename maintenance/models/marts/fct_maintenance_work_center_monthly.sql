select
  work_centers.plant_key,
  monthly.work_center_id,
  monthly.reported_month,
  monthly.work_order_count,
  monthly.preventive_count,
  monthly.corrective_count,
  {{ platform.money('monthly.downtime_hours') }} as downtime_hours,
  {{ platform.money('monthly.maintenance_cost') }} as maintenance_cost,
  {{ platform.safe_divide('monthly.preventive_count', 'monthly.work_order_count') }} as preventive_share
from {{ ref('int_maintenance_work_centers__monthly') }} as monthly
inner join {{ ref('dim_maintenance_work_centers') }} as work_centers
  on monthly.work_center_id = work_centers.work_center_id
