{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
P_PARTKEY,
P_NAME,
P_MFGR,
P_BRAND,
P_TYPE,
P_SIZE,
P_CONTAINER,
P_RETAILPRICE,
P_COMMENT

    from {{ source('stg_po', 'PART') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
P_PARTKEY as part_key,
P_NAME as part_name,
P_MFGR as part_manufacture,
P_BRAND as part_brand,
P_TYPE as part_type,
P_SIZE as part_size,
P_CONTAINER as part_container,
P_RETAILPRICE as part_retail_price,
P_COMMENT as part_comment,

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