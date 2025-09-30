-- ====================================================================
-- Transformation : Nettoyage et déduplication des données de facturation
-- ====================================================================
select id_facture ,
  date, -- à convertir en DATE après nettoyage
  id_veterinaire,
  id_clinique,
  service,
  montant,
  discount,
  avoir,
  mode_paiement,
FROM(
  select 
        id_facture,
        {{ varchar_to_date('date') }}  as date, 
        id_veterinaire,
        id_clinique,
        {{ normalize('service') }}  as service,
        montant,
        abs(discount) as discount,
        avoir,
        TRIM(mode_paiement) as mode_paiement,
        ROW_NUMBER() OVER (
            PARTITION BY id_facture
            ORDER BY id_facture
        ) AS rn
    FROM {{ source('RAW', 'facturation') }}
)
WHERE rn = 1