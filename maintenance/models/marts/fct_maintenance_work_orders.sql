select
  work_order_id,
  equipment_id,
  work_order_type,
  priority,
  work_order_status,
  reported_at,
  reported_month,
  completed_at,
  downtime_hours,
  labour_hours,
  parts_cost,
  labour_cost,
  cast(hours_to_repair as numeric(18, 2)) as hours_to_repair
from {{ ref('int_maintenance_work_orders__costed') }}
