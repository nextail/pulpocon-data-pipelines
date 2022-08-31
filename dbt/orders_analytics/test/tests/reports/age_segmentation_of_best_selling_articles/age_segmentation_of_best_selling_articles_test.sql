
{#- 
    age_segmentation_of_best_selling_articles should get the segmentation by age 
    of the best selling articles
-#}


{#- mock the model dependencies and variables -#}
{%- do mock_variable("age_segmentation.interval_size", 10) -%}

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

{%- do mock_model(model_name = "bss_sales", custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'sales_date';'customer_reference';'article_reference';'price';'sales_channel_name';'product_reference'
    2020;1;'2020-01-16'::date;'4d67e3bc';'153115020';10.15;'store';'153115'
    2020;1;'2020-01-18'::date;'44f2f2cd';'156231001';5.63;'store';'156231'
    2020;1;'2020-01-29'::date;'abdcb5ae';'156231001';8.46;'store';'156231'
    2020;1;'2020-01-07'::date;'bd4991af';'111565001';5.03;'online market';'111565'
    2020;2;'2020-02-20'::date;'953e9f33';'156231002';6.08;'store';'156231'
    2020;1;'2020-01-08'::date;'b4486669';'156231001';3.36;'store';'156231'
    2020;2;'2020-02-22'::date;'2fe633f9';'156231001';3.76;'store';'156231'
    2020;2;'2020-02-06'::date;'0a429ac1';'156231001';7.61;'store';'156231'
    2020;2;'2020-02-13'::date;'14804b83';'156231002';2.69;'store';'156231'
    2020;2;'2020-02-06'::date;'77878db8';'156231001';5.07;'store';'156231'
    2020;2;'2020-02-28'::date;'46497844';'156231001';5.64;'store';'156231'
    2020;3;'2020-03-14'::date;'8418fdc0';'156231001';5.64;'store';'156231'
    2020;3;'2020-03-20'::date;'9e672020';'111565001';8.46;'online market';'111565'
    2020;3;'2020-03-07'::date;'a150cbf8';'156231001';5.64;'store';'156231'
    "
))-%}

{%- do mock_model(model_name = "bss_customers", custom_sql = sql_from_csv(
    "
    'customer_reference';'active';'club_member_status';'fashion_news_frequency';'age';'postal_code'
    'b4486669';true;'ACTIVE';'Regularly';44;'930b19ae7db8abb'
    'abdcb5ae';false;'ACTIVE';'NONE';34;'5af3c7af7cfd5b8'
    '44f2f2cd';false;'ACTIVE';'NONE';50;'832d75a6bb1d2f5'
    '4d67e3bc';false;'ACTIVE';'NONE';39;'84241c94f2a30bf'
    'bd4991af';true;'ACTIVE';'Regularly';52;'0b0a8c66ad7cea8'
    '953e9f33';false;'ACTIVE';'NONE';41;'fe39be415b93276'
    '2fe633f9';false;'ACTIVE';'NONE';64;'0130948fae1e226'
    '0a429ac1';false;'ACTIVE';'NONE';46;'fbdcfaba4202db9'
    '14804b83';true;'ACTIVE';'Regularly';33;'52017ea99cc8fbe'
    '77878db8';false;'ACTIVE';'NONE';48;'2c29ae653a9282c'
    '46497844';false;'ACTIVE';'NONE';30;'c3824b43ed1c042'
    '8418fdc0';false;'ACTIVE';'NONE';18;'bee4f518dbc636b'
    '9e672020';true;'ACTIVE';'Regularly';19;'cd45023eeca6ef3'
    'a150cbf8';true;'ACTIVE';'Regularly';22;'4599a6631060580'
    "
))-%}

{%- do mock_model(model_name = "int_ranked_products", custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'sales_channel_id';'product_reference';'sales_volume';'sales_total';'ranking';'sales_channel_name';'product_name'
    2020;1;1;'156231';17.45;3;1;'store';'Box 4p Tights'
    2020;1;2;'111565';5.03;1;1;'online market';'20 den 1p Stockings'
    2020;2;1;'156231';30.85;6;1;'store';'Box 4p Tights'
    2020;3;1;'156231';11.28;2;1;'store';'Box 4p Tights'
    2020;3;2;'111565';8.46;1;1;'online market';'20 den 1p Stockings'
    "
))-%}


{#- mock the model to test in order to apply the dependencies mocked before -#}
{%- set mocked_model = mock_model(model_name = 'age_segmentation_of_best_selling_articles') -%}


{#- define the expected output -#}
{%- set expected_output = mock_model(custom_sql = sql_from_csv(
    "
    'sales_year';'sales_month';'segment';'segment_sales_volume';'sales_percentage'
    2020;1;'[30-40)';8.46;37.63
    2020;1;'[40-50)';3.36;14.95
    2020;1;'[50-60)';10.66;47.42
    2020;2;'[30-40)';8.33;27.00
    2020;2;'[40-50)';18.76;60.81
    2020;2;'[60-70)';3.76;12.19
    2020;3;'[10-20)';14.10;71.43
    2020;3;'[20-30)';5.64;28.57
    "
))-%}


{#- asserts equality between expected_output and the model result -#}
{{ dbt_utils.test_equality(expected_output, mocked_model) }}