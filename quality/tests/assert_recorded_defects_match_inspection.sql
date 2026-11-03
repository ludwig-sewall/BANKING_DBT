select inspection_id
from {{ ref('int_quality_inspections__with_defects') }}
where recorded_defect_units != defective_units
