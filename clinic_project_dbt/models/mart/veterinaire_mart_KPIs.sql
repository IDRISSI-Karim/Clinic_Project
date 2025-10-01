-- ============================================================
-- Table: veterinaire_mart_KPIs
-- Description : contient les indicateurs clés de performance (KPIs)
--            fiables, automatisables et interprétables
-- Objectif : permettre le suivi de l’activité, de la rentabilité 
--            et de la satisfaction des veterinaires
-- ============================================================

{{ config(schema='mart') }}

with rdv as (
    select
        id_veterinaire,
        extract(year from date) as annee,
        extract(month from date) as mois,
        sum(case when statut = 'Confirmé' then 1 else 0 end) as nb_rdv_realises
    from {{ ref('rendez_vous_mart') }}
    group by id_veterinaire, extract(year from date), extract(month from date)
),

facturation as (
    select
        id_veterinaire,
        extract(year from date) as annee,
        extract(month from date) as mois,
        sum(CA_net) as gain_net
    from {{ ref('facturation_mart') }}
    group by id_veterinaire, extract(year from date), extract(month from date)
),

heures as (
    select
        id_veterinaire,
        extract(year from to_date(mois || '-01', 'YYYY-MM-DD')) as annee,
        extract(month from to_date(mois || '-01', 'YYYY-MM-DD')) as mois,
        sum(heures_travaillees) as heures_travaillees
    from {{ ref('veterinaire_mart') }}
    group by id_veterinaire, extract(year from to_date(mois || '-01', 'YYYY-MM-DD')), extract(month from to_date(mois || '-01', 'YYYY-MM-DD'))
),

satisfaction as (
    select
        id_veterinaire,
        extract(year from date) as annee,
        extract(month from date) as mois,
        avg(score) as taux_satisfaction
    from {{ ref('satisfaction_mart') }}
    group by id_veterinaire, extract(year from date), extract(month from date)
)


select
    v.id_veterinaire,
    v.nom_veterinaire,
    v.annee,
    v.mois,
    h.heures_travaillees,
    f.gain_net,
    r.nb_rdv_realises,
    s.taux_satisfaction
from (
    select id_veterinaire,
        nom_veterinaire,
        extract(year from to_date(mois || '-01', 'YYYY-MM-DD')) as annee,
        extract(month from to_date(mois || '-01', 'YYYY-MM-DD')) as mois
    from mart.veterinaire_mart
) v
left join rdv r on v.id_veterinaire = r.id_veterinaire and v.annee = r.annee and v.mois = r.mois
left join facturation f on v.id_veterinaire = f.id_veterinaire and v.annee = f.annee and v.mois = f.mois
left join heures h on v.id_veterinaire = h.id_veterinaire and v.annee = h.annee and v.mois = h.mois
left join satisfaction s on v.id_veterinaire = s.id_veterinaire and v.annee = s.annee and v.mois = s.mois
order by v.id_veterinaire, v.annee, v.mois