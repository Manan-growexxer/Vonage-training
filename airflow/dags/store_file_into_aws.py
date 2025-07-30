from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from botocore.exceptions import NoCredentialsError
import logging
import json
import os
import boto3

# Import callbacks from email alert DAG
from emali_alert_on_success_failure import success_callback, failure_callback, default_args

# Load config
CONFIG_FILE = '/opt/airflow/config/dev/variable.json'
with open(CONFIG_FILE) as f:
    config = json.load(f)

# AWS credentials from config
def get_aws_credentials():
    return config["aws_access_key_id"], config["aws_secret_access_key"], config["bucket_name"]

# S3 Upload logic
def upload_to_s3():
    aws_access_key_id, aws_secret_access_key, bucket_name = get_aws_credentials()

    session = boto3.session.Session(
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key
    )

    s3_client = session.client('s3')
    object_name = 'Titanic-Dataset.csv'
    local_file_path = '/opt/airflow/scripts/Titanic-Dataset.csv'

    try:
        s3_client.upload_file(local_file_path, bucket_name, object_name)
        logging.info(f"File uploaded to s3://{bucket_name}/{object_name}")
    except Exception as e:
        logging.error("AWS credentials not found or invalid")
        raise e



# Define DAG
with DAG(
    dag_id='Titanic_dataset_file_upload_to_s3_dag',
    start_date=days_ago(1),
    schedule_interval="@daily",
    tags=['s3', 'upload', 'file'],
    catchup=False,
    description="Upload local file to S3 using boto3 and variable.json",
    default_args=default_args,
    
) as dag:

    upload_task = PythonOperator(
        task_id='upload_sql_to_s3',
        python_callable=upload_to_s3,
        on_success_callback=success_callback,
        on_failure_callback=failure_callback
    )
