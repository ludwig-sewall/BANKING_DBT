select run_id
from {{ ref('fct_production_runs') }}
where scrap_units > units_produced
