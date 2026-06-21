-- Data Cleaning Script

-- Check schema
DESCRIBE dailyactivity_mergerd_3;

-- Convert date
UPDATE dailyactivity_mergerd_3
SET ActivityDate = STR_TO_DATE(ActivityDate, '%m/%d/%Y');

-- Handle missing values
UPDATE dailyactivity_mergerd_3
SET TotalSteps = 0
WHERE TotalSteps IS NULL;
