CREATE OR REPLACE TABLE learning_db.public.products (
  product_id INT,
  product_name STRING,
  price FLOAT
);


INSERT INTO learning_db.public.products (product_id, product_name, price) VALUES
  (1, 'Laptop', 75000),
  (2, 'Smartphone', 25000),
  (3, 'Monitor', 12000),
  (4, 'Keyboard', 1500),
  (5, 'Headphones', 3000);


CREATE OR REPLACE FUNCTION calculate_discount(price FLOAT)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'apply_discount'
AS
$$
def apply_discount(price):
    return price * 0.9
$$;


SELECT 
  product_id, 
  product_name,
  price, 
  calculate_discount(price) AS discounted_price
FROM learning_db.public.products;




-- ---------------------stored procedures------------------
DESC TABLE learning_db.public.sales;
select * from learning_db.public.sales;



CREATE OR REPLACE PROCEDURE update_status()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python') 
  HANDLER = 'run'
AS
$$
def run(session):
    df = session.table("sales")
    updated = df.filter(df["amount"] > 200)
    updated.write.save_as_table("high_value_orders", mode="overwrite")
    return "Success"
$$;



CALL update_status();

SELECT * FROM high_value_orders;




-- ------------------------------


CREATE OR REPLACE TABLE learning_db.public.AUDIT_LOG_TABLE (
    USERNAME VARCHAR,
    ACTIVITY VARCHAR,
    LOG_TIME TIMESTAMP
);

CREATE OR REPLACE PROCEDURE insert_audit_log(user_name VARCHAR, activity VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
  BEGIN
    INSERT INTO AUDIT_LOG_TABLE (USERNAME, ACTIVITY, LOG_TIME)
    VALUES (:user_name, :activity, CURRENT_TIMESTAMP());

    RETURN 'Inserted successfully';
  END;
$$;



-- Call it:
CALL insert_audit_log('Manan', 'Logged in');

select * from learning_db.public.audit_log_table;