with parts as (

    select
      work_order_id,
      sum(quantity * unit_cost) as parts_cost
    from {{ ref('stg_maintenance__parts_usage') }}
    group by 1

)

select
  work_orders.work_order_id,
  work_orders.equipment_id,
  work_orders.work_order_type,
  work_orders.priority,
  work_orders.work_order_status,
  work_orders.reported_at,
  {{ platform.month_start('work_orders.reported_at') }} as reported_month,
  work_orders.completed_at,
  work_orders.downtime_hours,
  work_orders.labour_hours,
  {{ platform.money('coalesce(parts.parts_cost, 0)') }} as parts_cost,
  {{ platform.money('work_orders.labour_hours * ' ~ var('labour_rate_per_hour', 68)) }} as labour_cost,
  case when work_orders.completed_at is not null
    then {{ platform.minutes_between('work_orders.reported_at', 'work_orders.completed_at') }} / 60.0 end as hours_to_repair
from {{ ref('stg_maintenance__work_orders') }} as work_orders
left join parts
  on work_orders.work_order_id = parts.work_order_id
where work_orders.work_order_status != 'cancelled'
