SELECT * FROM DBMS_CLOUD.LIST_OBJECTS('OCI', '<uri_path>');

SELECT * FROM USER_MINING_MODELS;

BEGIN
    DBMS_VECTOR.LOAD_ONNX_MODEL_CLOUD(
        CREDENTIAL => 'OCI',
        MODEL_NAME => 'ALL_MINILM_L12_V2',
        URI        => '<uri_path>/all_MiniLM_L12_v2.onnx',
        METADATA   => JSON('{"function" : "embedding", "embeddingOutput" : "embedding" , "input": {"input": ["DATA"]}}')
    );
END;
/

-- TEST MODEL
select VECTOR_EMBEDDING(ALL_MINILM_L12_V2 using 'The quick brown fox jumped' as DATA);
