-- ====================================================================
-- Création de la base de données et du schéma RAW
-- ====================================================================

-- Création de la base de données principale si elle n’existe pas encore
CLINIC_DB.RAW.MY_STAGECLINIC_DB.RAW.MY_STAGEcreate database if not exists CLINIC_DB;

-- Création du schéma RAW (zone brute) pour stocker les données sources
create schema if not exists CLINIC_DB.RAW;


-- ====================================================================
-- Définition du stage et du format de fichier
-- ====================================================================

-- Définition d’un stage Snowflake (zone intermédiaire de stockage de fichiers CSV)

create or replace stage my_stage;
-- Vérification des fichiers disponibles dans le stage
list @my_stage;

-- Définition d’un format de fichier CSV utilisé pour le chargement des données
create or replace file format csv_format
  type = csv
  field_delimiter = ','             -- séparateur : virgule
  skip_header = 1                   -- ignorer la première ligne (entêtes)
  field_optionally_enclosed_by='"'  -- gérer les champs entre guillemets
  null_if = ('NULL','null','')      -- interprétation des valeurs nulles
  DATE_FORMAT = 'DD MMMM YYYY';     -- format attendu : jour mois année

-- ====================================================================
-- Création des tables RAW (zone de staging brute)
-- ====================================================================

-- Table des cliniques
create or replace table RAW.cliniques (
  id_clinique int primary key,
  nom_clinique varchar,
  region varchar,
  jours_ouverture_semaine integer -- validé plus tard via vue
);

-- Table des vétérinaires
create or replace table RAW.veterinaire (
  id_veterinaire int primary key,
  nom varchar,
  seniorite varchar,
  specialite varchar
);

-- Table des rendez-vous
create or replace table RAW.rendez_vous (
  id_rdv int primary key,
  date varchar, 
  heure time,
  id_veterinaire int,
  id_clinique int,
  type_consultation varchar,
  duree_minute integer,
  statut varchar,
  constraint fk_rdv_vet foreign key (id_veterinaire) references RAW.veterinaire(id_veterinaire),
  constraint fk_rdv_cli foreign key (id_clinique) references RAW.cliniques(id_clinique)
);

-- Table de facturation 
create or replace table RAW.facturation (
  id_facture int primary key,
  date varchar, 
  id_veterinaire int,
  id_clinique int,
  service varchar,
  montant number(10,2),
  discount number(10,2),
  avoir number(10,2),
  mode_paiement varchar,
  constraint fk_fact_vet foreign key (id_veterinaire) references RAW.veterinaire(id_veterinaire),
  constraint fk_fact_cli foreign key (id_clinique) references RAW.cliniques(id_clinique)
);

-- Table des satisfaction 
create or replace table RAW.satisfaction (
  id_feedback int primary key,
  date varchar,
  id_clinique int,
  id_veterinaire int,
  score number(5,2), 
  commentaire varchar,
  constraint fk_sat_cli foreign key (id_clinique) references RAW.cliniques(id_clinique),
  constraint fk_sat_vet foreign key (id_veterinaire) references RAW.veterinaire(id_veterinaire)
);

-- Table des ressources humaines
create or replace table RAW.ressources_humaines (
  id_veterinaire int,
  mois varchar, 
  heures_contractuelles number(10,2),
  heures_travaillees number(10,2),
  absences_heures number(10,2),
  constraint fk_rh_vet foreign key (id_veterinaire) references RAW.veterinaire(id_veterinaire)
);

--====================================================================
-- Chargement des données depuis les fichiers CSV
-- ====================================================================


-- Chargement des données cliniques
copy into RAW.cliniques
from @my_stage/cliniques.csv
file_format = (format_name = csv_format);

-- Chargement des données vétérinaires
copy into RAW.veterinaire
from @my_stage/veterinaire.csv
file_format = (format_name = csv_format);

-- Chargement des rendez-vous
copy into RAW.rendez_vous
from @my_stage/rendez_vous.csv
file_format = (format_name = csv_format);

-- Chargement des factures
copy into RAW.facturation
from @my_stage/facturation.csv
file_format = (format_name = csv_format);

-- Chargement des satisfactions
copy into RAW.satisfaction
from @my_stage/satisfaction.csv
file_format = (format_name = csv_format);

-- Chargement des données humaines
copy into RAW.ressources_humaines
from @my_stage/ressources_humaines.csv
file_format = (format_name = csv_format);

