-- Data Cleaning Script
-- Schema overiew
DESCRIBE fitbit. dailyactivity_merged_3;

--column consistency check
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT Id) AS unique_ids,
    COUNT(DISTINCT ActivityDate) AS unique_dates
FROM fitbit.dailyactivity_merged_3;
