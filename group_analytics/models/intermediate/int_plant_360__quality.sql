with monthly as (

    select
      plant_key,
      avg(first_pass_yield) as avg_first_pass_yield,
      avg(defects_ppm) as avg_defects_ppm,
      sum(complaint_count) as complaint_count,
      sum(credit_amount) as credit_amount
    from {{ ref('BANKING_QUALITY', 'fct_quality_site_monthly') }}
    group by 1

)

select
  sites.plant_key,
  sites.inspection_site_id,
  sites.site_status as quality_status,
  sites.is_certificate_expired,
  monthly.avg_first_pass_yield,
  monthly.avg_defects_ppm,
  monthly.complaint_count,
  monthly.credit_amount
from {{ ref('BANKING_QUALITY', 'dim_quality_inspection_sites') }} as sites
left join monthly
  on sites.plant_key = monthly.plant_key
