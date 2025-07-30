import os
import json
from airflow.models import Connection
from airflow import settings
from sqlalchemy.orm import Session

def get_env_from_variable_file():
    var_file_path = "/opt/airflow/config/dev/variable.json"
    if not os.path.exists(var_file_path):
        raise FileNotFoundError(f"[ERROR] Variable file not found: {var_file_path}")
    with open(var_file_path) as f:
        try:
            data = json.load(f)
            env = data.get("env", "dev")
            print(f"[INFO] Environment set to '{env}' from variable.json")
            return env
        except Exception as e:
            raise ValueError(f"[ERROR] Failed to parse variable.json: {e}")

def load_connections(env):
    path = f"/opt/airflow/config/{env}/connection.json"
    print(f"[INFO] Looking for connection file at: {path}")

    if not os.path.exists(path):
        raise FileNotFoundError(f"[ERROR] Connection file not found: {path}")

    with open(path) as f:
        try:
            connections = json.load(f)
            print(f"[INFO] Loaded {len(connections)} connection(s)")
        except Exception as e:
            print(f"[ERROR] Failed to parse JSON: {e}")
            return

    session: Session = settings.Session()

    for conn_data in connections:
        print(f"[DEBUG] Raw connection config: {conn_data}")
        conn_id = conn_data.pop("conn_id")
        conn_type = conn_data.pop("conn_type")
        extra = conn_data.pop("extra", {})

        # Only allow valid keys for Connection()
        allowed_keys = {"host", "login", "password", "schema", "port"}
        clean_conn_data = {k: conn_data[k] for k in conn_data if k in allowed_keys}

        conn = Connection(
            conn_id=conn_id,
            conn_type=conn_type,
            extra=json.dumps(extra),
            **clean_conn_data
        )

        existing = session.query(Connection).filter(Connection.conn_id == conn_id).first()
        if existing:
            print(f"[INFO] Connection '{conn_id}' already exists. Skipping.")
        else:
            session.add(conn)
            print(f"[SUCCESS] Added connection '{conn_id}'")

    session.commit()
    print("[DONE] Connection loading complete.")

if __name__ == "__main__":
    env = get_env_from_variable_file()
    load_connections(env)
