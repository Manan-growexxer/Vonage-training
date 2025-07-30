CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::719056139938:role/snowflake_s3_access'
  STORAGE_ALLOWED_LOCATIONS = ('s3://iceberg-snowflake-bucket/iceberg/');

  

CREATE OR REPLACE EXTERNAL VOLUME iceberg_volume
  STORAGE_LOCATION = 's3://iceberg-snowflake-bucket/iceberg/'
  STORAGE_INTEGRATION = my_s3_integration;









-- ---------------------------------------------hybrid table----------------------
SHOW PARAMETERS LIKE 'ENABLE_HYBRID_TABLES';


-- Step 1: Create a Hybrid Table

CREATE OR REPLACE HYBRID TABLE dev_schema.orders_hybrid (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    order_date DATE,
    amount NUMBER(10, 2)
);


-- Step 2: Insert Data

INSERT INTO dev_schema.orders_hybrid (order_id, customer_id, order_date, amount)
VALUES
  (1, 1001, '2025-07-21', 1200.50),
  (2, 1002, '2025-07-20', 999.99),
  (3, 1003, '2025-07-19', 150.00);
