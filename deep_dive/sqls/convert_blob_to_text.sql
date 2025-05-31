SELECT id, SUBSTR(REPLACE(REPLACE(TRIM(
    dbms_vector_chain.utl_to_text(dt.file_content)), ' ',' '),
    CHR(10), ''), 1, 2000) Content
    FROM my_books dt;

SELECT ct.*
FROM my_books dt,
    dbms_vector_chain.utl_to_chunks(
        dbms_vector_chain.utl_to_text(dt.file_content)) ct
WHERE ROWNUM < 4;

SELECT
JSON_VALUE(C.column_value, '$.chunk_id'
    RETURNING NUMBER) as id,
JSON_VALUE(C.column_value, '$.chunk_offset'
    RETURNING NUMBER) as pos,
JSON_VALUE(C.column_value, '$.chunk_length'
    RETURNING NUMBER) as chunk_length,
SUBSTR( REPLACE (REPLACE(TRIM(JSON_VALUE(C.column_value, '$.chunk_data')), ' ',' '),
CHR(10), ''), 1, 2000) AS chunk_txt
FROM my_books dt,
    dbms_vector_chain.utl_to_chunks(
        dbms_vector_chain.utl_to_text(dt.file_content)) C
WHERE ROWNUM < 4;

SELECT
JSON_VALUE(C.column_value, '$.chunk_id'
    RETURNING NUMBER) as id,
JSON_VALUE(C.column_value, '$.chunk_offset'
    RETURNING NUMBER) as pos,
JSON_VALUE(C.column_value, '$.chunk_length'
    RETURNING NUMBER) as chunk_length,
SUBSTR(REPLACE (REPLACE(TRIM(JSON_VALUE(C.column_value, '$.chunk_data')), ' ',' '),
CHR(10), ''), 1, 2000) AS chunk_txt
FROM my_books dt,
    dbms_vector_chain.utl_to_chunks(
        dbms_vector_chain.utl_to_text(dt.file_content), 
        JSON('{"by":"words",
        "max":"300","overlap":"0",
        "split":"recursively",
        "language":"american",
        "normalize":"all"}')) C
WHERE ROWNUM < 4;