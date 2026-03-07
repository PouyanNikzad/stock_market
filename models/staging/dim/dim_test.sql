select
*
from {{ source('dim', 'DIM_TEST') }}