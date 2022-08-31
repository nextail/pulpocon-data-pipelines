/*
    The product name and description should be recovered
    from the last article sold for this product.

    If more than one article were sold in the same day, the 
    last article reference should be used.
*/

WITH last_sold_article AS (
SELECT
    DISTINCT(product_reference),
    LAST_VALUE(article_reference) OVER (
            PARTITION BY product_reference
            ORDER BY sales_date, article_reference DESC
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS article_reference
FROM
    {{ ref('bss_sales') }}
)

SELECT 
    prods.product_reference, 
    prods.product_name, 
    prods.product_description,
    arts.prod_name as expected_name, 
    arts.detail_desc as expected_product_description
FROM
    {{ ref('bss_products') }} prods
JOIN
    {{ ref('stg_articles') }} arts ON prods.product_reference = arts.product_code
JOIN
    last_sold_article last_sold ON last_sold.product_reference = prods.product_reference 
                                   AND last_sold.article_reference = arts.article_id    
WHERE 
    prods.product_name <> arts.prod_name 
    OR prods.product_description <> arts.detail_desc
