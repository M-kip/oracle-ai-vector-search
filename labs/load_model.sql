BEGIN
    DBMS_VECTOR.LOAD_ONNX_MODEL_CLOUD(
        model_name => 'ALL_MINILM_L12_V2',
        credential => 'RAG_CRED',
        uri        => 'https://axdalps0xbe2.objectstorage.eu-milan-1.oci.customer-oci.com/n/axdalps0xbe2/b/onnx-models/o/all_MiniLM_L12_v2.onnx',
        metadata   => JSON('{"function" : "embedding", "embeddingOutput" : "embedding" , "input": {"input": ["DATA"]}}')
    );
END;
/
select * from user_mining_models where model_name = 'ALL_MINILM_L12_V2';

select VECTOR_EMBEDDING(ALL_MINILM_L12_V2 using 'The quick brown fox jumped' as DATA) as embedding;
