SELECT
    sales_channel_id, 
    description as sales_channel_name
FROM
    {{ ref('stg_sales_channels') }}