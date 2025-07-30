-- Staging Table — common for all types

CREATE OR REPLACE TABLE airflow.public.stg_customer (
    customer_id INT,
    name STRING,
    city STRING
);

-- For SCD Type 1 — overwrite

-- CREATE OR REPLACE TABLE airflow.public.scd1_customer (
--     customer_id INT,
--     name STRING,
--     city STRING
-- );

CREATE OR REPLACE TABLE airflow.public.scd1_customer (
    customer_id INT,
    name STRING,
    city STRING,
    
    -- Audit columns
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by STRING,
    updated_at TIMESTAMP,
    updated_by STRING
);


-- For SCD Type 2 — full history

CREATE OR REPLACE TABLE airflow.public.scd2_customer (
    customer_id INT,
    name STRING,
    city STRING,
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN
);


-- For SCD Type 3 — limited history

CREATE OR REPLACE TABLE airflow.public.scd3_customer (
    customer_id INT,
    name STRING,
    city STRING,
    previous_city STRING
);


--  smaple data
INSERT INTO airflow.public.stg_customer (customer_id, name, city)
VALUES 
    (1, 'Alice', 'Delhi'),
    (2, 'Bob', 'Mumbai'),
    (3, 'Charlie', 'Bangalore');

SHOW TABLES LIKE 'SCD1_CUSTOMER' IN SCHEMA AIRFLOW.PUBLIC;

--   --------------------------------------------------
    
select * from airflow.public.stg_customer;



-- ----------------------------------------------------

update airflow.public.stg_customer set city='Kolkata' where customer_id = 1;


INSERT INTO airflow.public.stg_customer (customer_id, name, city)
VALUES     
  (4, 'David', 'Chennai');      


-- -------------------------------scd type 1----------------



select * from airflow.public.scd1_customer;


MERGE INTO airflow.public.scd1_customer AS target
USING airflow.public.stg_customer AS source
ON target.customer_id = source.customer_id

WHEN MATCHED THEN
    UPDATE SET 
        target.name = source.name,
        target.city = source.city,
        target.updated_at = CURRENT_TIMESTAMP,
        target.updated_by = 'system'  -- or pass a dynamic user value

WHEN NOT MATCHED THEN
    INSERT (customer_id, name, city, created_by, created_at)
    VALUES (source.customer_id, source.name, source.city, 'system', CURRENT_TIMESTAMP);



-- ----------------------------scd type 2 updating exisiting records-----------------------------

select * from airflow.public.scd2_customer;


-- Step 1: Close old record if any changes found
UPDATE airflow.public.scd2_customer AS target
SET end_date = CURRENT_DATE - 1,
    is_current = FALSE
FROM airflow.public.stg_customer AS source
WHERE target.customer_id = source.customer_id
  AND target.is_current = TRUE
  AND (
      target.name IS DISTINCT FROM source.name OR
      target.city IS DISTINCT FROM source.city
  );

-- Step 2: Insert new version if record changed
INSERT INTO airflow.public.scd2_customer (
    customer_id, name, city, start_date, end_date, is_current
)
SELECT
    source.customer_id,
    source.name,
    source.city,
    CURRENT_DATE,
    NULL,
    TRUE
FROM airflow.public.stg_customer AS source
LEFT JOIN airflow.public.scd2_customer AS target
    ON source.customer_id = target.customer_id AND target.is_current = TRUE
WHERE target.customer_id IS NULL
   OR (
       target.name IS DISTINCT FROM source.name OR
       target.city IS DISTINCT FROM source.city
   );

-- --------------------------------scd type 2 insert record---------------------------


select * from airflow.public.scd2_customer;

INSERT INTO airflow.public.scd2_customer (
    customer_id, name, city, start_date, end_date, is_current
)
SELECT
    source.customer_id,
    source.name,
    source.city,
    CURRENT_DATE,
    NULL,
    TRUE
FROM airflow.public.stg_customer AS source
LEFT JOIN airflow.public.scd2_customer AS target
    ON source.customer_id = target.customer_id AND target.is_current = TRUE
WHERE target.customer_id IS NULL;


-- ----------------------------scd type 3------------------------------

select * from airflow.public.scd3_customer;


MERGE INTO airflow.public.scd3_customer AS target
USING airflow.public.stg_customer AS source
ON target.customer_id = source.customer_id

WHEN MATCHED AND target.city != source.city
THEN
  UPDATE SET 
    previous_city = target.city,
    city = source.city,
    name = source.name

WHEN NOT MATCHED THEN
  INSERT (customer_id, name, city, previous_city)
  VALUES (source.customer_id, source.name, source.city, NULL);
