{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
R_REGIONKEY,
R_NAME,
R_COMMENT

    from {{ source('stg_po', 'REGION') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
R_REGIONKEY as region_key,
R_NAME as region_name,
R_COMMENT as region_comment,

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