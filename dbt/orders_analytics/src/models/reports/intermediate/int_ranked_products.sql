-- Product sells ranked by date and sales_channel
SELECT
    ms.sales_year,
    ms.sales_month,
    ms.sales_channel_name,
    ms.product_reference,
    ms.product_name,
    ms.product_description,
    ms.sales_volume,
    ms.sales_total,
    RANK() OVER (PARTITION BY ms.sales_year, ms.sales_month, ms.sales_channel_name
                       ORDER BY ms.sales_volume DESC) AS ranking
FROM
    {{ ref('int_monthly_sales_by_channel') }} ms