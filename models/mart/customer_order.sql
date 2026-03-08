{{ config(
    materialized='table',
    tags=['marts','fact','orders'],
    persist_docs={"relation": true, "columns": true}
) }}

with orders as (
    select *
    from {{ ref('stg_orders') }}
),

customers as (
    select *
    from {{ ref('stg_customer') }}
),

nation as (
    select *
    from {{ ref('stg_nation') }}
),

region as (
    select *
    from {{ ref('stg_region') }}
),


final as (
    select
        o.ORDER_KEY,
        o.ORDER_STATUS,
        o.ORDER_TOTAL_PRICE,
        o.ORDER_DATE,
        o.ORDER_PRIORITY,
        o.ORDER_CLERK,
        o.ORDER_SHIP_PRIORITY,
        o.ORDER_COMMENT,

        c.CUSTOMER_KEY,
        c.CUSTOMER_NAME,
        c.CUSTOMER_ADDRESS,
        c.CUSTOMER_PHONE,
        c.CUTOMER_ACCOUNT_BALANCE,
        c.CUSTOMER_MARKET_SEGEMNT,
        c.CUSTOMER_COMMENT,

        n.NATION_KEY,
        n.NATION_NAME,
        n.NATION_COMMENT,

        r.REGION_KEY,
        r.REGION_NAME,
        r.REGION_COMMENT,

        -- lineage
        o.record_source,
        o.dbt_loaded_at

    from orders o
    left join customers c
      on o.ORDER_CUSTOMER_KEY = c.CUSTOMER_KEY
    left join nation n
      on n.NATION_KEY=c.CUSTOMER_NATION_KEY
    left join region r
      on r.REGION_KEY=n.NATION_REGION_KEY
)

select *
from final