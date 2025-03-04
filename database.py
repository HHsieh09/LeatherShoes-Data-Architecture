import os
import sys
from dotenv import load_dotenv, find_dotenv
#pip install python-dotenv
#import cx_Oracle 
import mysql.connector #pip install mysql-connector-python
import redshift_connector #pip install redshift_connector


class RedshiftDB:
  def __init__(self, database='dev'):
    load_dotenv()

    self.host = os.getenv("REDSHIFT_HOST")
    self.user = os.getenv("REDSHIFT_USER")
    self.password = os.getenv("REDSHIFT_PASSWORD")
    self.database = os.getenv("REDSHIFT_DB")
    self.port = os.getenv("REDSHIFT_PORT")

    try:
      self.connection = redshift_connector.connect(
        host =self.host,
        database=self.database,
        port = self.port,
        user = self.user,
        password = self.password,
      )
      self.cursor = self.connection.cursor()
      print("Redshift Connection Successful")
    except Exception as e:
      print("Error: ", e)
      raise

  def execute_query(self, query, params=None):
    try:
      self.cursor.execute(query,params)
      print("Query Executed Successfully")

      if query.strip().split(" ")[0].upper() == "SELECT":
        return self.cursor.fetchall()
      self.connection.commit()
      return None
    except Exception as e:
      print("Error: ", e)
      return None
  
  def __enter__(self):
    return self
  
  def __exit__(self, exc_type, exc_val, exc_tb):
    self.close
    
  def close(self):
    self.cursor.close()
    self.connection.close()
    print("Redshift Connection Close")
      

class MySQLDB:
  def __init__(self, database='leathershoesdb'):
    load_dotenv()

    self.host = os.getenv("MYSQL_HOST")
    self.user = os.getenv("MYSQL_USER")
    self.password = os.getenv("MYSQL_PASSWORD")
    self.database = database

    self.connection = mysql.connector.connect(
      host =self.host,
      user = self.user,
      password = self.password
    )
    self.cursor = self.connection.cursor()

    if self.database:
      self.use_database(self.database)

  def use_database(self, database):
    self.database = database
    self.cursor.execute(f"USE {database}")
  
  def get_connection(self):
    return self.connection

  def get_cursor(self):
    return self.cursor

  def execute_query(self, query, params=None):
    self.cursor.execute(query,params)
    print("Query Executed Successfully")

    if query.strip().split(" ")[0].upper() == "SELECT":
      return self.cursor.fetchall()
    self.connection.commit()
    return None

  def commit(self):
    self.connection.commit()

  def __enter__(self):
    return self
  
  def __exit__(self, exc_type, exc_val, exc_tb):
    self.close

  def close(self):
    self.cursor.close()
    self.connection.close()
    print("MySQL Connection Close")


if __name__ == "__main__":
  db = RedshiftDB()
  query1 = db.execute_query("SELECT * FROM Dim_Color;")
  for i in query1:
    print(i)
