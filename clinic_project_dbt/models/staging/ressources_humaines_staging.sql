-- ====================================================================
-- Transformation : Nettoyage et déduplication des données RH
-- ====================================================================
SELECT
    id_veterinaire,
    mois,
    heures_contractuelles,
    heures_travaillees,
    absences_heures
FROM (
    SELECT
        id_veterinaire,
        mois,
        heures_contractuelles,
        heures_travaillees,
        absences_heures,
        ROW_NUMBER() OVER (
            PARTITION BY id_veterinaire
            ORDER BY id_veterinaire
        ) AS rn
    FROM {{ source('RAW', 'ressources_humaines') }}
)
WHERE rn = 1