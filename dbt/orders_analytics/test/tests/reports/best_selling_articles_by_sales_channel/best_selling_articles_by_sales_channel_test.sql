
{#- 
    best_selling_articles_by_sales_channel should get top article by month and sales channel
-#}


{#- mock the model dependencies and variables -#}
{%- do mock_variable("top_sales.ranking", 1) -%}

{%- do mock_model(model_name = "int_ranked_products", custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'sales_channel_name';'product_reference';'sales_volume';'sales_total';'ranking';'product_name'
    2020;1;'store';'156231';17.45;3;1;'Box 4p Tights'
    2020;1;'store';'153115';10.15;1;2;'10 den 1p Stockings'
    2020;1;'online market';'111565';5.03;1;1;'20 den 1p Stockings'
    2020;2;'store';'156231';30.85;6;1;'Box 4p Tights'
    2020;3;'store';'156231';11.28;2;1;'Box 4p Tights'
    2020;3;'online market';'111565';8.46;1;1;'20 den 1p Stockings'
    "
))-%}

{#- mock the model to test in order to apply the dependencies mocked before -#}
{%- set mocked_model = mock_model(model_name = 'best_selling_articles_by_sales_channel') -%}


{#- define the expected output -#}
{%- set expected_output = mock_model(custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'sales_channel_name';'product_reference';'sales_volume';'sales_total';'ranking';'product_name'
    2020;1;'store';'156231';17.45;3;1;'Box 4p Tights'
    2020;1;'online market';'111565';5.03;1;1;'20 den 1p Stockings'
    2020;2;'store';'156231';30.85;6;1;'Box 4p Tights'
    2020;3;'store';'156231';11.28;2;1;'Box 4p Tights'
    2020;3;'online market';'111565';8.46;1;1;'20 den 1p Stockings'
    "
))-%}


{#- asserts equality between expected_output and the model result -#}
{{ dbt_utils.test_equality(expected_output, mocked_model) }}