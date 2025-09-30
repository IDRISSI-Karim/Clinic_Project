-- ====================================================================
-- Transformation : Nettoyage et déduplication des données cliniques
-- ====================================================================
SELECT
    id_clinique,
    nom_clinique,
    region,
    jours_ouverture_semaine
FROM (
    SELECT
        id_clinique,
        TRIM(nom_clinique) AS nom_clinique,
        TRIM(region) as region,
        CASE 
            WHEN jours_ouverture_semaine < 0 THEN 0
            WHEN jours_ouverture_semaine > 7 THEN 7
            ELSE jours_ouverture_semaine
        END AS jours_ouverture_semaine,
        ROW_NUMBER() OVER (
            PARTITION BY id_clinique
            ORDER BY id_clinique
        ) AS rn
    FROM {{ source('RAW', 'cliniques') }}
)
WHERE rn = 1
