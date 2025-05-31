import os
import sys
import pprint as pp
import oracledb

un = "c##moses"
cs = "localhost/free"
pw = "mbuyuni_2025" #getpass.getpass(f'Enter password for {un}@{cs}: ')
file_size = "" 
model_path = "./models/all_MiniLM_L12_v2.onnx"
model_name = "ALL_MINILM_L12_V2"
table_name = 'onnx_models'
file_type = "model"
model_blob = ""

if not os.path.exists(model_path):
    raise Exception(f"File does not exist at: {os.path.abspath(model_path)}")

if os.path.isfile(model_path):
    with open(model_path, 'rb') as f:
        file_stats = os.stat(model_path)
        file_size = file_stats.st_size
        model_blob = f.read()
        pp.pp(f'successfuly load the {file_type}: {model_name}: size: {file_size} to the database\n')
else:
    raise Exception(f"file does not exist {model_path}")

data = [model_name, model_blob] # model and metadata to feed the table table
# connect to oracle 23ai
print("connecting to the database...............................\n")
with oracledb.connect(user=un, password=pw, dsn=cs) as connection:

    db_version = tuple(int(s) for s in connection.version.split("."))[:2]
    if db_version < (23, 4):
        sys.exit("This example only works for oracle db 23.4 or later")
    print("connected to the database...............................") 

    with connection.cursor() as cursor:
        insert_sql = f"""INSERT INTO {table_name} (model_name, model_data)
                    VALUES (:1, :2)"""
        print("inserting data to the database...............................")
        cursor.execute(insert_sql, data)
        print("inserted to the database...............................")
        connection.commit()
        pp.pp(f'Data sucessfully written to the db file_name: {model_name}')