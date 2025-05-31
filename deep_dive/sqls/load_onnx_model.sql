DECLARE
    -- Define the model file name stored in Object Storage
    ONNX_MOD_FILE VARCHAR2(100) := 'all_MiniLM_L12_v2.onnx';

    -- Variable to store the model name (extracted from the file name)
    MODNAME VARCHAR2(500);

    -- URI to access the Object Storage location of the model
    LOCATION_URI VARCHAR2(200) := 'https://adwc4pm.objectstorage.us-ashburn-1.oci.customer-oci.com/p/eLddQappgBJ7jNi6Guz9m9LOtYe2u8LWY19GfgU8flFK4N9YgP4kTlrE9Px3pE12/n/adwc4pm/b/OML-Resources/o/';
BEGIN
    BEGIN
        -- Output the model file name from Object Storage
        DBMS_OUTPUT.PUT_LINE('ONNX model file name in Object Storage is: ' || ONNX_MOD_FILE);
        
        -- Extract the model name (everything before the first dot in the file name) and convert it to uppercase
        SELECT UPPER(REGEXP_SUBSTR(ONNX_MOD_FILE, '[^.]+')) INTO MODNAME FROM dual;
        
        -- Output the derived model name which will be used to load the model into the database
        DBMS_OUTPUT.PUT_LINE('Model will be loaded and saved with name: ' || MODNAME);

        -- Attempt to drop the existing model if it exists
        BEGIN
            DBMS_DATA_MINING.DROP_MODEL(model_name => MODNAME);  -- Drop the model using its name
        EXCEPTION WHEN OTHERS THEN
            -- In case of any error during dropping the model (e.g., model doesn't exist), log the error message
            DBMS_OUTPUT.PUT_LINE('Error dropping model: ' || SQLERRM);
        END;

        -- Attempt to download the ONNX model file from Object Storage to the local Data Pump directory
        --BEGIN
            --DBMS_CLOUD.GET_OBJECT(
                --credential_name => NULL,  -- Assuming credentials are handled elsewhere
                --directory_name => 'DATA_PUMP_DIR',  -- Directory to store the model file in the database
                --object_uri => LOCATION_URI || ONNX_MOD_FILE  -- Complete Object Storage URI for the model
            --);
        --EXCEPTION WHEN OTHERS THEN
            -- In case of any error during the download (e.g., file not found), log the error message
            --DBMS_OUTPUT.PUT_LINE('Error downloading model from Object Storage: ' || SQLERRM);
        --END;

        -- Attempt to load the ONNX model into the database
        BEGIN
            DBMS_VECTOR.LOAD_ONNX_MODEL(
                directory => 'DATA_PUMP_DIR',  -- Directory where the model is located
                file_name => ONNX_MOD_FILE,  -- The model file name
                model_name => MODNAME  -- The model name that will be saved in the database
            );
            -- Output a success message if the model is loaded successfully
            DBMS_OUTPUT.PUT_LINE('New model successfully loaded with name: ' || MODNAME);
        EXCEPTION WHEN OTHERS THEN
            -- In case of any error during loading the model (e.g., wrong format), log the error message
            DBMS_OUTPUT.PUT_LINE('Error loading model into database: ' || SQLERRM);
        END;
    EXCEPTION
        -- Catch any unexpected errors that occur during the entire block execution
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
    END;
END;
/

-----------------------------------------------------------
--Validate that the model was imported to the database.
-----------------------------------------------------------
select model_name, algorithm, mining_function from user_mining_models where  model_name='ALL_MINILM_L12_V2';