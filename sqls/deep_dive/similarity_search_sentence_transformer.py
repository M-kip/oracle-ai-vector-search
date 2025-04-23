import os
import time
import array
import sys
import getpass

import oracledb
from sentence_transformers import SentenceTransformer
from sentence_transformers import CrossEncoder

un = "moses"
cs = "localhost/orclcdb"
pw = "mbuyuni2025" #getpass.getpass(f'Enter password for {un}@{cs}: ')


embedding_model = "sentence-transformers/all-MiniLM-L6-v2"

# topK is how many row to return
topK = 5

#  Re-racking is about potentially improving the order of the result
# Re-racking is significantly slower than doinga similarity search
rerank = 0

sql = """select info 
         from my_data
         order by vector_distance(v, :1, COSINE)
         fetch first :2 rows only"""

rerank_model = "cross-encoder/ms-marco-TinyBERT-L-2-v2"

print(f"Using embedding model {embedding_model}")
if rerank:
    print(f'Using reranker {rerank_model}')

print(f'TopK - {str(topK)}')

# instanciate model
model = SentenceTransformer(embedding_model, trust_remote_code=False)

# connect to oracle 23ai
print("connecting to the database...............................")
with oracledb.connect(user=un, password=pw, dsn=cs) as connection:

    db_version = tuple(int(s) for s in connection.db_version.split("."))[:2]
    if db_version < (23, 4):
        sys.exit("This example only works for oracle db 23.4 or later")
    print("connected to the database...............................")
    with connection.cursor() as cursor:

        while True:
            # Get the input from the user to vectorize
            text = input("\nEnter a phrase. Type quit to exist: ")
            if (text == 'quit') or (text == 'exit'):
                break

            if text == "":
                continue
            tic = time.perf_counter()

            # Create the embedding and extract the vector
            embedding = list(model.encode(text))

            toc = time.perf_counter()
            print(f'\nVectorize query took {toc - tic:0.3f} seconds')

            # convert

            vec = array.array("f", embedding)

            docs = []
            cross = []

            tic = time.perf_counter()

            # Do the Similarity Search
            for (info, ) in cursor.execute(sql, [vec, topK]):
                # Remember the SQL data result
                docs.append(info)

                if rerank:
                    # create the query/data pair need for cross encoding
                    tup = []
                    tup.append(text)
                    tup.append(info)
                    cross.append(tup)
            print(f'Similarity Search took {toc - tic:0.4f} seconds')

            if rerank:
                # Just rely on the vector distance for thr result order
                print("\nWithout Re-Ranking")
                print("=====================================")
                for hit in docs:
                    print(hit)
            else:
                tic = time.perf_counter()

                # Re-Rank for better results
                ce = CrossEncoder(rerank_model, max_length=512)
                ce_scores = ce.predict(cross)

                toc = time.perf_counter()
                print(f'Re-rank took {toc - tic:0.3f} seconds')

                # Create the unranked list of ce_scores + data
                unranked = []
                for idx in range(topK):
                    tup2 = []
                    tup2.append(ce_scores[idx])
                    tup2.append(docs[idx])
                    unranked.append(tup2)
                
                # Create the reranked list by sorting the unranked list
                reranked = sorted(unranked , key=lambda foo: foo[0], reverse=True)
                print("\nRe-ranked results:")
                print("====================================")
                for idex in range(topK):
                    x = reranked[idx]
                    print(x[1])
            print("-------------------------------------------")