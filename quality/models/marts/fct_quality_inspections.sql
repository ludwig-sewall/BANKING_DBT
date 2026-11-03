select
  inspection_id,
  inspection_site_id,
  inspection_date,
  inspection_month,
  product_line,
  inspection_type,
  inspection_status,
  sample_units,
  defective_units,
  critical_units::integer as critical_units,
  {{ platform.safe_divide('defective_units', 'sample_units', 6) }} as defect_rate
from {{ ref('int_quality_inspections__with_defects') }}
