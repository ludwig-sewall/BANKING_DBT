select
  inspection_site_id,
  plant_key,
  site_name,
  site_status,
  iso_certified_until,
  iso_certified_until < {{ platform.as_of_date() }} as is_certificate_expired
from {{ ref('stg_quality__inspection_sites') }}
