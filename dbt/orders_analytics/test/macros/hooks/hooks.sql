
{% macro setup() %}
    {% set test_schema = api.Relation.create(database = target.database, schema = target.schema) %}
    {% if execute and test_schema %}
        {% do adapter.create_schema(test_schema) %}
    {% endif %}
{% endmacro %}


{% macro teardown() %}
    {% set test_schema = api.Relation.create(database = target.database, schema = target.schema) %}
    {% if execute and test_schema %}
        {% do adapter.drop_schema(test_schema) %}
    {% endif %}
{% endmacro %}