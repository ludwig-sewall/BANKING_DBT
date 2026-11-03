with inspections as (

    select
      inspection_site_id,
      inspection_month,
      count(*) as inspection_count,
      sum(case when inspection_status = 'passed' then 1 else 0 end) as passed_count,
      sum(case when inspection_status in ('passed', 'failed') then 1 else 0 end) as decided_count,
      sum(sample_units) as sample_units,
      sum(defective_units) as defective_units
    from {{ ref('int_quality_inspections__with_defects') }}
    group by 1, 2

),

complaints as (

    select
      inspection_site_id,
      {{ platform.month_start('received_date') }} as inspection_month,
      count(*) as complaint_count,
      sum(credit_amount) as credit_amount
    from {{ ref('stg_quality__complaints') }}
    group by 1, 2

)

select
  inspections.inspection_site_id,
  inspections.inspection_month,
  inspections.inspection_count::integer as inspection_count,
  inspections.passed_count::integer as passed_count,
  inspections.decided_count::integer as decided_count,
  inspections.sample_units::integer as sample_units,
  inspections.defective_units::integer as defective_units,
  coalesce(complaints.complaint_count, 0)::integer as complaint_count,
  coalesce(complaints.credit_amount, 0) as credit_amount
from inspections
left join complaints
  on inspections.inspection_site_id = complaints.inspection_site_id
 and inspections.inspection_month = complaints.inspection_month
