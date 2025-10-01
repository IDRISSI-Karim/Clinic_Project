-- ============================================================
-- Table: facturation_mart
-- Description : contient les données de facturation consolidées
--               avec l’ajout de la colonne CA_net
-- ============================================================


{{ config(schema='mart') }}

select
    id_facture,
    date,
    id_veterinaire,
    id_clinique,
    service,
    montant,
    discount,
    avoir,
    (montant - montant*(discount/100) - avoir) as CA_net,
    mode_paiement,
FROM {{ ref('facturation_staging') }}
order by id_facture