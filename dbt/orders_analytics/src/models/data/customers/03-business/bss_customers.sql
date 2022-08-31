SELECT
    customer_id AS customer_reference,
    COALESCE(active, false) as active,
    club_member_status,
    fashion_news_frequency,
    age,
    postal_code
FROM
    {{ ref('stg_customers') }}