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
    (montant - discount - avoir) as CA_net,
    mode_paiement,
FROM {{ ref('facturation_staging') }}
order by id_facture