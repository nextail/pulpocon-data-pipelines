{#- Model variables -#}
{%- set ranking_positions = var('top_sales.ranking', 5) -%}


-- Final report using the auxiliary ephemeral models
SELECT
    ranked.sales_year,
    ranked.sales_month,
    ranked.sales_channel_name,
    ranked.product_reference,
    ranked.product_name,
    ranked.sales_volume,
    ranked.sales_total,
    ranked.ranking
FROM
    {{ ref('int_ranked_products') }} ranked
WHERE
    ranking <= {{ ranking_positions }}