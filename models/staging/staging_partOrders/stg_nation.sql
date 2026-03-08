{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
N_NATIONKEY,
N_NAME,
N_REGIONKEY,
N_COMMENT

    from {{ source('stg_po', 'NATION') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
N_NATIONKEY as nation_key,
N_NAME as nation_name,
N_REGIONKEY as nation_region_key,
N_COMMENT as nation_comment,

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