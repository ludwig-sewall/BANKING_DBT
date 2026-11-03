with production as (
  select * from {{ ref('int_plant_360__production') }}
),

maintenance as (
  select * from {{ ref('int_plant_360__maintenance') }}
),

quality as (
  select * from {{ ref('int_plant_360__quality') }}
),

plants as (
  select plant_key from production
  union
  select plant_key from maintenance
  union
  select plant_key from quality
)

select
  plants.plant_key as plant_id,
  production.plant_name,
  production.country,
  production.production_status,
  maintenance.maintenance_status,
  quality.quality_status,
  coalesce(production.units_produced, 0)::integer as units_produced,
  {{ platform.safe_divide('production.scrap_units', 'production.units_produced') }} as scrap_rate,
  cast(production.avg_oee as numeric(18, 4)) as avg_oee,
  coalesce(maintenance.failure_count, 0)::integer as failure_count,
  {{ platform.money('coalesce(maintenance.unplanned_downtime_hours, 0)') }} as unplanned_downtime_hours,
  {{ platform.money('coalesce(maintenance.maintenance_cost, 0)') }} as maintenance_cost,
  cast(quality.avg_first_pass_yield as numeric(18, 4)) as avg_first_pass_yield,
  cast(quality.avg_defects_ppm as integer) as avg_defects_ppm,
  coalesce(quality.complaint_count, 0)::integer as complaint_count,
  {{ platform.money('coalesce(quality.credit_amount, 0)') }} as complaint_credits,
  coalesce(quality.is_certificate_expired, false) as is_certificate_expired,
  (
    case when production.plant_key is not null then 1 else 0 end
    + case when maintenance.plant_key is not null then 1 else 0 end
    + case when quality.plant_key is not null then 1 else 0 end
  )::integer as domain_count,
  {{ platform.as_of_date() }} as as_of_date
from plants
left join production
  on plants.plant_key = production.plant_key
left join maintenance
  on plants.plant_key = maintenance.plant_key
left join quality
  on plants.plant_key = quality.plant_key
