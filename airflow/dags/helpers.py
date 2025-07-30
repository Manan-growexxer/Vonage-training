import logging
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from jinja2 import Template

def get_sql(file_path, context=None):
    with open(file_path, 'r') as f:
        template = Template(f.read())
        return template.render(context or {})

def run_snowflake_query(query_file):
    def _inner():
        logger = logging.getLogger("airflow.task")
        query = get_sql(query_file)
        hook = SnowflakeHook(snowflake_conn_id="snowflake_dev_conn")
        df = hook.get_pandas_df(query)
        logger.info(df.to_string(index=False))
    return _inner
