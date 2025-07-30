import json
import os
from airflow import DAG
from airflow.operators.email import EmailOperator
from airflow.utils.dates import days_ago

# Load config
CONFIG_FILE = '/opt/airflow/config/dev/variable.json'

with open(CONFIG_FILE) as f:
    config = json.load(f)

# Get recipient name from email
to_email = config['smtp_to']
name_part = to_email.split('@')[0] 
first_name = name_part.split('.')[0].capitalize()

default_args = {
    'owner': 'airflow',
    'email': [config['smtp_from']],
    'email_on_failure': True,
    'email_on_retry': False
}

# Styled HTML email content
html_content = f"""
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }}
        .email-container {{ background-color: #ffffff; padding: 20px; border-radius: 10px; }}
        .footer {{ font-size: 12px; color: #888888; margin-top: 20px; }}
    </style>
</head>
<body>
    <div class="email-container">
        <h2>Hello {first_name},</h2>
        <p>This is a test email sent from an <strong>Airflow DAG</strong> running in a Docker Compose environment.</p>
        <p>We're testing email functionality using Outlook SMTP configuration.</p>
        <p>Best regards,<br><b>{config['company_name']} Automation Team</b></p>
        <div class="footer">{config['footer_note']}</div>
    </div>
</body>
</html>
"""

with DAG(
    dag_id='send_email_alerts_dag',
    default_args=default_args,
    start_date=days_ago(1),
    schedule_interval='@daily',
    tags=['email', 'alert'],
    description='DAG to send email alerts using Outlook SMTP',
    catchup=False
) as dag:

    email_task = EmailOperator(
        task_id='send_test_email',
        to=to_email,
        subject=config['email_subject'],
        html_content=html_content
    )
