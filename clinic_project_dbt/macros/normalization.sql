-- ====================================================================
-- Macro normalize_label
-- ====================================================================
-- Objectif : nettoyer et uniformiser une chaîne de caractères en 
-- supprimant les caractères spéciaux et en mettant le tout en minuscule.
-- ====================================================================
{% macro normalize_label(col) %}
  lower(
    regexp_replace(
      {{ col }},
      '[^A-Za-z0-9]+', ' '  -- remplace tout ce qui n'est pas lettre/chiffre par un espace
    )
  )
{% endmacro %}

-- ====================================================================
-- Macro normalize
-- ====================================================================
-- Objectif : appliquer des règles de standardisation sur les colonnes
-- contenant des libellés.
-- ====================================================================

{% macro normalize(column_name) %}

case
    when {{ normalize_label(column_name) }} in ('vaccination','Vaccin') then 'Vaccination'
    when {{ normalize_label(column_name) }} in ('consultation maladie','consultationmaladie') then 'Consultation Maladie'
    when {{ normalize_label(column_name) }} in ('examen de routine','examen', 'examenderoutine') then 'Examen de routine'
    when {{ normalize_label(column_name) }} = 'check up' then 'Check-up'
    else initcap({{ column_name }})
end

{% endmacro %}
