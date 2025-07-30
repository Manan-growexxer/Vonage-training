-- File Format
CREATE OR REPLACE FILE FORMAT dev_db.dev_schema.unload_csv_format
  TYPE = 'CSV'
  COMPRESSION = 'NONE'
  FIELD_DELIMITER = ','
 ;

--  CREATE OR REPLACE STORAGE INTEGRATION unload_s3_integration
-- TYPE = EXTERNAL_STAGE 
-- STORAGE_PROVIDER = S3
-- ENABLED = TRUE
-- STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::719056139938:role/snowflake_s3_access'
-- STORAGE_ALLOWED_LOCATIONS = ('s3://vonage-snowflake-von-3639/unload_data/');

-- SHOW GRANTS ON STAGE DEV_DB.DEV_SCHEMA.MY_S3_STAGE;


-- DESC INTEGRATION unload_s3_integration;

-- External Stage (replace with correct bucket and integration)
CREATE OR REPLACE STAGE dev_db.dev_schema.my_s3_stage
  URL = 's3://vonage-snowflake-von-3639/data/'
  STORAGE_INTEGRATION = my_s3_integration;
  

GRANT USAGE ON STAGE DEV_DB.DEV_SCHEMA.MY_S3_STAGE TO ROLE ACCOUNTADMIN;
GRANT USAGE ON STAGE DEV_DB.DEV_SCHEMA.MY_S3_STAGE TO ROLE DEV_ROLE;


CREATE OR REPLACE TABLE DEV_DB.DEV_SCHEMA.EMPLOYEES (
    id INT,
    name STRING,
    department STRING,
    salary FLOAT,
    joining_date DATE
);


SHOW STAGES IN SCHEMA DEV_DB.DEV_SCHEMA;


SELECT * FROM DEV_DB.DEV_SCHEMA.EMPLOYEE;


copy into @my_s3_stage from employee;