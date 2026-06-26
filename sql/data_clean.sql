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
MODIFY COLUMN TotalSteps INT,
MODIFY COLUMN TotalDistance DECIMAL(10,2),
MODIFY COLUMN TrackerDistance DECIMAL(10,2),
MODIFY COLUMN LoggedActivitiesDistance DECIMAL(10,2),
MODIFY COLUMN VeryActiveDistance DECIMAL(10,2),
MODIFY COLUMN ModeratelyActiveDistance DECIMAL(10,2),
MODIFY COLUMN LightActiveDistance DECIMAL(10,2),
MODIFY COLUMN SedentaryActiveDistance DECIMAL(10,2),
MODIFY COLUMN VeryActiveMinutes INT,
MODIFY COLUMN FairlyActiveMinutes INT,
MODIFY COLUMN LightlyActiveMinutes INT,
MODIFY COLUMN SedentaryMinutes INT,
MODIFY COLUMN Calories DECIMAL(10,2);
--as error 1929 happens when trying to convert the ActivityDate column to DATE type, we will create a new column ActivityDate_new of DATE type, and then copy the values from ActivityDate to ActivityDate_new, and then drop the original ActivityDate column, and rename ActivityDate_new to ActivityDate.
SELECT ActivityDate
FROM fitbit.clean_dailyactivity_merged_4
LIMIT 10;
ALTER TABLE fitbit.clean_dailyactivity_merged_4
ADD COLUMN ActivityDate_new DATE after ID;
--remove the limitation of safe updates to allow the update of the new column
SET SQL_SAFE_UPDATES = 0;
--update the new column with the values from the original column, converting the string to date format
UPDATE fitbit.clean_dailyactivity_merged_4
SET ActivityDate_new = STR_TO_DATE(ActivityDate, '%m/%d/%Y')
WHERE ActivityDate LIKE '%/%';
--restore the limitation of safe updates
SET SQL_SAFE_UPDATES = 1;
--check if there are any NULL values in the new column, which would indicate that the conversion failed for some rows
SELECT ActivityDate, ActivityDate_new
FROM fitbit.clean_dailyactivity_merged_4
WHERE ActivityDate_new IS NULL
LIMIT 10;
--check there is no NULL values in the new column
SELECT COUNT(*) AS null_count
FROM fitbit.clean_dailyactivity_merged_4
WHERE ActivityDate_new IS NULL;
--if there are no NULL values in the new column, we can drop the original column and rename the new column to the original name
ALTER TABLE fitbit.clean_dailyactivity_merged_4
DROP COLUMN ActivityDate;
--rename the new column to the original name
ALTER TABLE fitbit.clean_dailyactivity_merged_4
CHANGE COLUMN ActivityDate_new ActivityDate DATE;

ALTER TABLE fitbit.clean_dailyactivity_merged_4
MODIFY COLUMN Id VARCHAR(255),
MODIFY COLUMN ActivityDate DATE,
MODIFY COLUMN TotalSteps INT,
MODIFY COLUMN TotalDistance DECIMAL(10,2),
MODIFY COLUMN TrackerDistance DECIMAL(10,2),
MODIFY COLUMN LoggedActivitiesDistance DECIMAL(10,2),
MODIFY COLUMN VeryActiveDistance DECIMAL(10,2),
MODIFY COLUMN ModeratelyActiveDistance DECIMAL(10,2),
MODIFY COLUMN LightActiveDistance DECIMAL(10,2),
MODIFY COLUMN SedentaryActiveDistance DECIMAL(10,2),
MODIFY COLUMN VeryActiveMinutes INT,
MODIFY COLUMN FairlyActiveMinutes INT,
MODIFY COLUMN LightlyActiveMinutes INT,
MODIFY COLUMN SedentaryMinutes INT,
MODIFY COLUMN Calories DECIMAL(10,2);

--primary key check
--check if there are any duplicate records and null values in the two tables based on the primary key columns (Id, ActivityDate)
SELECT Id, ActivityDate, COUNT(*) AS count
FROM fitbit.clean_dailyactivity_merged_3
GROUP BY Id, ActivityDate
HAVING count > 1 or count IS NULL;
SELECT Id, ActivityDate, COUNT(*) AS count
FROM fitbit.clean_dailyactivity_merged_4
GROUP BY Id, ActivityDate
HAVING count > 1 OR count IS NULL;

--check id columns are correctly formatted including not having any null values, spaces, or special characters
SELECT Id
FROM fitbit.clean_dailyactivity_merged_3
WHERE Id IS NULL
   OR TRIM(Id) = ''
   OR Id REGEXP '[^0-9]';
SELECT Id
FROM fitbit.clean_dailyactivity_merged_4
WHERE Id IS NULL
    OR TRIM(Id) = ''
    OR Id REGEXP '[^0-9]';

--Also check ID columns are same in both tables
SELECT DISTINCT Id
FROM fitbit.clean_dailyactivity_merged_3
WHERE Id NOT IN (SELECT Id FROM fitbit.clean_dailyactivity_merged_4);
--found 2 ID only exist in clean_dailyactivity_merged_3 but not in clean_dailyactivity_merged_4, which are 2891001357, 6391747486, it is hard to identify which one is correct, so we will keep both of them in the final cleaned dataset.

--missing value check
--check if there are any missing values in the two tables
SELECT *
FROM fitbit.clean_dailyactivity_merged_3
WHERE Id IS NULL
    OR ActivityDate IS NULL
    OR TotalSteps IS NULL
    OR TotalDistance IS NULL
    OR TrackerDistance IS NULL
    OR LoggedActivitiesDistance IS NULL
    OR VeryActiveDistance IS NULL
    OR ModeratelyActiveDistance IS NULL
    OR LightActiveDistance IS NULL
    OR SedentaryActiveDistance IS NULL
    OR VeryActiveMinutes IS NULL
    OR FairlyActiveMinutes IS NULL
    OR LightlyActiveMinutes IS NULL
    OR SedentaryMinutes IS NULL
    OR Calories IS NULL;
SELECT *
FROM fitbit.clean_dailyactivity_merged_4
WHERE Id IS NULL
    OR ActivityDate IS NULL
    OR TotalSteps IS NULL
    OR TotalDistance IS NULL
    OR TrackerDistance IS NULL
    OR LoggedActivitiesDistance IS NULL
    OR VeryActiveDistance IS NULL
    OR ModeratelyActiveDistance IS NULL
    OR LightActiveDistance IS NULL
    OR SedentaryActiveDistance IS NULL
    OR VeryActiveMinutes IS NULL
    OR FairlyActiveMinutes IS NULL
    OR LightlyActiveMinutes IS NULL
    OR SedentaryMinutes IS NULL
    OR Calories IS NULL;

    
