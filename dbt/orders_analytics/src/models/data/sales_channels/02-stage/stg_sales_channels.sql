--INPUT: raw input data
WITH raw_data AS (
    SELECT *
    FROM {{ source('raw', 'sales_channels') }}
)

--OUTPUT: data cleaned and with casting applied
SELECT
    sales_channel_id::INTEGER AS sales_channel_id,
    {{ orders_analytics.strip('description') }} AS description
FROM
    raw_data
