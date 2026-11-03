with ranked as (

    select
      plant_id,
      avg_oee,
      avg_first_pass_yield,
      failure_count,
      complaint_count,
      rank() over (order by avg_oee desc nulls last) as oee_rank,
      rank() over (order by avg_first_pass_yield desc nulls last) as quality_rank
    from {{ ref('dim_plant_360') }}
    where production_status = 'running'

)

select
  plant_id,
  oee_rank::integer as oee_rank,
  quality_rank::integer as quality_rank,
  coalesce(avg_oee, 0) < 0.65 as is_oee_risk,
  coalesce(avg_first_pass_yield, 1) < 0.85 or complaint_count >= 6 as is_quality_risk,
  case
    when coalesce(avg_oee, 0) >= 0.75 and coalesce(avg_first_pass_yield, 0) >= 0.9 then 'gold'
    when coalesce(avg_oee, 0) >= 0.65 and coalesce(avg_first_pass_yield, 0) >= 0.85 then 'silver'
    when coalesce(avg_oee, 0) >= 0.55 then 'bronze'
    else 'watchlist'
  end as scorecard_tier
from ranked
