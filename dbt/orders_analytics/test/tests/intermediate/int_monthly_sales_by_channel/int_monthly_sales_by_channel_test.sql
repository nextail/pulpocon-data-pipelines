
{#- 
    bsa_monthly_sales_by_product should get monthly sales by product and sales channel
-#}


{#- mock the model dependencies -#}
{%- do mock_model(model_name = "bss_sales", custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'sales_date';'customer_reference';'article_reference';'product_reference';'price';'sales_channel_name'
    2020;1;'2020-01-16'::date;'4d67e3bc';'153115020';'153115';10.15;'store'
    2020;1;'2020-01-18'::date;'44f2f2cd';'156231001';'156231';5.63;'store'
    2020;1;'2020-01-29'::date;'abdcb5ae';'156231001';'156231';8.46;'store'
    2020;1;'2020-01-07'::date;'bd4991af';'111565001';'111565';5.03;'online market'
    2020;2;'2020-02-20'::date;'953e9f33';'156231002';'156231';6.08;'store'
    2020;1;'2020-01-08'::date;'b4486669';'156231001';'156231';3.36;'store'
    2020;2;'2020-02-22'::date;'2fe633f9';'156231001';'156231';3.76;'store'
    2020;2;'2020-02-06'::date;'0a429ac1';'156231001';'156231';7.61;'store'
    2020;2;'2020-02-13'::date;'14804b83';'156231002';'156231';2.69;'store'
    2020;2;'2020-02-06'::date;'77878db8';'156231001';'156231';5.07;'store'
    2020;2;'2020-02-28'::date;'46497844';'156231001';'156231';5.64;'store'
    2020;3;'2020-03-14'::date;'8418fdc0';'156231001';'156231';5.64;'store'
    2020;3;'2020-03-20'::date;'9e672020';'111565001';'111565';8.46;'online market'
    2020;3;'2020-03-07'::date;'a150cbf8';'156231001';'156231';5.64;'store'
    "
))-%}

{%- do mock_model(model_name = "bss_products", custom_sql = sql_from_csv(
    "
    'product_reference';'product_name';'product_description';'product_type_name';'product_type_no';'product_group_name';'department_no';'department_name';'section_no';'section_name';'garment_group_no';'garment_group_name'
    '111565';'20 den 1p Stockings';'Semi shiny nylon stockings with a wide, reinforced trim at the top.';'Underwear Tights';304;'Socks & Tights';3608;'Tights basic';62;'Womens Nightwear, Socks & Tigh';1021;'Socks and Tights'
    '153115';'OP Strapless';'Strapless bra in microfibre with underwired, padded cups that lift and shape the bust. ';'Bra';306;'Underwear';1339;'Clean Lingerie';61;'Womens Lingerie';1017;'Under-, Nightwear'
    '156231';'Box 4p Tights';'Matt tights with an elasticated waist. 20 denier.';'Underwear Tights';304;'Socks & Tights';3608;'Tights basic';62;'Womens Nightwear, Socks & Tigh';1021;'Socks and Tights'
    "
))-%}


{#- mock the model to test in order to apply the dependencies mocked before -#}
{%- set mocked_model = mock_model(model_name = 'int_monthly_sales_by_channel') -%}


{#- define the expected output -#}
{%- set expected_output = mock_model(custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'sales_channel_name';'product_reference';'sales_volume';'sales_total';'product_name';'product_description'
    2020;1;'store';'156231';17.45;3;'Box 4p Tights';'Matt tights with an elasticated waist. 20 denier.'
    2020;1;'store';'153115';10.15;1;'OP Strapless';'Strapless bra in microfibre with underwired, padded cups that lift and shape the bust. '
    2020;1;'online market';'111565';5.03;1;'20 den 1p Stockings';'Semi shiny nylon stockings with a wide, reinforced trim at the top.'
    2020;2;'store';'156231';30.85;6;'Box 4p Tights';'Matt tights with an elasticated waist. 20 denier.'
    2020;3;'store';'156231';11.28;2;'Box 4p Tights';'Matt tights with an elasticated waist. 20 denier.'
    2020;3;'online market';'111565';8.46;1;'20 den 1p Stockings';'Semi shiny nylon stockings with a wide, reinforced trim at the top.'
    "
))-%}


{#- asserts equality between expected_output and the model result -#}
{{ dbt_utils.test_equality(expected_output, mocked_model) }}