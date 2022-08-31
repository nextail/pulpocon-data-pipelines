SELECT  
    article_id AS article_reference,
    product_code AS product_reference,
    colour_group_code,
    colour_group_name,
    perceived_colour_value_id,
    perceived_colour_value_name,
    perceived_colour_master_id,
    perceived_colour_master_name
FROM
    {{ ref('stg_articles') }}