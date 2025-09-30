{% macro varchar_to_date(col) %}
    -- Convertit "1 octobre 2023" (VARCHAR) en DATE Snowflake
    -- 1) normalise les espaces et la casse
    -- 2) découpe jour / mois (fr) / année
    -- 3) mappe le mois fr -> MM
    -- 4) construit une chaîne DD/MM/YYYY et cast en DATE

    to_date(
      lpad(split_part(regexp_replace(lower(trim({{ col }})), '\\s+', ' '), ' ', 1), 2, '0')
      || '/' ||
      (
        case split_part(regexp_replace(lower(trim({{ col }})), '\\s+', ' '), ' ', 2)
          when 'janvier'   then '01'
          when 'fevrier'   then '02'  when 'février'   then '02'
          when 'mars'      then '03'
          when 'avril'     then '04'
          when 'mai'       then '05'
          when 'juin'      then '06'
          when 'juillet'   then '07'
          when 'aout'      then '08'  when 'août'      then '08'
          when 'septembre' then '09'
          when 'octobre'   then '10'
          when 'novembre'  then '11'
          when 'decembre'  then '12'  when 'décembre'  then '12'
          else null
        end
      )
      || '/' ||
      split_part(regexp_replace(lower(trim({{ col }})), '\\s+', ' '), ' ', 3)
    , 'DD/MM/YYYY')
{% endmacro %}
