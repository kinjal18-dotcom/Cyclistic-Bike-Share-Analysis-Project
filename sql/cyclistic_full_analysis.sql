-- CYCLISTIC BIKE-SHARE CAPSTONE ANALYSIS (DIVVY 2019)
-- Project: cyclist-capstone-509112 | Dataset: QuaterlyData
-- Combine, Clean, and Aggregate 4 Quarters for Tableau Export


-- CONSOLIDATE, STANDARDIZE, AND CLEAN RAW TRIP DATA: 

CREATE OR REPLACE TABLE `cyclist-capstone-509112.QuaterlyData.cleaned_combined_trips` AS

WITH q1_data AS (
  SELECT
    CAST(trip_id AS STRING) AS trip_id,
    TIMESTAMP(start_time) AS start_time,
    TIMESTAMP(end_time) AS end_time,
    CAST(bikeid AS STRING) AS bike_id,
    CAST(tripduration AS FLOAT64) AS trip_duration_seconds,
    CAST(from_station_id AS STRING) AS start_station_id,
    from_station_name AS start_station_name,
    CAST(to_station_id AS STRING) AS end_station_id,
    to_station_name AS end_station_name,
    usertype,
    gender,
    CAST(birthyear AS INT64) AS birth_year
  FROM `cyclist-capstone-509112.QuaterlyData.DataQ1`
),


q2_data AS (
  SELECT
    CAST(`01 - Rental Details Rental ID` AS STRING) AS trip_id,
    TIMESTAMP(`01 - Rental Details Local Start Time`) AS start_time,
    TIMESTAMP(`01 - Rental Details Local End Time`) AS end_time,
    CAST(`01 - Rental Details Bike ID` AS STRING) AS bike_id,
    CAST(`01 - Rental Details Duration In Seconds Uncapped` AS FLOAT64) AS trip_duration_seconds,
    CAST(`03 - Rental Start Station ID` AS STRING) AS start_station_id,
    `03 - Rental Start Station Name` AS start_station_name,
    CAST(`02 - Rental End Station ID` AS STRING) AS end_station_id,
    `02 - Rental End Station Name` AS end_station_name,
    `User Type` AS usertype,
    `Member Gender` AS gender,
    CAST(`05 - Member Details Member Birthday Year` AS INT64) AS birth_year
  FROM `cyclist-capstone-509112.QuaterlyData.DataQ2`
),


q3_data AS (
  SELECT
    CAST(trip_id AS STRING) AS trip_id,
    TIMESTAMP(start_time) AS start_time,
    TIMESTAMP(end_time) AS end_time,
    CAST(bikeid AS STRING) AS bike_id,
    CAST(tripduration AS FLOAT64) AS trip_duration_seconds,
    CAST(from_station_id AS STRING) AS start_station_id,
    from_station_name AS start_station_name,
    CAST(to_station_id AS STRING) AS end_station_id,
    to_station_name AS end_station_name,
    usertype,
    gender,
    CAST(birthyear AS INT64) AS birth_year
  FROM `cyclist-capstone-509112.QuaterlyData.DataQ3`
),


q4_data AS (
  SELECT
    CAST(trip_id AS STRING) AS trip_id,
    TIMESTAMP(start_time) AS start_time,
    TIMESTAMP(end_time) AS end_time,
    CAST(bikeid AS STRING) AS bike_id,
    CAST(tripduration AS FLOAT64) AS trip_duration_seconds,
    CAST(from_station_id AS STRING) AS start_station_id,
    from_station_name AS start_station_name,
    CAST(to_station_id AS STRING) AS end_station_id,
    to_station_name AS end_station_name,
    usertype,
    gender,
    CAST(birthyear AS INT64) AS birth_year
  FROM `cyclist-capstone-509112.QuaterlyData.DataQ4`
),


combined_raw AS (
  SELECT * FROM q1_data
  UNION ALL SELECT * FROM q2_data
  UNION ALL SELECT * FROM q3_data
  UNION ALL SELECT * FROM q4_data
),


cleaned_trips AS (
  SELECT
    trip_id,
    CASE
      WHEN usertype = 'Subscriber' THEN 'Member'
      WHEN usertype = 'Customer' THEN 'Casual'
      ELSE usertype
    END AS user_type,
    start_time,
    ROUND(trip_duration_seconds / 60.0, 2) AS ride_length_minutes,
    FORMAT_TIMESTAMP('%A', start_time) AS day_of_week,
    EXTRACT(DAYOFWEEK FROM start_time) AS day_of_week_num,
    EXTRACT(HOUR FROM start_time) AS start_hour
  FROM combined_raw
  WHERE
    trip_duration_seconds > 0
    AND trip_duration_seconds < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
)


SELECT
  user_type,
  day_of_week,
  day_of_week_num,
  start_hour,
  COUNT(*) AS total_trips,
  ROUND(AVG(ride_length_minutes), 2) AS avg_duration_minutes
FROM cleaned_trips
GROUP BY user_type, day_of_week, day_of_week_num, start_hour
ORDER BY day_of_week_num, start_hour, user_type;

