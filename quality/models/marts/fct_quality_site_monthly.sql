select
  sites.plant_key,
  monthly.inspection_site_id,
  monthly.inspection_month,
  monthly.inspection_count,
  monthly.complaint_count,
  {{ platform.money('monthly.credit_amount') }} as credit_amount,
  {{ platform.safe_divide('monthly.passed_count', 'monthly.decided_count') }} as first_pass_yield,
  cast({{ platform.safe_divide('monthly.defective_units', 'monthly.sample_units', 6) }} * 1000000 as integer) as defects_ppm
from {{ ref('int_quality_sites__monthly') }} as monthly
inner join {{ ref('dim_quality_inspection_sites') }} as sites
  on monthly.inspection_site_id = sites.inspection_site_id
