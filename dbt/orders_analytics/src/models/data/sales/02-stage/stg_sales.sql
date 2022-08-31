--INPUT: raw input data
WITH raw_data AS (
    SELECT *
    FROM {{ source('raw','sales') }}
)

--OUTPUT: data cleaned and with casting applied
SELECT
    t_dat::DATE AS t_dat,
    customer_id,
    article_id,
    price::DECIMAL(11,2) AS price,
    sales_channel_id::INTEGER AS sales_channel_id
FROM
    raw_data
WHERE 
    customer_id <> 'unknown'