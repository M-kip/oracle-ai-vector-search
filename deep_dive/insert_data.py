import os
import sys
import pprint as pp
import oracledb

un = "c##moses"
cs = "localhost/free"
pw = "mbuyuni_2025" #getpass.getpass(f'Enter password for {un}@{cs}: ')
file_size = "" 
pdf_file_name = "23ai_Release_notes.pdf"
pdf_file_path = f"./{pdf_file_name}"
table_name = 'my_books'
file_type = "PDF"

if not os.path.exists(pdf_file_path):
    raise Exception(f"File does not exist at: {os.path.abspath(pdf_file_path)}")

if os.path.isfile(pdf_file_path):
    with open(pdf_file_path, 'rb') as f:
        file_stats = os.stat(pdf_file_path)
        file_size = file_stats.st_size
        pdf_blob = f.read()
else:
    raise Exception(f"file does not exist {pdf_file_path}")

data = [pdf_file_name, file_size, file_type, pdf_blob] # Data to feed the db my_books table
# connect to oracle 23ai
print("connecting to the database...............................\n")
with oracledb.connect(user=un, password=pw, dsn=cs) as connection:

    db_version = tuple(int(s) for s in connection.version.split("."))[:2]
    if db_version < (23, 4):
        sys.exit("This example only works for oracle db 23.4 or later")
    print("connected to the database...............................") 

    with connection.cursor() as cursor:
        insert_sql = f"""INSERT INTO {table_name} (file_name, file_size, file_type, file_content)
                    VALUES (:1, :2, :3, :4)"""
        print("inserting data to the database...............................")
        cursor.execute(insert_sql, data)
        print("inserted to the database...............................")
        connection.commit()
        pp.pp(f'Data sucessfully written to the db file_name: {pdf_file_name}')

