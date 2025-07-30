CREATE OR REPLACE TABLE learning_db.public.sales_data (
  id INT,
  name STRING,
  price_cents INT,
  sale_date STRING
);


INSERT INTO learning_db.public.sales_data (id, name, price_cents, sale_date) VALUES
  (1, 'Alice', 12999, '2025-07-10'),
  (2, 'Bob', NULL, '2025-07-11'),
  (3, 'Charlie', 4599, '2025-07-12'),
  (4, 'diana', 9999, '2025-07-13'),
  (5, 'Edward', 12000, 'invalid-date');


-- 1. Uppercase Names + Convert Price to Dollars + Parse Date

SELECT 
  id,
  UPPER(name) AS name_upper,
  price_cents / 100.0 AS price_dollars,
  TRY_TO_DATE(sale_date, 'YYYY-MM-DD') AS formatted_date
FROM learning_db.public.sales_data;


-- 2. Add GST/Tax Amount (18%)

SELECT 
  id,
  name,
  price_cents / 100.0 AS price_dollars,
  (price_cents / 100.0) * 0.18 AS gst_amount
FROM learning_db.public.sales_data
WHERE price_cents IS NOT NULL;


-- 3. Filter Only Valid Dates from Data

-- TRY_TO_DATE() attempts to convert a string into a date using a given format.
-- If the conversion fails, instead of throwing an error (like TO_DATE() does), it returns NULL.

SELECT * 
FROM learning_db.public.sales_data
WHERE TRY_TO_DATE(sale_date, 'YYYY-MM-DD') IS NOT NULL;


-- 4. View Recent Sales (Last 7 Days)

SELECT * 
FROM learning_db.public.sales_data
WHERE TRY_TO_DATE(sale_date, 'YYYY-MM-DD') >= CURRENT_DATE - INTERVAL '7 DAYS';



