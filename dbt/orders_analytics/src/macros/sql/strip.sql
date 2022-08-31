{%- macro strip(string, pattern = '[\\n\\r\\t]+') -%}
    
    {{ return(adapter.dispatch('strip', 'orders_analytics')(string, pattern)) }}

{%- endmacro -%}

{%- macro default__strip(string, pattern) -%}
    TRIM(REGEXP_REPLACE({{string}}, '{{pattern}}',''))
{%- endmacro -%}

{%- macro postgres__strip(string, pattern) -%}
    TRIM(REGEXP_REPLACE({{string}}, '{{pattern}}','','g'))
{%- endmacro -%}