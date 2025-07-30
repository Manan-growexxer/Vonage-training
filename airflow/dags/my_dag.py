from airflow import DAG
from airflow.operators.dummy import DummyOperator
from datetime import datetime
 
with DAG(
    dag_id='my_dummy_dag',
    start_date=datetime(2024, 1, 1),  
    schedule_interval='*/1 * * * *',
    catchup=False,
    tags=['first_test'],
) as dag:
 
    start = DummyOperator(task_id='start')
    middle = DummyOperator(task_id='middle')
    end = DummyOperator(task_id='end')
 
    start >> middle >> end