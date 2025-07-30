CREATE OR REPLACE TABLE learning_db.public.transactions (
  txn_id INT,
  item STRING,
  amount FLOAT,
  txn_date DATE
);



CREATE OR REPLACE FILE FORMAT learning_db.public.my_csv_format 
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1;


CREATE OR REPLACE STAGE learning_db.public.my_stage;

LIST @learning_db.public.my_stage;


COPY INTO transactions(txn_id,item,amount,txn_date)
FROM @my_stage/transactions.csv
FILE_FORMAT = 'my_csv_format'
ON_ERROR = 'SKIP_FILE';


COPY INTO my_table (col1, col2, col3, col4, col5, col8, col9, col10, col11, col12)
FROM (
  SELECT 
    $1, $2, $3, $4, $5, $8, $9, $10, $11, $12
  FROM @my_stage/my_file.csv
)
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');


COPY INTO transactions(txn_id,item,amount,txn_date)
FROM @my_stage/transactions.csv
FILE_FORMAT = 'my_csv_format'
ON_ERROR = 'CONTINUE';  



COPY INTO transactions(txn_id,item,amount,txn_date)
FROM @my_stage/transactions.csv
FILE_FORMAT = 'my_csv_format'
VALIDATION_MODE = 'RETURN_ERRORS';


select * from learning_db.public.transactions;

drop table learning_db.public.transactions;



-- ------File Format--------------------

List @learning_db.public.my_stage;



-- Create a JSON File Format
CREATE OR REPLACE FILE FORMAT learning_db.public.json_format 
  TYPE = 'JSON';

-- Create Table to Match JSON Structure
CREATE OR REPLACE TABLE learning_db.public.raw_events (
  event VARIANT
);

-- Load the JSON File into Table
COPY INTO raw_events(event)
FROM @my_stage/raw_events.json
FILE_FORMAT = (FORMAT_NAME = json_format);

select * from learning_db.public.raw_events;


-- -------------------------loading through s3--------------------

CREATE OR REPLACE FILE FORMAT learning_db.public.my_csv_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1
NULL_IF = ('NULL', 'null');





LIST @learning_db.public.my_ext_stage;


CREATE OR REPLACE TABLE learning_db.public.transactions (
    transaction_id STRING,
    customer_id STRING,
    amount FLOAT,
    transaction_date DATE
);



COPY INTO transactions(txn_id,item,amount,txn_date)
FROM @my_ext_stage/transactions.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')
ON_ERROR = 'SKIP_FILE';


COPY INTO transactions(txn_id,item,amount,txn_date)
FROM @my_ext_stage/transactions.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')
ON_ERROR = 'CONTINUE';



-- ---------------------------------------


CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::719056139938:role/snowflake_s3_access'
STORAGE_ALLOWED_LOCATIONS = ('s3://s3-load-data-snowflake-bucket/');



DESC INTEGRATION my_s3_integration;



CREATE OR REPLACE STAGE learning_db.public.my_ext_stage
URL = 's3://s3-load-data-snowflake-bucket/'
STORAGE_INTEGRATION = my_s3_integration
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);


LIST @learning_db.public.my_ext_stage;


COPY INTO transactions(txn_id,item,amount,txn_date)
FROM @my_ext_stage/transactions.csv
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1)
ON_ERROR= 'CONTINUE';



COPY INTO transactions(txn_id,item,amount,txn_date)
FROM @my_ext_stage/transactions.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')
VALIDATION_MODE = 'RETURN_ERRORS';