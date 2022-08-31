/* 
    To deal with data changes during the sales history,
    for products with sales, we'll extract info from the last sold article
    in order to retrieve the most recent data from the articles catalog
*/
WITH last_article_sold_by_product AS (
    SELECT
        DISTINCT(art.product_code), 
        LAST_VALUE(sa.article_id) OVER (
                PARTITION BY art.product_code
                ORDER BY sa.t_dat, sa.article_id DESC 
                RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) AS article_id
    FROM
        {{ ref('stg_articles') }} art
    JOIN
        {{ ref('stg_sales') }} sa ON sa.article_id = art.article_id
),

/* 
    For products without sales, we'll extract info 
    from one (any) of their related articles
*/
products_without_sales AS (
    SELECT
        product_code,
        MAX(article_id) AS article_id
    FROM
        {{ ref('stg_articles') }} art
    WHERE NOT EXISTS (
        SELECT NULL 
        FROM last_article_sold_by_product lasbp
        WHERE lasbp.product_code = art.product_code
    ) 
    GROUP BY 1
),

/* 
    Products with and without sales
*/
union_both_product_sets AS (
    SELECT *
    FROM last_article_sold_by_product
    UNION ALL 
    SELECT * 
    FROM products_without_sales
)

/* 
    Data for all the products and articles selected
*/
SELECT
    art.product_code AS product_reference,
    prod_name AS product_name, 
    detail_desc AS product_description,
    product_type_name,
    product_type_no,
    product_group_name,
    department_no,
    department_name,
    section_no,
    section_name,
    garment_group_no,
    garment_group_name
FROM
    union_both_product_sets un
JOIN
    {{ ref('stg_articles') }} art ON art.product_code = un.product_code 
                                     AND art.article_id = un.article_id