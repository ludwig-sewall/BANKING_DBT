select
  equipment.work_center_id,
  work_orders.reported_month,
  count(*)::integer as work_order_count,
  sum(case when work_orders.work_order_type = 'preventive' then 1 else 0 end)::integer as preventive_count,
  sum(case when work_orders.work_order_type = 'corrective' then 1 else 0 end)::integer as corrective_count,
  sum(work_orders.downtime_hours) as downtime_hours,
  sum(work_orders.parts_cost + work_orders.labour_cost) as maintenance_cost
from {{ ref('int_maintenance_work_orders__costed') }} as work_orders
inner join {{ ref('stg_maintenance__equipment') }} as equipment
  on work_orders.equipment_id = equipment.equipment_id
group by 1, 2
