{#- Templated test: add a model to the list and it is covered. -#}
{%- set public_models = [
    'dim_quality_inspection_sites',
    'fct_quality_inspections',
    'fct_quality_defect_pareto',
    'fct_quality_site_monthly'
] -%}

{%- for model_name in public_models %}
select
  '{{ model_name }}' as model_name,
  count(*) as row_count
from {{ ref(model_name) }}
having count(*) = 0
{% if not loop.last %}union all{% endif %}
{%- endfor %}
