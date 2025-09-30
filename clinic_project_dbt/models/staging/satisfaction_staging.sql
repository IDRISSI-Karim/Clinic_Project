-- ====================================================================
-- Transformation : Nettoyage et déduplication des données de satisfaction
-- ====================================================================
select id_feedback,
  date,       
  id_clinique,
  id_veterinaire,
  score,
  commentaire,
FROM(
  select id_feedback,
  {{ varchar_to_date('date') }}  as date,        
  id_clinique,
  id_veterinaire,
  TRIM(commentaire) as commentaire,
  CASE 
            WHEN score < 0 THEN 0
            WHEN score > 10 THEN 10
            ELSE score
        END AS score,
        ROW_NUMBER() OVER (
            PARTITION BY id_feedback
            ORDER BY id_feedback
        ) AS rn
    FROM {{ source('RAW', 'satisfaction') }}
)
WHERE rn = 1