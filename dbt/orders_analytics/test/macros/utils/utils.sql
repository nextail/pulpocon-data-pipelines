
{# Builds a SQL select sentence from the contents of a CSV like string #}
{%- macro sql_from_csv(csv_contents, delimiter = ";") -%}
    
  {%- set lines = csv_contents.strip().splitlines() -%}
  {%- set columns = lines[0].split(delimiter) -%}
    
  {%- for line in lines -%}
    {%- if not loop.first -%} 
      SELECT
      {%- set values = line.split(delimiter) -%}
      
      {%- for value in values %}  
            {{ value | default('NULL', true) | replace('"', "'") }} AS {{ columns[loop.index0] | string | replace("'", "")}}
        {%- if not loop.last -%} 
          ,
        {%- endif -%}
      {%- endfor -%}

      {%- if not loop.last %} 
        UNION ALL
      {% endif %}
    {%- endif -%}
  {%- endfor -%}
{%- endmacro -%}


{% macro log_debug(msg='', console = true) %}
    {%- if flags.DEBUG -%}
        {{ log("DEBUG ["~ project_name ~ "][" + ('exec' if execute else 'comp') + "][" ~ this + "] " ~ msg, console) }}
    {%- endif -%}
{% endmacro %}
