{#- Test variables -#}
{%- set max_ranking = var('top_sales.ranking', 5) -%}

SELECT  *
FROM {{ ref('best_selling_articles_by_sales_channel') }}
where ranking > {{ max_ranking }}
