{#- Templated test: add a model to the list and it is covered. -#}
{%- set public_models = [
    'dim_maintenance_work_centers',
    'dim_maintenance_equipment',
    'fct_maintenance_work_orders',
    'fct_maintenance_work_center_monthly'
] -%}

{%- for model_name in public_models %}
select
  '{{ model_name }}' as model_name,
  count(*) as row_count
from {{ ref(model_name) }}
having count(*) = 0
{% if not loop.last %}union all{% endif %}
{%- endfor %}
