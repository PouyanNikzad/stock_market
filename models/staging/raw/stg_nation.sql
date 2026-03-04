select
N_COMMENT,
N_NAME,
N_NATIONKEY,
N_REGIONKEY
from {{ source('raw', 'nation') }}