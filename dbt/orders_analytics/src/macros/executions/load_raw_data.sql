

{% macro load_raw_data () %}
  """Load external data from S3 into the database raw tables.
  """

  {{ log("Load raw data: ", true) }}
  {{ log("** profile_name: " ~ target.profile_name, true) }}
  {{ log("** target.name: " ~ target.name, true) }}
  {{ log("** target.type: " ~ target.type, true) }}
  {{ log("** target.schema: " ~ target.schema, true) }}

  {{ return(adapter.dispatch('load_raw_data', 'orders_analytics')()) }}

{% endmacro %}


{% macro default__load_raw_data() %}

  {% set error_msg %}
  Esta macro solo puede ser ejecutada cuando el target seleccionado es Snowflake.
  Si estás utilizando la instancia local de PostgreSQL, debes ejecutar en su lugar el comando: "dbt seed" 
  para cargar el dato de pruebas en local y poder continuar así con el taller.
  {% endset %}

  {{ exceptions.raise_compiler_error(error_msg) }}
  
{% endmacro %}


{% macro snowflake__load_raw_data() %}

  {#- Initialize schema if not exists -#}
  {% do adapter.create_schema(api.Relation.create(database=target.database, schema=target.schema)) %}

  {#- Load external sources -#}
  {% set source_nodes = graph.sources.values() if graph.sources else [] %}

  {%- for node in source_nodes -%}
    {%- if node.external.location != none -%}
        {{ log("", true) }}
        {{ log("- loading data for node '" + node.identifier + "'", true) }}
        
        {% do orders_analytics._load_csv_to_snowflake(node) %}
    {%- endif %}
  {%- endfor -%}
  
{% endmacro %}

{% macro _load_csv_to_snowflake (source_node) %}

  {%- set columns = source_node.columns.values() -%}
  {%- set external = source_node.external -%}
  
  {% set sql %}

    CREATE OR REPLACE TRANSIENT TABLE {{ target.database }}.{{ target.schema }}.{{ source_node.identifier }}
    (
      {%- for column in columns %}
          {%- set column_quoted = adapter.quote(column.name) if column.quote else column.name %}
          {{column_quoted}} {{column.data_type}}
          {{- ',' if not loop.last -}}
      {% endfor %}
    );

    COPY INTO {{ target.database }}.{{ target.schema }}.{{ source_node.identifier }}
    FROM {{ external.location }}{%- if external.pattern -%}/{{external.pattern}} {%- endif %}
    {% if external.file_format -%} 
      file_format = {{ external.file_format }}
    {%- endif %}
    ;
  {% endset %}
  
  {% if execute %}
    {% set results = run_query(sql) %}
    {% do results.print_table(max_rows = 50, max_columns = 6, max_column_width = 80) %}
  {% endif %}
{% endmacro %}