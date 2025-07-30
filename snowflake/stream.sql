CREATE OR REPLACE TABLE customers (
  id INT,
  name STRING,
  city STRING
);

INSERT INTO customers VALUES
(1, 'Alice', 'Pune'),
(2, 'Bob', 'Delhi'),
(3, 'Charlie', 'Mumbai');


-- Create a Stream on the Table

CREATE OR REPLACE STREAM customer_stream ON TABLE learning_db.public.customers;


-- Make Changes to Source Table


-- INSERT
INSERT INTO learning_db.public.customers VALUES (4, 'David', 'Bangalore');

-- UPDATE
UPDATE learning_db.public.customers SET city = 'Ahmedabad' WHERE id = 2;

-- DELETE
DELETE FROM learning_db.public.customers WHERE id = 3;

-- Read From the Stream

SELECT 
  *,
  METADATA$ACTION,
  METADATA$ISUPDATE,
  METADATA$ROW_ID
FROM learning_db.public.customer_stream;

SELECT 
  *
FROM learning_db.public.customer_stream;

-- consume the Stream
-- Let’s say we only want to store updated rows into a tracking table.

CREATE OR REPLACE TABLE learning_db.public.updated_customers (
  id INT,
  name STRING,
  city STRING
);

-- Insert only updated records
INSERT INTO learning_db.public.updated_customers
SELECT id, name, city
FROM customer_stream
WHERE METADATA$ACTION = 'UPDATE';



