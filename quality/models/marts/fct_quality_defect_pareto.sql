select
  inspection_site_id || '|' || defect_code as site_defect_id,
  inspection_site_id,
  defect_code,
  defect_units::integer as defect_units,
  defect_rank::integer as defect_rank,
  cast(defect_share as numeric(18, 4)) as defect_share
from {{ ref('int_quality_defects__pareto') }}
