SELECT file_name, file_size, text_chunk, embed_vector
FROM my_books dt
CROSS JOIN TABLE (
    DBMS_VECTOR_CHAIN.utl_to_embeddings(
        DBMS_VECTOR_CHAIN.utl_to_chunks(
            DBMS_VECTOR_CHAIN.utl_to_text(dt.file_content),
            JSON('{"by": "words",
            "max":"300",
            "overlap":"0",
            "split":"sentence",
            "language":"american",
            "normalize":"all"}')), -- to_chunks_end
            JSON('{"provider": "database",
            "model": "ALL_MINILM_L12_V2"}')
        ) -- embeddings end
) t
CROSS JOIN JSON_TABLE(t.column_value, '$[*]' COLUMNS(
    embed_id NUMBER PATH '$.embed_id',
    text_chunk VARCHAR2(4000) PATH '$.embed_data',
    embed_vector CLOB PATH '$.embed_vector'
)) AS et WHERE ROWNUM < 2;