-- Permanent Table – employee_data

CREATE OR REPLACE TABLE learning_db.public.employee_data (
  id INT,
  name STRING,
  salary NUMBER
);

INSERT INTO learning_db.public.employee_data VALUES 
  (1, 'Alice', 55000),
  (2, 'Bob', 60000),
  (3, 'Charlie', 62000);

SELECT * FROM learning_db.public.employee_data;



-- Transient Table – temp_sales


CREATE OR REPLACE TRANSIENT TABLE learning_db.public.temp_sales (
  id INT,
  total FLOAT
);

INSERT INTO learning_db.public.temp_sales VALUES 
  (1, 100.5),
  (2, 200.0),
  (3, 150.75);

SELECT * FROM learning_db.public.temp_sales;

DROP TABLE learning_db.public.temp_sales;

UNDROP TABLE learning_db.public.temp_sales;



-- Temporary Table – temp_results

CREATE OR REPLACE TEMPORARY TABLE learning_db.public.temp_results (
  step INT,
  result STRING
);

INSERT INTO learning_db.public.temp_results VALUES 
  (1, 'Pass'),
  (2, 'Fail'),
  (3, 'Pass');

SELECT * FROM learning_db.public.temp_results;

SHOW TABLES LIKE 'temp_results';
