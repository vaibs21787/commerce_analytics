{% macro get_part_type_component(type_column, component) %}
    {% if component == 'size' %}
        split_part({{ type_column }}, ' ', 1)
    {% elif component == 'finish' %}
        split_part({{ type_column }}, ' ', 2)
    {% elif component == 'material' %}
        split_part({{ type_column }}, ' ', 3)
    {% endif %}
{% endmacro %}