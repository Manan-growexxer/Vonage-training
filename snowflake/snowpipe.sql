CREATE OR REPLACE TABLE learning_db.public.transactions (
    transaction_id   INT,
    customer_id      STRING,
    amount           FLOAT,
    transaction_date DATE,
    payment_method   STRING
);



CREATE OR REPLACE FILE FORMAT learning_db.public.my_csv_format
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;


-- --------------------------------------------

CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
TYPE = EXTERNAL_STAGE 
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::719056139938:role/snowflake_s3_access'
STORAGE_ALLOWED_LOCATIONS = ('s3://vonage-snowflake-von-3639/data/');



DESC INTEGRATION my_s3_integration;


CREATE OR REPLACE STAGE learning_db.public.my_ext_stage
  URL='s3://vonage-snowflake-von-3639/data/'
  STORAGE_INTEGRATION = my_s3_integration
  FILE_FORMAT = (TYPE = 'CSV',SKIP_HEADER = 1);



List @learning_db.public.my_ext_stage;

Desc stage learning_db.public.my_ext_stage ;

-- -------------------------------------------------

CREATE OR REPLACE PIPE learning_db.public.s3_to_transactions_snowpipe
AUTO_INGEST = TRUE
AS
COPY INTO learning_db.public.transactions (transaction_id, customer_id, amount, transaction_date, payment_method)
FROM @learning_db.public.my_ext_stage
FILE_FORMAT = learning_db.public.my_csv_format;


DESC PIPE learning_db.public.s3_to_transactions_snowpipe;

show pipes;

select * from learning_db.public.transactions;
