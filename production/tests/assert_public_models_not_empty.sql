{#- Templated test: add a model to the list and it is covered. -#}
{%- set public_models = [
    'dim_production_plants',
    'dim_production_machines',
    'fct_production_runs',
    'fct_production_machine_monthly',
    'fct_production_plant_monthly'
] -%}

{%- for model_name in public_models %}
select
  '{{ model_name }}' as model_name,
  count(*) as row_count
from {{ ref(model_name) }}
having count(*) = 0
{% if not loop.last %}union all{% endif %}
{%- endfor %}
