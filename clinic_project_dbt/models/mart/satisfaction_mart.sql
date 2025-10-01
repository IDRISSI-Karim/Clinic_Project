-- ==========================
-- Table : satisfaction_mart
-- ==========================

{{ config(schema='mart') }}

select *
FROM {{ ref('satisfaction_staging') }}
order by id_feedback