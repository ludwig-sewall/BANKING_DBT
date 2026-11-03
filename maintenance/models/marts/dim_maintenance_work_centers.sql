select
  work_center_id,
  plant_key,
  work_center_name,
  work_center_status,
  technician_count
from {{ ref('stg_maintenance__work_centers') }}
