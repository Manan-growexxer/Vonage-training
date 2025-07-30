
import os
import json
import logging
from jinja2 import Template
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.utils.dates import days_ago

def get_env_variables():
    with open('/opt/airflow/config/dev/variable.json') as f:
        data = json.load(f)
    return {
        "database": data["database"],
        "schema": data["schema"],
        "project_table": data["project_table"],
        "attendance_table": data["attendance_table"],
        "employee_table": data["employee_table"]
    }

def get_rendered_sql(file_path, context):
    with open(file_path) as f:
        return Template(f.read()).render(context)

def execute_sql_task(file_path, conn_id):
    def _execute():
        logger = logging.getLogger("airflow.task")
        context = get_env_variables()
        query = get_rendered_sql(file_path, context)
        hook = SnowflakeHook(snowflake_conn_id=conn_id)

        queries = [q.strip() for q in query.split(";") if q.strip()]
        logger.info(f"Executing {len(queries)} queries...")

        for i, q in enumerate(queries, 1):
            logger.info(f"\n Query {i}:\n{q}")
            if q.lower().startswith("select"):
                df = hook.get_pandas_df(q)
                logger.info(f" Result:\n{df.to_string(index=False)}")
            else:
                hook.run(q)
                logger.info(f" Query {i} executed.")
    return _execute
