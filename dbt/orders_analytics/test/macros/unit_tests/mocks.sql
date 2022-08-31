{# 
    Mocks an existing DB model appliying some mappings or creates a mocked model using a specific SQL sentence 
#}
{% macro mock_variable(var = None, value = None) %}

    {% if var %}
        {{ orders_analytics_test.log_debug("Mock variable {} with custom value: {}".format(var, value)) }}
        {% do orders_analytics_test._put_mocked_var_in_context(var, value) %}    
    {% endif %}
    
    {% do return(value) %}
{% endmacro %}


{# 
    Mocks an existing DB model appliying some mappings or creates a mocked model using a specific SQL sentence 
#}
{% macro mock_model(model_schema = project_name, model_name = None, replacements = {}, custom_sql = none, debug = false) %}
        
    {% set mocked_model = none %}

    {%- if custom_sql -%}
        {{ orders_analytics_test.log_debug("Mock model {}.{} with custom SQL:\n{}\n and replacements: {}".format(model_schema, model_name, custom_sql, replacements)) }}
        {% set mocked_model = orders_analytics_test._render_model_sql(model_schema, model_name, replacements, custom_sql) %}

    {%- else -%}
        {{ orders_analytics_test.log_debug("Mock model {}.{} with replacements: {}".format(model_schema, model_name, replacements)) }}
        {% set mocked_model = orders_analytics_test._render_model_sql(model_schema, model_name, replacements) %}
    {%- endif -%}

    {% if execute and mocked_model and debug %}
        {% if custom_sql %}
            {{ log( "\nMocked model from SQL, contents (limit 50):", true) }}
        {% else %}
            {{ log( "\nMocked model " + model_name + ", contents (limit 50):", true) }}
        {% endif %}
        
        {% do  run_query("select * from " ~ mocked_model + " limit 50").print_table(max_rows = none, max_columns = none) %}
    {% endif %}

    {%- do return(mocked_model) -%}
{% endmacro %}


{# 
    Creates a DB temp table to store a mocked model
    Similar behaviour than: https://github.com/mjirv/dbt-datamocktool
#}
{% macro _render_model_sql(model_schema, model_name, mappings, raw_sql=none) %}

    {% set ns=namespace(
        test_sql="(select 1) raw_sql",
        model=none,
        graph_model=none,
        raw_sql=none
    ) %}

    {% if raw_sql %}
        {%- set ns.raw_sql = raw_sql -%}
    {% endif %}

    {% if execute %}

      {% if model_name %}
        {{ orders_analytics_test.log_debug( "graph.nodes :: project_name:" ~ model_schema + " model_name: " ~ model_name) }}

        {% set ns.graph_model = graph.nodes.get("model." + model_schema + "." + model_name) %}
        {# if the model uses an alias, the above call was unsuccessful, so loop through the graph to grab it by the alias instead #}
        {% if ns.graph_model is none %}
            {% for node in graph.nodes.values() %}
                {% if node.alias == model_name and node.schema == model_schema %}
                    {% set ns.graph_model = node %}
                {% endif %}
            {% endfor %}
        {% endif %}

      {% endif %}
      
      {# set the final sql to mock #}
      {%- set ns.raw_sql = ns.raw_sql or ns.graph_model.raw_sql -%}

      {% if model_name and not ns.raw_sql %}
           {{ exceptions.raise_compiler_error("Error! :: the model with name '{}' cannot be found, it does not exists or is disabled".format(model_name)) }}
      {% endif %}

      {{ orders_analytics_test.log_debug( "render_model_sql :: original SQL:\n{}\n".format(ns.raw_sql) )}}

      {#- replace mocked models and vars -#}
      {%- set ns.raw_sql = _replace_mocked_models_from_context(ns.raw_sql) -%}
      {%- set ns.raw_sql = _replace_mocked_vars_from_context(ns.raw_sql) -%}
      
      {#- apply substitution mappings -#}
      {% for k,v in mappings.items() %}
            {% if not v %}
                {% do exceptions.warn("Warning! :: empty value for mapping: " ~ k ~ " when rendering model '" + model_name + "'") %}
            {% endif %}
            {% set ns.raw_sql = ns.raw_sql | replace(k, v) %}
      {% endfor %}
      {% set ns.raw_sql = render(ns.raw_sql) %}

      {{ orders_analytics_test.log_debug( "render_model_sql :: final SQL:\n{}\n".format(ns.raw_sql) )}}
            
      {% set mock_relation = api.Relation.create(database = target.database, schema = target.schema, identifier = this.name, type = "table") %}
      {% set mock_model_relation = make_temp_relation(mock_relation, suffix=('_MOCK_' ~ modules.datetime.datetime.now().strftime("%S%f"))) %}

      {% do run_query(get_create_table_as_sql(true, mock_model_relation, ns.raw_sql)) %}
      
      {{ orders_analytics_test.log_debug( "render_model_sql :: mock relation created:" ~ mock_model_relation) }}
      
      {#- Store mocked relation in context-#}
      {% if model_name %}
        {% do orders_analytics_test._put_mocked_model_in_context(model_schema, model_name, mock_model_relation) %}  
      {% endif %}

      {% do return(mock_model_relation) %}
    {% endif %}

{% endmacro %}


{% macro _put_mocked_model_in_context(model_schema, model_name, mocked_relation) %}

    {{ orders_analytics_test.log_debug("*** Mocked model in ctx: {}.{} -> {}".format(model_schema, model_name, mocked_relation) ) }}

    {#- retrieve existing mocks from context -#}
    {% set mocks_context_key = [this.name, "__MOCK_MODELS__"] | join('.') %}
    {% set mocks = context.get(mocks_context_key) %}
    {% if not mocks %}
       {% set mocks = [] %}
    {% endif %}

    {% do mocks.append({
        "schema": model_schema,
        "name": model_name,
        "mock": "'{}'".format(mocked_relation)
        })
    %}
    
    {#- update mocks in context -#}
    {% do context.update({ mocks_context_key: mocks }) %}

{% endmacro %}


{% macro _replace_mocked_models_from_context(sql) %}

    {% set ns=namespace(new_sql="") %}
    
    {#- retrieve existing mocks from context -#}
    {% set mocks_context_key = [this.name, "__MOCK_MODELS__"] | join('.') %}
    {% set mocks = context.get(mocks_context_key) %}

    {% if not mocks or not sql %}
      {% do return(sql) %}
    {% endif %}

    {% set ns.new_sql = sql %}
    {% for mock in mocks %}
        {% set ns.new_sql = _replace_mocked_ref(ns.new_sql, mock) %}
        {% set ns.new_sql = _replace_mocked_src(ns.new_sql, mock) %}
    {% endfor %}
    
    {% do return(ns.new_sql) %}
{% endmacro %}


{% macro _put_mocked_var_in_context(var_name, mocked_value) %}

    {{ orders_analytics_test.log_debug("*** Mocked var in ctx: {} -> {}".format(var_name, mocked_value) ) }}

    {#- retrieve existing mocks from context -#}
    {% set mocks_context_key = [this.name, "__MOCK_VARS__"] | join('.') %}
    {% set mocks = context.get(mocks_context_key) %}
    {% if not mocks %}
       {% set mocks = [] %}
    {% endif %}

    {% do mocks.append({
        "name": var_name,
        "mock": mocked_value
        })
    %}
    
    {#- update mocks in context -#}
    {% do context.update({ mocks_context_key: mocks }) %}

{% endmacro %}


{% macro _replace_mocked_vars_from_context(sql) %}

    {% set ns=namespace(new_sql="") %}
    
    {#- retrieve existing mocks from context -#}
    {% set mocks_context_key = [this.name, "__MOCK_VARS__"] | join('.') %}
    {% set mocks = context.get(mocks_context_key) %}

    {% if not mocks or not sql %}
      {% do return(sql) %}
    {% endif %}

    {% set ns.new_sql = sql %}
    {% for mock in mocks %}
        {% set ns.new_sql = _replace_mocked_var(ns.new_sql, mock) %}
    {% endfor %}
    
    {% do return(ns.new_sql) %}
{% endmacro %}


{% macro _replace_mocked_ref(sql, mock_data) %}

    {#- ref({schema}, {name}) -#}
    {% set regex = "ref[\t ]*\({{1}}[\t ]*[\"']{{1}}{}[\"']{{1}}[\t ]*,[\t ]*[\"']{{1}}{}[\"']{{1}}[\t ]*\){{1}}".format(
                                                                                                    modules.re.escape(mock_data.schema), 
                                                                                                    modules.re.escape(mock_data.name)) %}
    {% set new_sql = modules.re.sub(regex, mock_data.mock, sql) %}
    
    {#- ref({name}) -#}
    {% set regex = "ref[\t ]*\({{1}}[\t ]*[\"']{{1}}{}[\"']{{1}}[\t ]*\){{1}}".format(modules.re.escape(mock_data.name)) %}
    {% set new_sql = modules.re.sub(regex, mock_data.mock, new_sql) %}
    
    {% do return(new_sql) %}
{% endmacro %}


{% macro _replace_mocked_src(sql, mock_data) %}

    {#- source({schema}, {name}) -#}
    {% set regex = "source[\t ]*\({{1}}[\t ]*[\"']{{1}}{}[\"']{{1}}[\t ]*,[\t ]*[\"']{{1}}{}[\"']{{1}}[\t ]*\){{1}}".format(
                                                                                                        modules.re.escape(mock_data.schema), 
                                                                                                        modules.re.escape(mock_data.name)) %}
    {% set new_sql = modules.re.sub(regex, mock_data.mock, sql) %}

    {% do return(new_sql) %}
{% endmacro %}


{% macro _replace_mocked_var(sql, mock_data) %}

    {#- var({name}) or var({name}, {default}) -#}
    {% set regex = "var[\t ]*\({{1}}[\t ]*[\"']{{1}}{}[\"']{{1}}[\t ]*([\"']{{0,1}},.+[\"']{{0,1}}){{0,1}}\){{1}}".format(modules.re.escape(mock_data.name)) %}
    {% set new_sql = modules.re.sub(regex, "" ~ mock_data.mock, sql) %}
        
    {% do return(new_sql) %}
{% endmacro %}