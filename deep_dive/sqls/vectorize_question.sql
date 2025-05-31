WITH query_vector AS (
    SELECT VECTOR_EMBEDDING(ALL_MINILM_L12_V2 USING 'list some limitations' AS data) AS embedding)
SELECT embed_id, embed_data 
FROM vector_store, query_vector
ORDER BY VECTOR_DISTANCE(EMBED_VECTOR, query_vector.embedding, COSINE)
FETCH APPROX FIRST 4 ROWS ONLY;