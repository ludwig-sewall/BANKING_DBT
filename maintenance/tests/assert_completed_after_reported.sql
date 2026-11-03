select work_order_id
from {{ ref('fct_maintenance_work_orders') }}
where completed_at < reported_at
