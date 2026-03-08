{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
PS_PARTKEY,
PS_SUPPKEY,
PS_AVAILQTY,
PS_SUPPLYCOST,
PS_COMMENT

    from {{ source('stg_po', 'PARTSUPP') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
PS_PARTKEY as part_supplier_part_key,
PS_SUPPKEY as part_supplier_supplier_key,
PS_AVAILQTY as part_supplier_available_qty,
PS_SUPPLYCOST as part_supplier_supply_cost,
PS_COMMENT as part_supplier_comment,

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