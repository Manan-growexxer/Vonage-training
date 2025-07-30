-- Role with full access to PII
CREATE OR REPLACE ROLE full_access_role;

-- Role with limited access
CREATE OR REPLACE ROLE limited_access_role;


CREATE OR REPLACE MASKING POLICY learning_db.public.mask_email_policy 
AS (val STRING) 
RETURNS STRING ->
  CASE 
    WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN val
    ELSE CONCAT('XXX@', SPLIT_PART(val, '@', 2))
  END;

-- DROP MASKING POLICY mask_email_policy;


drop table learning_db.public.employees;

CREATE OR REPLACE TABLE learning_db.public.employees (
  emp_id INT,
  name STRING,
  email STRING
);

-- Add data
INSERT INTO learning_db.public.employees VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@gmail.com');

-- Apply masking policy
ALTER TABLE learning_db.public.employees
MODIFY COLUMN email SET MASKING POLICY mask_email_policy;


GRANT USAGE ON DATABASE learning_db TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA learning_db.public TO ROLE ACCOUNTADMIN;
GRANT SELECT ON TABLE learning_db.public.employees TO ROLE ACCOUNTADMIN;

GRANT USAGE ON DATABASE learning_db TO ROLE dev_role;
GRANT USAGE ON SCHEMA learning_db.public  TO ROLE dev_role;
GRANT SELECT ON TABLE learning_db.public.employees TO ROLE dev_role;



-- Switch to full access
USE ROLE ACCOUNTADMIN;
SELECT * FROM learning_db.public.employees;
-- Shows full email


