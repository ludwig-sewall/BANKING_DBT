select
  customers.party_key,
  monthly.transaction_month as activity_month,
  sum(monthly.net_flow) as banking_net_flow,
  sum(monthly.transaction_count) as banking_transactions
from {{ ref('BANKING_BANKING', 'fct_banking_account_monthly') }} as monthly
inner join {{ ref('BANKING_BANKING', 'dim_banking_customers') }} as customers
  on monthly.banking_customer_id = customers.banking_customer_id
group by 1, 2
