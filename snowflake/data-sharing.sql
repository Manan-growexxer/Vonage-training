-- USE ROLE ACCOUNTADMIN;
-- Create Sample Data


CREATE OR REPLACE DATABASE sales_db;
USE sales_db;

CREATE OR REPLACE TABLE sales_db.public.orders (
  order_id INT,
  region STRING,
  amount FLOAT
);

INSERT INTO sales_db.public.orders VALUES
  (101, 'North', 250.0),
  (102, 'South', 320.5),
  (103, 'East', 410.0);

  

  -- Create the Share Object

CREATE OR REPLACE SHARE sales_share;

-- Grant Access to Data

-- Replace with your actual database and table if different
GRANT USAGE ON DATABASE sales_db TO SHARE SALES_SHARE;
GRANT USAGE ON SCHEMA sales_db.public TO SHARE SALES_SHARE;
GRANT SELECT ON TABLE sales_db.public.orders TO SHARE SALES_SHARE;


-- ALTER SHARE sales_share ADD ACCOUNTS = LW09816;



CREATE MANAGED ACCOUNT reader_account_india
  TYPE = READER
  ADMIN_NAME = reader_admin
  ADMIN_PASSWORD = 'ReaderAccount@2025';
  
SHOW MANAGED ACCOUNTS;

ALTER SHARE SALES_SHARE ADD ACCOUNTS = ZD84465;


SELECT CURRENT_ACCOUNT();


SHOW SHARES LIKE 'SALES_SHARE';

