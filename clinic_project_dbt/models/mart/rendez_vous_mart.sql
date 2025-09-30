{{ config(schema='mart') }}


select *
FROM {{ ref('rendez_vous_staging') }}
order by id_rdv