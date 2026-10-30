USE titanic_db;

-- 1. Survival rate by class and sex
CREATE OR REPLACE VIEW survival_by_class_sex AS
SELECT passenger_class, sex,
       COUNT(*) AS total_passengers,
       SUM(survived) AS survivors,
       ROUND(AVG(survived) * 100, 2) AS survival_rate
FROM clean_passengers
GROUP BY passenger_class, sex;


-- 2. Survival rate by age group
CREATE OR REPLACE VIEW survival_by_age_group AS
SELECT age_group,
       COUNT(*) AS total_passengers,
       SUM(survived) AS survivors,
       ROUND(AVG(survived) * 100, 2) AS survival_rate
FROM clean_passengers
GROUP BY age_group;


-- 3. Top 3 highest fares in each class
CREATE OR REPLACE VIEW top_3_fares_by_class AS
SELECT passenger_id, passenger_class, fare, fare_rank
FROM (
    SELECT passenger_id, passenger_class, fare,
           ROW_NUMBER() OVER (
               PARTITION BY passenger_class
               ORDER BY fare DESC
           ) AS fare_rank
    FROM clean_passengers
) AS ranked_fares
WHERE fare_rank <= 3;