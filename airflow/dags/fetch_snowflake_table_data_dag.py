import logging
import json
from jinja2 import Template
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook

def get_env_variables():
    path = '/opt/airflow/config/dev/variable.json'
    with open(path) as f:
        data = json.load(f)
    return {
        "env": data.get("env", "dev"),
        "database": data.get("database", "DEV_DB"),
        "schema": data.get("schema", "DEV_SCHEMA")
    }

def get_sql(file_path, context):
    with open(file_path, 'r') as f:
        template = Template(f.read())
        return template.render(context)

def print_top_employees_from_file():
    logger = logging.getLogger("airflow.task")

    context = get_env_variables()
    sql_file = '/opt/airflow/scripts/query.sql'
    query = get_sql(sql_file, context)

    hook = SnowflakeHook(snowflake_conn_id='snowflake_dev_conn')
    df = hook.get_pandas_df(query)

    logger.info("Top 5 Employee Records:")
    logger.info(df.to_string(index=False))

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
}

with DAG(
    dag_id='top_5_employees_to_temp_logs',
    default_args=default_args,
    schedule_interval='@daily',
    catchup=False,
    description='Logs top 5 employees from Snowflake using variables',
) as dag:

    print_top_5 = PythonOperator(
        task_id='print_top_5_employees',
        python_callable=print_top_employees_from_file
    )

    print_top_5
