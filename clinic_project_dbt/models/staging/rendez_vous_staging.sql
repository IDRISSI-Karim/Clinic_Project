-- ====================================================================
-- Transformation : Nettoyage et déduplication des données de rendez-vous
-- ====================================================================
select id_rdv ,
  date, -- à convertir en DATE après nettoyage
  heure,
  id_veterinaire,
  id_clinique,
  type_consultation,
  duree_minute,
  statut,
FROM(
  select 
        id_rdv,
        {{ varchar_to_date('date') }}  as date, 
        heure,
        id_veterinaire,
        id_clinique,
        {{ normalize('type_consultation') }}  as type_consultation,
        duree_minute,
        TRIM(statut) as statut,
        ROW_NUMBER() OVER (
            PARTITION BY id_rdv
            ORDER BY id_rdv
        ) AS rn
    FROM {{ source('RAW', 'rendez_vous') }}
)
WHERE rn = 1