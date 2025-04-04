SELECT
    embed_data
FROM
    rag_vectors
WHERE
    file_id = 1
ORDER BY
    vector_distance(
        embed_vector, 
        to_vector(vector_embedding(ALL_MINILM_L12_V2 using 'What does the book say passive investing vs. active investing?' as data)), 
        cosine
    )
FETCH FIRST 5 ROWS ONLY;