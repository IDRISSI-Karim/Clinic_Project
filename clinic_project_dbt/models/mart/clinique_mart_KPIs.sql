{{ config(schema='mart') }}

with rdv as (
    select
        id_clinique,
        extract(year from date) as annee,
        extract(month from date) as mois,
        sum(case when statut = 'Confirmé' then 1 else 0 end) as nb_rdv_realises
    from {{ ref('rendez_vous_mart') }}
    group by id_clinique, extract(year from date), extract(month from date)
),

facturation as (
    select
        id_clinique,
        extract(year from date) as annee,
        extract(month from date) as mois,
        sum(CA_net) as gain_net
    from {{ ref('facturation_mart') }}
    group by id_clinique, extract(year from date), extract(month from date)
),

satisfaction as (
    select
        id_clinique,
        extract(year from date) as annee,
        extract(month from date) as mois,
        avg(score) as taux_satisfaction
    from {{ ref('satisfaction_mart') }}
    group by id_clinique, extract(year from date), extract(month from date)
)

select
    c.id_clinique,
    c.nom_clinique,
    coalesce(r.annee, f.annee, s.annee) as annee,
    coalesce(r.mois, f.mois, s.mois) as mois,
    f.gain_net,
    r.nb_rdv_realises,
    s.taux_satisfaction
from {{ ref('clinique_mart') }} c
left join rdv r on c.id_clinique = r.id_clinique
left join facturation f on c.id_clinique = f.id_clinique 
                       and r.annee = f.annee 
                       and r.mois = f.mois
left join satisfaction s on c.id_clinique = s.id_clinique
                        and coalesce(r.annee, f.annee) = s.annee
                        and coalesce(r.mois, f.mois) = s.mois
order by c.id_clinique, annee, mois
