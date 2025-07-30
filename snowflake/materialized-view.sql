CREATE OR REPLACE TABLE learning_db.public.orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  order_value FLOAT,
  region STRING
);


INSERT INTO learning_db.public.orders (order_id, customer_id, order_date, order_value, region) VALUES
  (1, 101, '2024-07-01', 2500.00, 'East'),
  (2, 102, '2024-07-01', 1200.00, 'West'),
  (3, 101, '2024-07-02', 3000.00, 'East'),
  (4, 103, '2024-07-02', 500.00,  'North'),
  (5, 104, '2024-07-03', 7000.00, 'West'),
  (6, 102, '2024-07-03', 800.00,  'West'),
  (7, 105, '2024-07-04', 4000.00, 'South'),
  (8, 101, '2024-07-04', 1500.00, 'East'),
  (9, 106, '2024-07-05', 2200.00, 'North'),
  (10, 107, '2024-07-05', 3300.00, 'South');

-- example 1 

CREATE OR REPLACE MATERIALIZED VIEW learning_db.public.top_customers_mv AS
SELECT
  customer_id,
  SUM(order_value) AS total_spent
FROM orders
GROUP BY customer_id;


SELECT * FROM learning_db.public.top_customers_mv WHERE total_spent > 4000;


-- example 2

CREATE OR REPLACE MATERIALIZED VIEW learning_db.public.region_sales_mv AS
SELECT
  region,
  SUM(order_value) AS monthly_sales
FROM orders
WHERE order_date <= '2024-08-01'
GROUP BY region;



SELECT * FROM learning_db.public.region_sales_mv WHERE region='East';