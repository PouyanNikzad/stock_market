{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
C_CUSTKEY,
C_NAME,
C_ADDRESS,
C_NATIONKEY,
C_PHONE,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT

    from {{ source('stg_po', 'CUSTOMER') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
C_CUSTKEY as customer_key,
C_NAME as customer_name,
C_ADDRESS as customer_address,
C_NATIONKEY as customer_nation_key,
C_PHONE as customer_phone,
C_ACCTBAL as cutomer_account_balance,
C_MKTSEGMENT as customer_market_segemnt,
C_COMMENT as customer_comment,

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