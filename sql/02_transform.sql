
USE titanic_db;

DROP TABLE IF EXISTS clean_passengers;

CREATE TABLE clean_passengers AS
WITH age_filled AS (
    SELECT
        passenger_id,
        passenger_class,
        survived,
        sex,
        COALESCE(
            age,
            AVG(age) OVER (
                PARTITION BY passenger_class, sex
            )
        ) AS age,
        sibsp,
        parch,
        fare,
        embarked
    FROM stg_titanic
),
embarked_filled AS (
    SELECT
        *,
        COALESCE(
            embarked,
            (
                SELECT embarked
                FROM stg_titanic
                WHERE embarked IS NOT NULL
                GROUP BY embarked
                ORDER BY COUNT(*) DESC
                LIMIT 1
            )
        ) AS clean_embarked
    FROM age_filled
)
SELECT
    passenger_id,
    passenger_class,
    survived,
    CASE
        WHEN sex = 'male' THEN 0
        WHEN sex = 'female' THEN 1
        ELSE NULL
    END AS sex,
    age,
    sibsp,
    parch,
    fare,
    clean_embarked AS embarked,
    CASE
        WHEN age <= 12 THEN 'Child'
        WHEN age <= 19 THEN 'Teen'
        WHEN age <= 59 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,
    sibsp + parch + 1 AS family_size,
    CASE
        WHEN sibsp + parch = 0 THEN 1
        ELSE 0
    END AS is_alone,
    NTILE(4) OVER (ORDER BY fare) AS fare_category
FROM embarked_filled;
