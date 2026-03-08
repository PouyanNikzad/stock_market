{{ config(
    materialized = 'view',
    tags = ['staging', 'stg_po'],
    persist_docs = {"relation": true, "columns": true}
) }}

with source_data as (

    select
        -- Always be explicit about columns in production
L_ORDERKEY,
L_PARTKEY,
L_SUPPKEY,
L_LINENUMBER,
L_QUANTITY,
L_EXTENDEDPRICE,
L_DISCOUNT,
L_TAX,
L_RETURNFLAG,
L_LINESTATUS,
L_SHIPDATE,
L_COMMITDATE,
L_RECEIPTDATE,
L_SHIPINSTRUCT,
L_SHIPMODE,
L_COMMENT

    from {{ source('stg_po', 'LINEITEM') }}

),

renamed as (

    select
        -- ✅ rename to consistent snake_case
L_ORDERKEY AS lineitem_order_key,
L_PARTKEY AS lineitem_part_key,
L_SUPPKEY AS lineitem_supplier_key,
L_LINENUMBER AS lineitem_line_number,
L_QUANTITY AS lineitem_quantity,
L_EXTENDEDPRICE AS lineitem_extended_price,
L_DISCOUNT AS lineitem_discount,
L_TAX AS lineitem_tax,
L_RETURNFLAG AS lineitem_return_flag,
L_LINESTATUS AS lineitem_line_status,
L_SHIPDATE AS lineitem_ship_date,
L_COMMITDATE AS lineitem_commit_date,
L_RECEIPTDATE AS lineitem_receipt_date,
L_SHIPINSTRUCT AS lineitem_shipping_instruct,
L_SHIPMODE AS lineitem_shipping_mode,
L_COMMENT AS lineitem_comment,

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