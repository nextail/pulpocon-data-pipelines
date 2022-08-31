/*
    Include some denormalized data from sales_channels and articles
    to avoid extra joins in the descendant models
*/
SELECT
    EXTRACT(year FROM t_dat)::INTEGER AS sales_year,
    EXTRACT(month FROM t_dat)::INTEGER AS sales_month,
    ss.t_dat AS sales_date,
    ss.customer_id AS customer_reference,
    ss.article_id AS article_reference,
    ba.product_reference,
    price,
    ss.sales_channel_id,
    bsc.sales_channel_name
FROM
    {{ ref('stg_sales') }} ss
JOIN
    {{ ref('bss_articles') }} ba ON ba.article_reference = ss.article_id
JOIN
    {{ ref('bss_sales_channels') }} bsc ON bsc.sales_channel_id = ss.sales_channel_id