-- Source table (like staging)
CREATE OR REPLACE TABLE learning_db.public.sales_stage (
  id INT,
  amount FLOAT
);

-- Target table (reporting)
CREATE OR REPLACE TABLE learning_db.public.sales_target (
  id INT,
  amount FLOAT
);


-- New data in stage
INSERT INTO learning_db.public.sales_stage VALUES (1, 100.0), (2, 200.0);


-- Scheduled MERGE Every 1 Minute

CREATE OR REPLACE TASK learning_db.public.refresh_sales_task
  WAREHOUSE = compute_wh  -- change if you use another WH
  SCHEDULE = '1 MINUTE'   -- or use CRON format
AS
  MERGE INTO sales_target t
  USING sales_stage s
  ON t.id = s.id
  WHEN MATCHED THEN UPDATE SET amount = s.amount
  WHEN NOT MATCHED THEN INSERT (id, amount) VALUES (s.id, s.amount);


-- Start the Task

ALTER TASK learning_db.public.refresh_sales_task RESUME;


-- View all tasks
SHOW TASKS;

-- View execution history
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE NAME = 'REFRESH_SALES_TASK'
ORDER BY SCHEDULED_TIME DESC;



select * from learning_db.public.sales_target;
select * from learning_db.public.sales_stage;

-- suspend the tasks

ALTER TASK learning_db.public.refresh_sales_task SUSPEND;
ALTER TASK learning_db.public.log_sales_count SUSPEND;

-- Task B: Chain Another Task

CREATE OR REPLACE TASK learning_db.public.log_sales_count
  WAREHOUSE = compute_wh
  AFTER refresh_sales_task
AS
  INSERT INTO learning_db.public.sales_stage VALUES (-1, (SELECT COUNT(*) FROM sales_target));



ALTER TASK learning_db.public.refresh_sales_task RESUME;
ALTER TASK learning_db.public.log_sales_count RESUME;


