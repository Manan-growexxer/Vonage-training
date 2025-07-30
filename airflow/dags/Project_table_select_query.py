import logging
import json
from jinja2 import Template
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.utils.dates import days_ago
from sql_files_reader import get_env_variables, get_rendered_sql, execute_sql_task   # Python Common File
from emali_alert_on_success_failure import success_callback, failure_callback , default_args # Email Alert Callbacks
with DAG(
    dag_id="Project_table_select_query_to_temp_logs",
    start_date=days_ago(1),
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
    description="Runs select query from Snowflake"
) as dag:
    run_select = PythonOperator(
        task_id='run_select_query',
        python_callable=execute_sql_task('/opt/airflow/scripts/select.sql', "snowflake_dev_conn"),
        on_success_callback=success_callback,
        on_failure_callback=failure_callback
    )
