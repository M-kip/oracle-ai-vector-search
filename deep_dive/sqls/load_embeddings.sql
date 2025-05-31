INSERT INTO vector_store ("DOC_ID", "EMBED_ID", "EMBED_DATA", "EMBED_VECTOR")
SELECT id, embed_id, text_chunk, embed_vector
FROM my_books dt
CROSS JOIN TABLE (dbms_vector_chain.utl_to_embeddings(
    dbms_vector_chain.utl_to_chunks(dbms_vector_chain.utl_to_text(dt.file_content),
    JSON('{"by":"words",
    "max":"300",
    "overlap":"0",
    "split":"sentence",
    "language":"american",
    "normalize":"all"}')),
    JSON('{"provider": "database",
    "model": "ALL_MINILM_L12_V2"}'))) t
CROSS JOIN JSON_TABLE(t.column_value, '$[*]' COLUMNS(
    embed_id NUMBER PATH '$.embed_id',
    text_chunk VARCHAR2(4000) PATH '$.embed_data',
    embed_vector CLOB PATH '$.embed_vector'
)) AS et;