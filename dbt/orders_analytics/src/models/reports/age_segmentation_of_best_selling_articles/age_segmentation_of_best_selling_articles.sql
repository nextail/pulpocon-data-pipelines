{#- Model variables -#}
{%- set ranking_positions = var('age_segmentation.ranking', 5) -%}
{%- set age_interval = var('age_segmentation.interval_size', 10) -%}


-- Top ranked products by month
WITH top_products AS (
    SELECT 
        ranked.sales_year,
        ranked.sales_month,
        ranked.product_reference
    FROM 
        {{ ref('int_ranked_products') }} ranked
    WHERE 
        ranking <= {{ ranking_positions }}
),

-- Total monthly sales for the articles of every top product
top_sales AS (
    SELECT
        sales.customer_reference, 
        sales.price, 
        sales.sales_month, 
        sales.sales_year,
        SUM(price) OVER (PARTITION BY sales_year, sales_month) AS sales_volume_by_month
    FROM
        {{ ref('bss_sales') }} sales 
    WHERE 
        EXISTS (
            SELECT NULL 
            FROM 
                top_products topp
            WHERE 
                topp.product_reference = sales.product_reference
                AND topp.sales_month = sales.sales_month
                AND topp.sales_year = sales.sales_year
            )
),

-- Sales segmented by customer age
top_sales_by_segment AS (
    SELECT
        sales_year,
        sales_month,
        FLOOR( COALESCE(age,-1) / {{ age_interval }} ) AS segment,
        SUM(price) AS segment_sales_volume,
        MAX(sales_volume_by_month) AS monthly_sales_volume
    FROM
        top_sales ts
    LEFT JOIN
        {{ ref('bss_customers') }} cust ON cust.customer_reference = ts.customer_reference
    GROUP BY 1, 2, 3
)

-- Final report
SELECT
    sales_year,
    sales_month,
    CONCAT('[', segment * {{ age_interval }}, '-', (segment + 1) * {{ age_interval }}, ')') AS segment, 
    segment_sales_volume, 
    (segment_sales_volume / monthly_sales_volume * 100)::DECIMAL(11,2) AS sales_percentage
FROM
    top_sales_by_segment