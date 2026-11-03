with by_code as (

    select
      inspections.inspection_site_id,
      defects.defect_code,
      sum(defects.defect_units) as defect_units
    from {{ ref('stg_quality__defects') }} as defects
    inner join {{ ref('stg_quality__inspections') }} as inspections
      on defects.inspection_id = inspections.inspection_id
    group by 1, 2

)

select
  inspection_site_id,
  defect_code,
  defect_units,
  row_number() over (partition by inspection_site_id order by defect_units desc, defect_code) as defect_rank,
  cast(defect_units as numeric(18, 4))
    / sum(defect_units) over (partition by inspection_site_id) as defect_share
from by_code
