with source as (

    select * from {{ source('quality', 'complaints') }}

),

renamed as (

    select
        complaint_id::varchar as complaint_id,
        inspection_site_id::varchar as inspection_site_id,
        received_date::date as received_date,
        product_line::varchar as product_line,
        severity::varchar as severity,
        complaint_status::varchar as complaint_status,
        {{ platform.money('credit_amount') }} as credit_amount
    from source

)

select * from renamed
