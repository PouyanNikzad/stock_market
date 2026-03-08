{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
O_ORDERKEY,
O_CUSTKEY,
O_ORDERSTATUS,
O_TOTALPRICE,
O_ORDERDATE,
O_ORDERPRIORITY,
O_CLERK,
O_SHIPPRIORITY,
O_COMMENT

    from {{ source('stg_po', 'ORDERS') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
O_ORDERKEY as order_key,
O_CUSTKEY as order_customer_key,
O_ORDERSTATUS as order_status,
O_TOTALPRICE as order_total_price,
O_ORDERDATE as order_date,
O_ORDERPRIORITY as order_priority,
O_CLERK as order_clerk,
O_SHIPPRIORITY as order_ship_priority,
O_COMMENT as order_comment,

        -- ✅ optional: lineage metadata
        'TPCH_SF1'::varchar as record_source,
        current_timestamp() as dbt_loaded_at

    from source_data

),

final as (

    select *
    from renamed

)
select *
from final