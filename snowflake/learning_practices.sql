SELECT *
FROM customer_db.weather_schema.WEATHER_DATA;


SELECT * FROM customer_db.weather_schema.WEATHER_DATA SAMPLE (10);

SELECT * FROM customer_db.weather_schema.WEATHER_DATA SAMPLE SYSTEM (10);



CREATE STORAGE INTEGRATION my_s3_integration 
  TYPE = EXTERNAL_STAGE 
  STORAGE_PROVIDER = 'S3' 
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:s3:::vonage-snowflake-bucket/Titanic-Dataset.csv' 
  STORAGE_ALLOWED_LOCATIONS = ('s3://vonage-snowflake-bucket/Titanic-Dataset.csv'); 
  

CREATE OR REPLACE STAGE customer_db.weather_schema.my_s3_stage 
  URL = 's3://vonage-snowflake-bucket/Titanic-Dataset.csv' 
  STORAGE_INTEGRATION = my_s3_integration 
  FILE_FORMAT = (TYPE = 'CSV');