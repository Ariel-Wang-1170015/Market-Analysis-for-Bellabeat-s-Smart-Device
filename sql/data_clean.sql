-- Data Cleaning Script
-- This script creates a clean version of the daily activity data by copying the merged dataset.
--All cleaned tables are prefixed with "clean_" to distinguish them from the original merged tables， and same types of tablea should be cleaned together.
CREATE TABLE clean_dailyactivity_merged_3 AS
SELECT *
FROM fitbit.dailyactivity_merged_3;

CREATE TABLE clean_dailyactivity_merged_4 AS
SELECT *
FROM fitbit.dailyactivity_merged_4;
-- Schema overview
DESCRIBE fitbit.clean_dailyactivity_merged_3;
DESCRIBE fitbit.clean_dailyactivity_merged_4;
--column consistency check
--check if there are inconsistencies in column names between the two tables
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'fitbit'
  AND table_name = 'clean_dailyactivity_merged_3'

EXCEPT  

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'fitbit'
  AND table_name = 'clean_dailyactivity_merged_4';

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'fitbit'
  AND table_name = 'clean_dailyactivity_merged_4'

EXCEPT  

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'fitbit'
  AND table_name = 'clean_dailyactivity_merged_3';

--data types check and standardize the data types of the columns in both tables to ensure consistency
--standardize ID columns to VARCHAR(255), and date columns to DATE, and numeric columns to FLOAT
ALTER TABLE fitbit.clean_dailyactivity_merged_3
MODIFY COLUMN Id VARCHAR(255),
MODIFY COLUMN ActivityDate DATE,
MODIFY COLUMN TotalSteps FLOAT,
MODIFY COLUMN TotalDistance FLOAT,
MODIFY COLUMN Calories FLOAT;
ALTER TABLE fitbit.clean_dailyactivity_merged_4
MODIFY COLUMN Id VARCHAR(255),
MODIFY COLUMN ActivityDate DATE,
MODIFY COLUMN TotalSteps FLOAT,
MODIFY COLUMN TotalDistance FLOAT,
MODIFY COLUMN Calories FLOAT;


--check if there are inconsistencies in data types between the two tables
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT Id) AS unique_ids,
    COUNT(DISTINCT ActivityDate) AS unique_dates
FROM fitbit.clean_dailyactivity_merged_3;
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT Id) AS unique_ids,
    COUNT(DISTINCT ActivityDate) AS unique_dates
FROM fitbit.clean_dailyactivity_merged_4;
--Check ID columns are same in both tables
SELECT DISTINCT Id
FROM fitbit.clean_dailyactivity_merged_3
WHERE Id NOT IN (SELECT Id FROM fitbit.clean_dailyactivity_merged_4);

