CREATE OR REPLACE TABLE learning_db.public.sales_data (
  id INT,
  region STRING,
  amount FLOAT
);


INSERT INTO learning_db.public.sales_data (id, region, amount) VALUES
  (1, 'North', 1000),
  (2, 'South', 1500),
  (3, 'East', 1200),
  (4, 'North', 1100),
  (5, 'South', 1300);


-- CREATE OR REPLACE ROLE NORTH_ROLE;
-- CREATE OR REPLACE ROLE SOUTH_ROLE;



-- create policy

CREATE OR REPLACE ROW ACCESS POLICY region_policy
AS (region STRING) 
RETURNS BOOLEAN ->
  CASE
    WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN region = 'North'
    WHEN CURRENT_ROLE() = 'DEV_ROLE' THEN region = 'South'
    ELSE FALSE
  END;


ALTER TABLE sales_data
ADD ROW ACCESS POLICY region_policy ON (region);


select * from learning_db.public.sales_data;