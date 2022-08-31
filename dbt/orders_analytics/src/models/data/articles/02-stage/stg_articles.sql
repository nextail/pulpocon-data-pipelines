--INPUT: raw input data
WITH raw_data AS (
    SELECT *
    FROM {{ source('raw','articles') }}
)

--OUTPUT: data cleaned and with casting applied
SELECT
    article_id,
    product_code,
    {{ orders_analytics.strip('prod_name') }} AS prod_name,
    {{ orders_analytics.strip('detail_desc') }} AS detail_desc,
    product_type_no::INTEGER AS product_type_no,
    {{ orders_analytics.strip('product_type_name') }} AS product_type_name,
    {{ orders_analytics.strip('product_group_name') }} AS product_group_name,
    graphical_appearance_no::INTEGER AS graphical_appearance_no,
    {{ orders_analytics.strip('graphical_appearance_name') }} AS graphical_appearance_name,
    colour_group_code,
    {{ orders_analytics.strip('colour_group_name') }} AS colour_group_name,
    perceived_colour_value_id,    
    {{ orders_analytics.strip('perceived_colour_value_name') }} AS perceived_colour_value_name,
    perceived_colour_master_id,
    {{ orders_analytics.strip('perceived_colour_master_name') }} AS perceived_colour_master_name,
    department_no::INTEGER AS department_no,
    {{ orders_analytics.strip('department_name') }} AS department_name,
    index_code,
    {{ orders_analytics.strip('index_name') }} AS index_name,
    index_group_no::INTEGER AS index_group_no,
    {{ orders_analytics.strip('index_group_name') }} AS index_group_name,
    section_no::INTEGER AS section_no,
    {{ orders_analytics.strip('section_name') }} AS section_name,
    garment_group_no::INTEGER AS garment_group_no,
    {{ orders_analytics.strip('garment_group_name') }} AS garment_group_name
FROM
    raw_data
