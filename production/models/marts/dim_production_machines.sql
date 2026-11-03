select
  machines.machine_id,
  machines.production_plant_id,
  plants.plant_key,
  machines.machine_type,
  machines.machine_status,
  machines.commissioned_date,
  machines.rated_units_per_hour,
  cast(floor({{ platform.days_between('machines.commissioned_date', platform.as_of_date()) }} / 365.0) as integer) as age_years
from {{ ref('stg_production__machines') }} as machines
inner join {{ ref('dim_production_plants') }} as plants
  on machines.production_plant_id = plants.production_plant_id
