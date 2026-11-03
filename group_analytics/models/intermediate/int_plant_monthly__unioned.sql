select
  'production' as source_system,
  plant_key,
  run_month as activity_month,
  units_produced,
  scrap_units,
  oee,
  cast(null as numeric(18, 2)) as downtime_hours,
  cast(null as numeric(18, 2)) as maintenance_cost,
  cast(null as numeric(18, 4)) as first_pass_yield,
  cast(null as integer) as complaint_count
from {{ ref('BANKING_PRODUCTION', 'fct_production_plant_monthly') }}

union all

select
  'maintenance',
  plant_key,
  reported_month,
  null, null, null,
  downtime_hours,
  maintenance_cost,
  null, null
from {{ ref('BANKING_MAINTENANCE', 'fct_maintenance_work_center_monthly') }}

union all

select
  'quality',
  plant_key,
  inspection_month,
  null, null, null, null, null,
  first_pass_yield,
  complaint_count
from {{ ref('BANKING_QUALITY', 'fct_quality_site_monthly') }}
