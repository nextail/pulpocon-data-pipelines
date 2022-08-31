{#- 
    articles_with_low_sales_pct_over_product_sales model should get articles with a sales percentage 
    lower than 30% over the total product sales within the period between 1st February 2020 and 31st March 2020
-#}


{#- mock the model dependencies and variables -#}
{%- do mock_variable("low_sales.months_period", 2) -%}
{%- do mock_variable("low_sales.reference_date", "'2020-03-31'") -%}
{%- do mock_variable("low_sales.min_sales_percentage", 30) -%}
{%- do mock_variable("low_sales.section", None) -%}

{%- do mock_model(model_name = "bss_articles", custom_sql = sql_from_csv(
    "
    'article_reference';'product_reference';'colour_group_code';'colour_group_name';'perceived_colour_value_id';'perceived_colour_value_name';'perceived_colour_master_id';'perceived_colour_master_name'
    '108775044';'108775';'10';'White';'3';'Light';'9';'White'
    '111565001';'111565';'9';'Black';'4';'Dark';'5';'Black'
    '153115020';'153115';'12';'Light Beige';'1';'Dusty Light';'11';'Beige'
    '153115021';'153115';'10';'White';'3';'Light';'9';'White'
    '156231001';'156231';'9';'Black';'4';'Dark';'5';'Black'
    '156231002';'156231';'13';'Beige';'2';'Medium Dusty';'11';'Beige'
    "
))-%}

{%- do mock_model(model_name = "bss_products", custom_sql = sql_from_csv(
    "
    'product_reference';'product_name';'product_description';'product_type_name';'product_type_no';'product_group_name';'department_no';'department_name';'section_no';'section_name';'garment_group_no';'garment_group_name'
    '111565';'20 den 1p Stockings';'Semi shiny nylon stockings with a wide, reinforced trim at the top. Use with a suspender belt. 20 denier.';'Underwear Tights';304;'Socks & Tights';3608;'Tights basic';62;'Womens Nightwear, Socks & Tigh';1021;'Socks and Tights'
    '153115';'OP Strapless';'Strapless bra in microfibre with underwired, padded cups that lift and shape the bust. Silicone trim at the top and a hook-and-eye fastening at the back. Detachable, adjustable shoulder straps and side support.';'Bra';306;'Underwear';1339;'Clean Lingerie';61;'Womens Lingerie';1017;'Under-, Nightwear'
    '156231';'Box 4p Tights';'Matt tights with an elasticated waist. 20 denier.';'Underwear Tights';304;'Socks & Tights';3608;'Tights basic';62;'Womens Nightwear, Socks & Tigh';1021;'Socks and Tights'
    "
))-%}

{%- do mock_model(model_name = "bss_sales", custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'sales_date';'customer_reference';'article_reference';'price';'sales_channel_name'
    2020;1;'2020-01-16'::date;'4d67e3bc';'153115020';10.15;'store'
    2020;1;'2020-01-18'::date;'44f2f2cd';'156231001';5.63;'store'
    2020;1;'2020-01-29'::date;'abdcb5ae';'156231001';8.46;'store'
    2020;1;'2020-01-07'::date;'bd4991af';'111565001';5.03;'online market'
    2020;2;'2020-02-20'::date;'953e9f33';'156231002';6.08;'store'
    2020;1;'2020-01-08'::date;'b4486669';'156231001';3.36;'store'
    2020;2;'2020-02-22'::date;'2fe633f9';'156231001';3.76;'store'
    2020;2;'2020-02-06'::date;'0a429ac1';'156231001';7.61;'store'
    2020;2;'2020-02-13'::date;'14804b83';'156231002';2.69;'store'
    2020;2;'2020-02-06'::date;'77878db8';'156231001';5.07;'store'
    2020;2;'2020-02-28'::date;'46497844';'156231001';5.64;'store'
    2020;3;'2020-03-14'::date;'8418fdc0';'156231001';5.64;'store'
    2020;3;'2020-03-20'::date;'9e672020';'111565001';8.46;'online market'
    2020;3;'2020-03-07'::date;'a150cbf8';'156231001';5.64;'store'
    "
))-%}


{#- mock the model to test in order to apply the dependencies mocked before -#}
{%- set mocked_model = mock_model(model_name = 'articles_with_low_sales_pct_over_product_sales') -%}


{#- define the expected output -#}
{%- set expected_output = mock_model(custom_sql = sql_from_csv(
    "
    'product_name';'product_description';'article_reference';'colour';'perceived_colour';'section';'article_sales_volume';'sales_volume_by_product';'article_sales_percentage'
    'Box 4p Tights';'Matt tights with an elasticated waist. 20 denier.';'156231002';'Beige';'Medium Dusty';'Womens Nightwear, Socks & Tigh';8.77;42.13;20.82
    "
))-%}


{#- asserts equality between expected_output and the model result -#}
{{ dbt_utils.test_equality(expected_output, mocked_model) }}