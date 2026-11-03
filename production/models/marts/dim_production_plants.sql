select
  production_plant_id,
  plant_key,
  plant_name,
  country,
  plant_status,
  shifts_per_day
from {{ ref('stg_production__plants') }}
