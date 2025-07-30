import logging
import json
from jinja2 import Template
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.utils.dates import days_ago
from sql_files_reader import get_env_variables, get_rendered_sql, execute_sql_task
from emali_alert_on_success_failure import success_callback, failure_callback,default_args

with DAG(
    dag_id="Attandance_table_merge_query_to_temp_logs",
    start_date=days_ago(1),
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
    description="Runs merge query on Snowflake"
) as dag:
    run_merge = PythonOperator(
        task_id='run_merge_query',
        python_callable=execute_sql_task('/opt/airflow/scripts/merge.sql', "snowflake_dev_conn"),
        on_success_callback=success_callback,
        on_failure_callback=failure_callback
    )
