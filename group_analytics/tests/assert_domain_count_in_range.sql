select
  plant_id,
  domain_count
from {{ ref('dim_plant_360') }}
where domain_count < 1
   or domain_count > 3
