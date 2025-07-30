create database airflow;

CREATE OR REPLACE TABLE airflow.public.transactions (
    transaction_id   INT,
    customer_id      STRING,
    amount           FLOAT,
    transaction_date DATE,
    payment_method   STRING
);


INSERT INTO airflow.public.transactions (
    transaction_id, customer_id, amount, transaction_date, payment_method
)
VALUES
    (1, 'C001', 150.00, '2024-01-15', 'Credit Card'),
    (2, 'C002', 250.75, '2024-01-16', 'PayPal'),
    (3, 'C001', 75.50,  '2024-01-17', 'Debit Card'),
    (4, 'C003', 300.00, '2024-02-01', 'UPI'),
    (5, 'C004', 425.90, '2024-02-10', 'Credit Card'),
    (6, 'C005', 120.00, '2024-03-05', 'Cash'),
    (7, 'C006', 89.99,  '2024-03-08', 'Credit Card'),
    (8, 'C002', 135.25, '2024-03-12', 'UPI'),
    (9, 'C004', 299.99, '2024-04-01', 'Debit Card'),
    (10, 'C001', 199.00, '2024-04-10', 'PayPal');


SELECT * FROM airflow.public.transactions;


-- --------------------------- stored procedure--------------

CREATE OR REPLACE PROCEDURE airflow.public.count_transactions()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
  txn_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO txn_count FROM airflow.public.transactions;
  RETURN 'Total transactions: ' || txn_count;
END;
$$;


CALL airflow.public.count_transactions();

-- -----------------------------------------------------------------

CREATE OR REPLACE TABLE airflow.public.proc_logs (
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    log_message STRING
);

CREATE OR REPLACE PROCEDURE airflow.public.count_transactions()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
  txn_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO :txn_count FROM airflow.public.transactions;

  RETURN 'Total transactions: ' || txn_count;
END;
$$;

