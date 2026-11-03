with defects as (

    select
      inspection_id,
      sum(defect_units) as defect_units,
      sum(case when severity = 'critical' then defect_units else 0 end) as critical_units
    from {{ ref('stg_quality__defects') }}
    group by 1

)

select
  inspections.inspection_id,
  inspections.inspection_site_id,
  inspections.inspection_date,
  {{ platform.month_start('inspections.inspection_date') }} as inspection_month,
  inspections.product_line,
  inspections.inspection_type,
  inspections.inspection_status,
  inspections.sample_units,
  inspections.defective_units,
  coalesce(defects.defect_units, 0) as recorded_defect_units,
  coalesce(defects.critical_units, 0) as critical_units
from {{ ref('stg_quality__inspections') }} as inspections
left join defects
  on inspections.inspection_id = defects.inspection_id
