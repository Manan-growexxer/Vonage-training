-- Use the correct database and schema
USE DATABASE CUSTOMER_DB;
USE SCHEMA WEATHER_SCHEMA;

-- Step 1: Create the table
CREATE OR REPLACE TABLE customer_db.weather_schema.WEATHER_DATA (
    CITY STRING,
    DATE DATE,
    TEMPERATURE_C FLOAT,
    HUMIDITY_PERCENT INTEGER,
    WEATHER_CONDITION STRING
);

-- Step 2: Insert 20 records
INSERT INTO customer_db.weather_schema.WEATHER_DATA (CITY, DATE, TEMPERATURE_C, HUMIDITY_PERCENT, WEATHER_CONDITION) VALUES
('Mumbai', '2025-07-01', 32.5, 85, 'Sunny'),
('Delhi', '2025-07-01', 36.2, 60, 'Clear'),
('Bangalore', '2025-07-01', 27.8, 75, 'Rainy'),
('Chennai', '2025-07-01', 34.0, 80, 'Cloudy'),
('Kolkata', '2025-07-01', 30.5, 88, 'Thunderstorm'),
('Hyderabad', '2025-07-02', 33.1, 78, 'Sunny'),
('Ahmedabad', '2025-07-02', 35.3, 65, 'Clear'),
('Pune', '2025-07-02', 28.6, 82, 'Rainy'),
('Jaipur', '2025-07-02', 37.0, 55, 'Sunny'),
('Lucknow', '2025-07-02', 34.4, 70, 'Cloudy'),
('Bhopal', '2025-07-03', 31.2, 76, 'Rainy'),
('Indore', '2025-07-03', 30.8, 73, 'Thunderstorm'),
('Nagpur', '2025-07-03', 32.9, 68, 'Sunny'),
('Patna', '2025-07-03', 33.5, 74, 'Clear'),
('Surat', '2025-07-03', 31.1, 79, 'Rainy'),
('Ranchi', '2025-07-04', 30.4, 83, 'Thunderstorm'),
('Guwahati', '2025-07-04', 29.7, 85, 'Rainy'),
('Amritsar', '2025-07-04', 35.6, 63, 'Sunny'),
('Kanpur', '2025-07-04', 34.9, 66, 'Cloudy'),
('Vijayawada', '2025-07-04', 33.0, 81, 'Clear');


SELECT * FROM customer_db.weather_schema.WEATHER_DATA;
