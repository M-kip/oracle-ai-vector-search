import os
import time
import array
import sys
import getpass

import oracledb
from sentence_transformers import SentenceTransformer
from sentence_transformers import CrossEncoder

un = "c##moses"
cs = "localhost/free"
pw = "mbuyuni_2025" #getpass.getpass(f'Enter password for {un}@{cs}: ')


embedding_model = "sentence-transformers/all-MiniLM-L6-v2"

# topK is how many row to return
topK = 5



query_sql = """select id, info 
         from my_data
         order by 1"""

update_sql = """update my_data set v = :1 
                where id = :2"""

print(f"Using embedding model {embedding_model}")

# instanciate model
model = SentenceTransformer(embedding_model, trust_remote_code=False)

# connect to oracle 23ai
print("connecting to Oracle database...............................")
with oracledb.connect(user=un, password=pw, dsn=cs) as connection:

    db_version = tuple(int(s) for s in connection.version.split("."))[:2]
    if db_version < (23, 4):
        sys.exit("This example only works for oracle db 23.4 or later")
    print("connected to the database...............................")
    with connection.cursor() as cursor:
        print("Vectorizing the following data:\n")

        # loop over the row and vectorize the VARCHAR2 data

        binds = []
        tic = time.perf_counter()

        for id_val, info in cursor.execute(query_sql):
            # Convert the format into string for the sentence transformers
            data = f'[ {info} ]'

            # Create embedding and extract vector
            embedding = list(model.encode(data))

            # Convert to arrary format
            vec2 = array.array("f", embedding)

            # Record the arrary and the key
            binds.append([vec2, id_val])

            print(info)
        toc = time.perf_counter()

        # do an update to add of update the vector values
        cursor.executemany(update_sql, binds)
        # commit to db
        connection.commit()
        print(f"Vectors took {toc - tic:0.3f} seconds")
        print(f"\nadded {len(binds)} vector to the table using ebedding model: {embedding_model} \n")
    