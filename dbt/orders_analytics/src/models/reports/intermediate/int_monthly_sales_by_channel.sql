
-- Product monthly sales by sales_channel
WITH montlhy_sales AS (
    SELECT 
        sl.sales_year,
        sl.sales_month,
        sl.sales_channel_name,
        sl.product_reference,
        SUM(sl.price) AS sales_volume,
        COUNT(*) AS sales_total
    FROM
        {{ ref('bss_sales') }} sl
    GROUP BY 1, 2, 3, 4
)

SELECT 
    ms.sales_year,
    ms.sales_month,
    ms.sales_channel_name,
    ms.product_reference,
    prod.product_name, 
    prod.product_description,
    ms.sales_volume,
    ms.sales_total
FROM
    montlhy_sales ms
JOIN 
    {{ ref('bss_products') }} prod on prod.product_reference = ms.product_reference