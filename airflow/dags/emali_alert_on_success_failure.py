
import json
import os
from airflow import DAG
from airflow.operators.email import EmailOperator
from airflow.utils.dates import days_ago
from airflow.utils.email import send_email

# Load config
CONFIG_FILE = '/opt/airflow/config/dev/variable.json'

with open(CONFIG_FILE) as f:
    config = json.load(f)

to_email = config['smtp_to']
to_cc = config['smtp_cc']
name_part = to_email.split('@')[0]
first_name = name_part.split('.')[0].capitalize()

# ----------------------
# Success/Failure Callbacks
# ----------------------
default_args = {
    'owner': 'airflow',
    'email': [config['smtp_from']],
    'email_on_failure': False,
    'email_on_retry': False,
    'email_on_success': False,
}
def success_callback(context):
   
    subject = f"DAG Success: {context['dag'].dag_id}"
    html_content = f"""
    <h3>Hello {first_name},</h3>
    <p>Your DAG <strong>{context['dag'].dag_id}</strong> succeeded at <b>{context['execution_date']}</b>.</p>
    <p>Regards,<br>{config['company_name']} Automation Team</p>
    """
    send_email(to=to_email, subject=subject, html_content=html_content,cc=to_cc)

def failure_callback(context):
    
    subject = f"DAG Failed: {context['dag'].dag_id}"
    html_content = f"""
    <h3>Hello {first_name},</h3>
    <p>Your DAG <strong>{context['dag'].dag_id}</strong> failed at <b>{context['execution_date']}</b>.</p>
    <p>Error: {context['exception']}</p>
    <p>Regards,<br>{config['company_name']} Automation Team</p>
    """
    send_email(to=to_email, subject=subject, html_content=html_content,cc=to_cc)

