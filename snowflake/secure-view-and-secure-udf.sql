CREATE OR REPLACE TABLE learning_db.public.orders (
  order_id INT,
  customer_id INT,
  region STRING,
  order_value NUMBER
);

INSERT INTO learning_db.public.orders VALUES
  (1, 101, 'North', 500),
  (2, 102, 'South', 1200),
  (3, 101, 'North', 700),
  (4, 103, 'East', 300);


-- ----------------------------------Secure Views-----------------------------

CREATE OR REPLACE SECURE VIEW learning_db.public.revenue_view AS
SELECT customer_id, SUM(order_value) AS total_spent
FROM learning_db.public.orders
GROUP BY customer_id;

SELECT * FROM learning_db.public.revenue_view;


SHOW VIEWS LIKE 'revenue_view'; -- shows only metadata, not logic


-- if you want DEV_ROLE to query (but not see logic)

GRANT USAGE ON SCHEMA LEARNING_DB.public TO ROLE DEV_ROLE;
GRANT SELECT ON VIEW revenue_view TO ROLE DEV_ROLE;





--  ---------------------Secure UDFs (User-Defined Functions)--------------------------------


CREATE OR REPLACE TABLE learning_db.public.employees (
  emp_id INT,
  employee_name STRING,
  salary NUMBER
);

INSERT INTO learning_db.public.employees VALUES
  (1, 'Alice', 100000),
  (2, 'Bob', 95000),
  (3, 'Charlie', 85000);


--  -----------------------Create Secure UDF------------------------

CREATE OR REPLACE SECURE FUNCTION learning_db.public.mask_salary(salary NUMBER)
RETURNS STRING
AS
$$
  CASE
    WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN TO_VARCHAR(salary)
    ELSE 'CONFIDENTIAL'
  END
$$;



USE ROLE ACCOUNTADMIN;  -- Should show salary
SELECT employee_name, mask_salary(salary) FROM learning_db.public.employees;


-- Replace with your DB and schema
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE PUBLIC;
GRANT USAGE ON DATABASE LEARNING_DB TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA LEARNING_DB.public TO ROLE PUBLIC;
GRANT SELECT ON TABLE LEARNING_DB.public.employees TO ROLE PUBLIC;


USE ROLE public;    -- Or any other role, should return 'CONFIDENTIAL'

SELECT employee_name, mask_salary(salary) FROM LEARNING_DB.public.employees;





-- -------------------------------------------------

DROP VIEW IF EXISTS learning_db.public.revenue_view;
DROP FUNCTION IF EXISTS learning_db.public.mask_salary(NUMBER);
DROP TABLE IF EXISTS learning_db.public.orders;
DROP TABLE IF EXISTS learning_db.public.employees;
