INSERT INTO RAG_VECTORS (FILE_ID, EMBED_ID, EMBED_DATA, EMBED_VECTOR)
SELECT B.FILE_ID, E.EMBED_ID, E.EMBED_DATA, E.EMBED_VECTOR
FROM RAG_BOOKS B
CROSS JOIN TABLE (
    DBMS_VECTOR_CHAIN.UTL_TO_EMBEDDINGS(
        DBMS_VECTOR_CHAIN.UTL_TO_CHUNKS(
            DBMS_VECTOR_CHAIN.UTL_TO_TEXT(B.FILE_CONTENT),
            JSON('{"by":"words","max":"300","split":"sentence","normalize":"all"}')
        ),
        JSON('{"provider":"database","model":"ALL_MINILM_L12_V2"}')
    ) 
) T
CROSS JOIN JSON_TABLE(
    T.column_value,
    '$[*]' COLUMNS (
        EMBED_ID NUMBER PATH '$.embed_id',
        embed_data VARCHAR2(4000) PATH '$.embed_data',
        EMBED_VECTOR CLOB PATH '$.embed_vector'
    )
) E
WHERE B.FILE_ID = 1;