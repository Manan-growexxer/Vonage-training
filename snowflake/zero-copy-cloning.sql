-- clone a table
CREATE OR REPLACE TABLE learning_db.public.sales (
  order_id INT,
  customer_name STRING,
  amount FLOAT
);

INSERT INTO learning_db.public.sales VALUES
  (101, 'Alice', 250.0),
  (102, 'Bob', 180.5),
  (103, 'Charlie', 300.75);


CREATE TABLE learning_db.public.sales_clone CLONE learning_db.public.sales;


SELECT * FROM learning_db.public.sales_clone;


INSERT INTO learning_db.public.sales_clone VALUES (104, 'David', 210.0);


SELECT * FROM learning_db.public.sales;  

SELECT * FROM learning_db.public.sales_clone; 





-- clone a schema
CREATE OR REPLACE SCHEMA learning_db.public.prod_schema;

CREATE OR REPLACE TABLE learning_db.public.prod_schema.orders (
  order_id INT,
  item STRING,
  price FLOAT
);

INSERT INTO learning_db.public.prod_schema.orders VALUES
  (201, 'Mobile', 12000),
  (202, 'Laptop', 75000);



CREATE SCHEMA learning_db.public.dev_schema CLONE learning_db.public.prod_schema;

