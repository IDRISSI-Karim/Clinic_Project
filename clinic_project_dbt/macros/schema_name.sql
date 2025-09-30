
-- ====================================================================
-- Macro generate_schema_name
-- ====================================================================
-- Objectif :
-- Définir dynamiquement le nom du schéma dans lequel dbt va créer 
-- les modèles
-- ====================================================================

{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is not none -%}
        {{ custom_schema_name | upper }}
    {%- else -%}
        {{ target.schema }}
    {%- endif -%}
{%- endmacro %}