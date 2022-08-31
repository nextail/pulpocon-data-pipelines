{#- Model variables -#}
{%- set current_date = modules.datetime.datetime.today().strftime('%Y-%m-%d') -%}
{%- set section = var('low_sales.section', None) -%}
{%- set sales_percentage = var('low_sales.min_sales_percentage', 10) -%}
{%- set reference_date = var('low_sales.reference_date', current_date) -%}
{%- set period = var('low_sales.months_period', 3) -%}

{#- The computed interval origin date -#}
{%- set origin_date_expression = dbt_utils.dateadd(datepart='month', interval=-period, from_date_or_timestamp="'%s'::date" | format(reference_date)) -%}



/*
    Total sells by article for the configured period of time.
    Computed For all the sections or for a specific one if the variable is provided
*/
WITH article_sales_volume_in_period AS (
    SELECT
        art.article_reference, 
        MAX(prod.product_reference) AS product_reference,
        MAX(prod.product_name) AS product_name,
        MAX(prod.product_description) AS product_description, 
        MAX(art.colour_group_name) AS colour, 
        MAX(perceived_colour_value_name) AS perceived_colour, 
        MAX(prod.section_name) AS section,
        SUM(sales.price) AS article_sales_volume
    FROM
        {{ ref('bss_sales') }} sales 
    JOIN
        {{ ref('bss_articles') }} art ON art.article_reference = sales.article_reference 
    JOIN
        {{ ref('bss_products') }} prod ON prod.product_reference = art.product_reference
    WHERE
        sales.sales_date BETWEEN {{ origin_date_expression }} AND '{{ reference_date }}'
    {% if section -%}
        AND prod.section_name = '{{ section }}'
    {%- endif %}
    GROUP BY 1
),

/*
    Compute the percentage of and article sells
    vs the total for the product it belongs to
*/
article_sales_percentage_over_product_sales AS (
    SELECT
        arts.*,
        SUM(article_sales_volume) OVER (PARTITION BY product_reference) AS sales_volume_by_product
    FROM
        article_sales_volume_in_period arts
)

-- Final report
SELECT
    sales.*,
    (article_sales_volume / sales_volume_by_product * 100)::DECIMAL(5,2) AS article_sales_percentage
FROM
    article_sales_percentage_over_product_sales sales
WHERE
    (article_sales_volume / sales_volume_by_product * 100)::DECIMAL(5,2) <  {{ sales_percentage }}