

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from datetime import datetime

# Python function to run Snowflake query and print result
def print_current_database():
    hook = SnowflakeHook(snowflake_conn_id='snowflake_dev_conn')
    conn = hook.get_conn()
    cursor = conn.cursor()
    cursor.execute("SELECT CURRENT_DATABASE();")
    result = cursor.fetchone()
    print(f"Current Snowflake database is: {result[0]}")
    cursor.close()
    conn.close()

# Define the DAG
with DAG(
    dag_id='snowflake_to_temp_logs_dag',
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=['snowflake', 'test'],
) as dag:

    log_db_name = PythonOperator(
        task_id='log_snowflake_database',
        python_callable=print_current_database
    )
