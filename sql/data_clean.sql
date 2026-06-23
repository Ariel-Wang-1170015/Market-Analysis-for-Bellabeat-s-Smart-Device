-- Data Cleaning Script
-- This script creates a clean version of the daily activity data by copying the merged dataset.
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

