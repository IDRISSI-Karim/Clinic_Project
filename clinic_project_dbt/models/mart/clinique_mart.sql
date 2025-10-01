-- =====================
-- Table: clinique_mart
-- =====================

-- Config : ce modèle sera créé dans le schéma "mart"
{{ config(schema='mart') }}


select *
FROM {{ ref('cliniques_staging') }}
order by id_clinique