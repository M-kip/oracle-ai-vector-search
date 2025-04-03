--BEGIN
--    DBMS_CLOUD.DROP_CREDENTIAL(
--      CREDENTIAL_NAME => 'GEMINI_AI'
--    );
--END;
--/

BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
      CREDENTIAL_NAME => 'RAG_CRED',
      USERNAME        => 'your_OCI_user',
      PASSWORD        => 'your_OCI_token' -- AUTH TOKEN
    );
END;
/

DECLARE
    JO JSON_OBJECT_T;
BEGIN
    JO := JSON_OBJECT_T();
    JO.PUT('access_token', 'your_GOOGLE_token');
    
    DBMS_VECTOR_CHAIN.CREATE_CREDENTIAL(
        CREDENTIAL_NAME => 'GEMINI_AI',
        PARAMS => JSON(JO.TO_STRING)
    );
END;
/


SELECT * FROM USER_CREDENTIALS;

SELECT * FROM DBMS_CLOUD.LIST_OBJECTS('RAG_CRED','https://objectstorage.eu-milan-1.oraclecloud.com/n/axdalps0xbe2/b/onnx-models/o');