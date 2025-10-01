-- ============================================================
-- Table : veterinaire_mart
-- Description : résultat de la jointure entre les tables 
--               veterinaire_staging et ressources_humaines_staging,
--               partageant la même clé primaire
-- Objectif : centraliser les informations vétérinaires et RH
--            dans une table unique pour simplifier l’analyse
-- ============================================================

{{ config(schema='mart') }}

SELECT
    v.id_veterinaire,
    v.nom AS nom_veterinaire,
    v.seniorite,
    v.specialite,
    mois,
    rh.heures_contractuelles,
    rh.heures_travaillees,
    rh.absences_heures as heures_absences,
FROM {{ ref('veterinaire_staging') }} AS v
JOIN {{ ref('ressources_humaines_staging') }} AS rh
  ON v.id_veterinaire = rh.id_veterinaire
ORDER BY v.id_veterinaire
