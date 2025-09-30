-- ====================================================================
-- Transformation : Nettoyage et déduplication des données vétérinaires
-- ====================================================================
SELECT
    id_veterinaire,
    nom,
    seniorite,
    specialite
FROM (
    SELECT
        id_veterinaire,
        TRIM(nom) AS nom,
        TRIM(seniorite) AS seniorite,
        TRIM(specialite) AS specialite,
        ROW_NUMBER() OVER (
            PARTITION BY id_veterinaire
            ORDER BY id_veterinaire
        ) AS rn
    FROM {{ source('RAW', 'veterinaire') }}
)
WHERE rn = 1
