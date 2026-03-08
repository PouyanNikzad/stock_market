{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
S_SUPPKEY,
S_NAME,
S_ADDRESS,
S_NATIONKEY,
S_PHONE,
S_ACCTBAL,
S_COMMENT

    from {{ source('stg_po', 'SUPPLIER') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
S_SUPPKEY as supplier_key,
S_NAME as supplier_name,
S_ADDRESS as supplier_address,
S_NATIONKEY as supplier_nation_key,
S_PHONE as supplier_phone,
S_ACCTBAL as supplier_account_balance,
S_COMMENT as supplier_comment,

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