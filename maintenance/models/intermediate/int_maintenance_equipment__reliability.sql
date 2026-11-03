select
  equipment_id,
  sum(case when work_order_type = 'corrective' then 1 else 0 end)::integer as failure_count,
  sum(case when work_order_type = 'preventive' then 1 else 0 end)::integer as preventive_count,
  sum(case when work_order_type = 'corrective' then downtime_hours else 0 end) as unplanned_downtime_hours,
  avg(case when work_order_type = 'corrective' then hours_to_repair end) as mean_hours_to_repair,
  sum(parts_cost + labour_cost) as maintenance_cost
from {{ ref('int_maintenance_work_orders__costed') }}
group by 1
