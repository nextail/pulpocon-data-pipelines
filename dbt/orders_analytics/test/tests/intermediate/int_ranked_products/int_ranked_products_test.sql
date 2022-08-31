{#- 
    bsa_ranked_products model should get the rank of an article 
    within the month and sales channel, which is ordered by monthly sales volume 
-#}

{#- mock the model dependencies -#}
{%- do mock_model(model_name = 'int_monthly_sales_by_channel', custom_sql = sql_from_csv(
        "
        'sales_year';'sales_month';'sales_channel_name';'product_reference';'sales_volume';'sales_total';'product_name';'product_description'
        2020;1;'store';'156231';20.30;4;'156231_product_name';'156231_product_description'
        2020;1;'store';'153115';20.30;2;'153115_product_name';'153115_product_description'
        2020;1;'store';'111565';5.03;1;'111565_product_name';'111565_product_description'
        2020;2;'store';'156231';30.45;6;'156231_product_name';'156231_product_description'
        2020;3;'store';'156231';10.15;2;'156231_product_name';'156231_product_description'
        2020;3;'online market';'111565';8.46;1;'111565_product_name';'111565_product_description'
        "
    ))-%}

{#- mock the model to test in order to apply the dependencies mocked before -#}
{%- set mocked_model = mock_model(model_name = 'int_ranked_products') -%}

{#- define the expected output -#}
{%- set expected_output = mock_model(custom_sql = sql_from_csv(
        "
        'sales_year';'sales_month';'sales_channel_name';'product_reference';'sales_volume';'sales_total';'product_name';'product_description';'ranking'
        2020;1;'store';'156231';20.30;4;'156231_product_name';'156231_product_description';1
        2020;1;'store';'153115';20.30;2;'153115_product_name';'153115_product_description';1
        2020;1;'store';'111565';5.03;1;'111565_product_name';'111565_product_description';2
        2020;2;'store';'156231';30.45;6;'156231_product_name';'156231_product_description';1
        2020;3;'store';'156231';10.15;2;'156231_product_name';'156231_product_description';1
        2020;3;'online market';'111565';8.46;1;'111565_product_name';'111565_product_description';1
        "
    ))-%}

{#- asserts equality between expected_output and the model result -#}
{{ dbt_utils.test_equality(expected_output, mocked_model) }}