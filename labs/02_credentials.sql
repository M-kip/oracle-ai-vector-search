SELECT * FROM USER_CREDENTIALS;

BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
      CREDENTIAL_NAME => 'OCI',
      USERNAME        => 'angelo.stramieri@gmail.com',
      PASSWORD        => '<auth_token>' -- REPLACE
    );
END;
/

DECLARE
    V_OBJECT JSON_OBJECT_T := JSON_OBJECT_T();
BEGIN
    V_OBJECT.PUT('access_token', '<auth_token>');
    
    DBMS_VECTOR_CHAIN.CREATE_CREDENTIAL(
        CREDENTIAL_NAME => 'OPENAI',
        PARAMS          => JSON(V_OBJECT.TO_STRING)
    );
END;
/
