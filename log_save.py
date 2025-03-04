import os
from database import MySQLDB

# Flask Log File Path
LOG_FILE = "/home/ubuntu/Leather-Shoes-Project/flask_app.log"

def store_logs_to_rds():
    if not os.path.exists(LOG_FILE):
        print("Log file not found!")
        return

    with open(LOG_FILE, "r") as file:
        lines = file.readlines()

    if not lines:
        print("No new logs to upload.")
        return

    with MySQLDB() as db:
        for line in lines:
            parts = line.strip().split(" - ", 2)
            if len(parts) == 3:
                log_time, log_level, log_message = parts
                query = "INSERT INTO logs (log_timestamp, log_level, log_message) VALUES (%s, %s, %s)"
                db.execute_query(query, (log_time, log_level, log_message))

    # Clear the log file after storing logs
    open(LOG_FILE, "w").close()
    print("Logs stored in RDS successfully.")

if __name__ == "__main__":
    store_logs_to_rds()