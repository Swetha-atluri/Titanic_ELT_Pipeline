
USE titanic_db;

DROP TABLE IF EXISTS stg_titanic;

CREATE TABLE stg_titanic AS
SELECT
    ROW_NUMBER() OVER () AS passenger_id,
    class AS passenger_class,
    survived,
    LOWER(TRIM(sex)) AS sex,
    age,
    sibsp,
    parch,
    fare,
    UPPER(TRIM(embarked)) AS embarked,
    alive,
    adult_male,
    alone,
    who
FROM raw_titanic;
