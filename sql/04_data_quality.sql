
USE titanic_db;

-- Create a table to store quality check results
CREATE TABLE IF NOT EXISTS dq_results (
    check_name VARCHAR(100),
    status VARCHAR(10),
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clear old results before running checks
DELETE FROM dq_results;

-- 1. Check raw and clean row counts
INSERT INTO dq_results (check_name, status)
SELECT 'Row count check',
       IF(
           (SELECT COUNT(*) FROM raw_titanic) =
           (SELECT COUNT(*) FROM clean_passengers),
           'PASS', 'FAIL'
       );

-- 2. Check for missing age
INSERT INTO dq_results (check_name, status)
SELECT 'Missing age check',
       IF(COUNT(*) = 0, 'PASS', 'FAIL')
FROM clean_passengers
WHERE age IS NULL;

-- 3. Check for missing embarked
INSERT INTO dq_results (check_name, status)
SELECT 'Missing embarked check',
       IF(COUNT(*) = 0, 'PASS', 'FAIL')
FROM clean_passengers
WHERE embarked IS NULL;

-- 4. Check for duplicate passenger IDs
INSERT INTO dq_results (check_name, status)
SELECT 'Duplicate passenger check',
       IF(COUNT(*) = 0, 'PASS', 'FAIL')
FROM (
    SELECT passenger_id
    FROM clean_passengers
    GROUP BY passenger_id
    HAVING COUNT(*) > 1
) AS duplicates;

-- 5. Check age range
INSERT INTO dq_results (check_name, status)
SELECT 'Age range check',
       IF(COUNT(*) = 0, 'PASS', 'FAIL')
FROM clean_passengers
WHERE age < 0 OR age > 100;

-- 6. Check sex values
INSERT INTO dq_results (check_name, status)
SELECT 'Sex value check',
       IF(COUNT(*) = 0, 'PASS', 'FAIL')
FROM clean_passengers
WHERE sex NOT IN (0, 1) OR sex IS NULL;

-- Display results
SELECT * FROM dq_results;
