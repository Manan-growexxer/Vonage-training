-- File Format
CREATE OR REPLACE FILE FORMAT dev_db.dev_schema.my_csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null')
  EMPTY_FIELD_AS_NULL = TRUE;

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
