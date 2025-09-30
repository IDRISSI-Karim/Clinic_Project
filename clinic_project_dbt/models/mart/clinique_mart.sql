{{ config(schema='mart') }}


select *
FROM {{ ref('cliniques_staging') }}
order by id_clinique