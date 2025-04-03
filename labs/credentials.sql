BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
      CREDENTIAL_NAME => 'RAG_CRED',
      USERNAME        => 'your_OCI_user',
      PASSWORD        => 'your_OCI_token' -- AUTH TOKEN
    );
END;
/

SELECT * FROM USER_CREDENTIALS;

SELECT * FROM DBMS_CLOUD.LIST_OBJECTS('RAG_CRED','https://objectstorage.eu-milan-1.oraclecloud.com/n/axdalps0xbe2/b/onnx-models/o');