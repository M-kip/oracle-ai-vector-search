import os
import sys
import array
import json
import pprint as pp

import oracledb
from sentence_transformers import SentenceTransformer

un = "c##moses"
cs = "localhost/free"
pw = "mbuyuni_2025" #getpass.getpass(f'Enter password for {un}@{cs}: ')
embedding_model = "sentence-transformers/all-MiniLM-L6-v2" # embedding model/encoder
encoder = SentenceTransformer(embedding_model) # Encoder to handle the vectorization tasks
table_name ='faqs'
topK = 3

def loadFaqs(directory_path):
    faqs = {}
    for filename in os.listdir(os.path.normcase(directory_path)):
        if filename.endswith("faq.txt"): # assuming faqs are in txt files
            file_path = os.path.join(directory_path, filename)
            
            # open the file
            with open(file_path, 'r', encoding='utf-8') as f:
                raw_faq = f.read()
        
            filename_without_ext = os.path.splitext(filename)[0] # remove .txt extension
            faqs[filename_without_ext] = [text.strip() for text in raw_faq.split('=====')]
            # Rearrage the chunks and prepend the name of the file 
            docs = [{'text': f"{filename }' | ' {section}", 'path': filename } for filename, sections in faqs.items() for section in sections]
    return docs

# Load file from system
docs = loadFaqs(r'C:\Users\mose\Documents\machine_learning\oracle-ai-vector-search\files')
pp.pprint(docs[:2])

# connect to oracle 23ai and create table
def connDB(table_name):
    print("\n=============> connecting to Oracle database")
    with oracledb.connect(user=un, password=pw, dsn=cs) as connection:

        db_version = tuple(int(s) for s in connection.version.split("."))[:2]
        if db_version < (23, 4):
            sys.exit("This example only works for oracle db 23.4 or later")
        print("\n=============> connected to the database")
        with connection.cursor() as cursor:
            create_table_sql = f"""
                        CREATE TABLE IF NOT EXISTS {table_name} (
                        id number primary key,
                        payload CLOB CHECK (payload IS JSON),
                        vector VECTOR)"""
            try:
                cursor.execute(create_table_sql)
                print(f"\n=============> {table_name} table created in the database")
            except oracledb.DatabaseError as e:
                raise 
            connection.autocommit = True

# connect to db
connDB(table_name)
connection = oracledb.connect(user=un, password=pw, dsn=cs)


# Define a list to store the data
data = [{"id": idx, "vector_source": row['text'], "payload": row} for idx, row in enumerate(docs)]

# Collect all text for batch encoding
texts = [f"{row['vector_source']}" for row in data]

# Encode all text for batch encoding
print(f"======> encoding text with {embedding_model} encoder\n")
embeddings = encoder.encode(texts, batch_size=32, show_progress_bar=True)

# Assign the embeddings back to your data structure
for row, embedding in zip(data, embeddings):
    row['vector'] = array.array("f", embedding)

with connection.cursor() as cursor:
    # Truncate the table
    cursor.execute(f'truncate table {table_name}')
    prepare_data = [(row['id'], json.dumps(row['payload']), row['vector']) for row in data]

    # insert data into the table faqs
    cursor.executemany(f"INSERT INTO {table_name} (id, payload, vector) VALUES (:1, :2, :3)", prepare_data)

    connection.commit()
    print("=========> Sucessfully persisted the data.")

with connection.cursor() as cursor:
    # Define the query to select all the rows from a table
    query = f'select * from {table_name}'
    # Execute the query
    cursor.execute(query)

    # Fetch all rows
    rows = cursor.fetchall()

    # print the rows
    for row in rows[:2]:
        pp.pprint(row)

# SQL DML to retrive chunks
sql = f"""select payload, vector_distance(vector, :vector, COSINE) as
        score from {table_name}
        order by score
        fetch approx first {topK} rows only"""

# Input your question
question = input("\nState your question:")
with connection.cursor() as cursor:
    embedding = list(encoder.encode(question))
    vector = array.array("f", embedding)

    results = []

    for (info, score, ) in cursor.execute(sql, vector=vector):
        text_content = info.read()
        results.append((score, json.loads(text_content)))
    
    pp.pp(results)