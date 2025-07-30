from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import logging

# Push data to XCom
def push_function(ti):
    message = "Hello from Task 1!"
    ti.xcom_push(key='message_key', value=message)
    logger = logging.getLogger("airflow.task")
    logger.info("Message pushed to XCom: %s", message)

# Pull data from XCom
def pull_function(ti):
    logger = logging.getLogger("airflow.task")
    message = ti.xcom_pull(task_ids='push_task', key='message_key')
    logger.info("Received message from XCom: %s", message)

default_args = {
    'start_date': datetime(2024, 1, 1),
}

with DAG('xcom_to_temp_logs_dag',
         schedule_interval='@once',
         catchup=False,
         default_args=default_args,
         description='A simple DAG to demonstrate XCom') as dag:

    push_task = PythonOperator(
        task_id='push_task',
        python_callable=push_function
    )

    pull_task = PythonOperator(
        task_id='pull_task',
        python_callable=pull_function
    )

    push_task >> pull_task
