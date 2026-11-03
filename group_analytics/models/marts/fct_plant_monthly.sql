select
  plant_key || '|' || cast(activity_month as varchar) as plant_month_id,
  plant_key as plant_id,
  activity_month,
  coalesce(sum(units_produced), 0)::integer as units_produced,
  coalesce(sum(scrap_units), 0)::integer as scrap_units,
  cast(max(oee) as numeric(18, 4)) as oee,
  {{ platform.money('coalesce(sum(downtime_hours), 0)') }} as downtime_hours,
  {{ platform.money('coalesce(sum(maintenance_cost), 0)') }} as maintenance_cost,
  cast(max(first_pass_yield) as numeric(18, 4)) as first_pass_yield,
  coalesce(sum(complaint_count), 0)::integer as complaint_count
from {{ ref('int_plant_monthly__unioned') }}
group by 1, 2, 3
