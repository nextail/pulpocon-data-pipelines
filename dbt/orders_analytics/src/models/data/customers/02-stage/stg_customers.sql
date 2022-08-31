--INPUT: raw input data
WITH raw_data AS (
    SELECT *
    FROM {{ source('raw','customers') }}
)

--OUTPUT: data cleaned and with casting applied
SELECT
    customer_id,
    (Active::DECIMAL > 0)::BOOLEAN AS active,
    club_member_status,
    fashion_news_frequency,
    age::INTEGER AS age,
    postal_code
FROM
    raw_data
