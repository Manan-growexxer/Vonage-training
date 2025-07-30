from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import requests
import json
import os
from airflow.utils.log.logging_mixin import LoggingMixin

# Load JSON config
BASE_DIR = os.path.dirname(os.path.dirname(__file__))  # Goes up from /dags to project root
VAR_FILE = os.path.join(BASE_DIR, 'config', 'dev', 'variable.json')

with open(VAR_FILE) as f:
    config = json.load(f)

API_KEY = config['API_KEY']
CITY = config['CITY']

def fetch_weather():
    logger = LoggingMixin().log

    url = f"http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}&units=metric"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        logger.info(f"City: {CITY}")
        logger.info(f"Temperature: {data['main']['temp']} °C")
        logger.info(f"Weather: {data['weather'][0]['description']}")
    else:
        logger.error("Failed to fetch data: %s", response.text)

with DAG(
    dag_id="Open_weather_api_to_temp_logs",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=["weather", "api"],
) as dag:

    fetch_weather_task = PythonOperator(
        task_id="fetch_weather",
        python_callable=fetch_weather
    )
