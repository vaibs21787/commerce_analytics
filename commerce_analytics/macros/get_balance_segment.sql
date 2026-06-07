{% macro get_balance_segment(balance_column) %}
    case
        when {{ balance_column }} < 0    then 'Negative'
        when {{ balance_column }} = 0    then 'Zero'
        when {{ balance_column }} < 1000 then 'Low'
        when {{ balance_column }} < 5000 then 'Medium'
        else                                  'High'
    end
{% endmacro %}