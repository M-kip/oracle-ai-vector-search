DECLARE
  l_model_name VARCHAR2(100);
  l_blob       BLOB;
  l_bfile      BFILE;
  l_dest_file  UTL_FILE.FILE_TYPE;
  l_buffer     RAW(32767);
  l_amount     BINARY_INTEGER := 32767;
  l_pos        INTEGER := 1;
  l_blob_len   INTEGER;
BEGIN
  -- Step 1: Select the model from your table
  SELECT model_name, model_data
  INTO   l_model_name, l_blob
  FROM   C##MOSES.onnx_models
  WHERE  model_name = 'ALL_MINILM_L12_V2';

  -- Step 2: Determine blob length
  l_blob_len := DBMS_LOB.getlength(l_blob);

  -- Step 3: Open a writable file in DATA_PUMP_DIR
  l_dest_file := UTL_FILE.fopen('DATA_PUMP_DIR', 'ALL_MINILM_L12_V2.onnx', 'wb', 32767);

  -- Step 4: Write BLOB to the file in chunks
  WHILE l_pos <= l_blob_len LOOP
    DBMS_LOB.read(l_blob, l_amount, l_pos, l_buffer);
    UTL_FILE.put_raw(l_dest_file, l_buffer, TRUE);
    l_pos := l_pos + l_amount;
  END LOOP;

  -- Step 5: Close the file
  UTL_FILE.fclose(l_dest_file);

  DBMS_OUTPUT.PUT_LINE('BLOB written to file successfully.');

  -- Step 6: Load model from file into Oracle ML
  DBMS_VECTOR.LOAD_ONNX_MODEL(
    model_name => 'ALL_MINILM_L12_V2',
    file_name  => 'ALL_MINILM_L12_V2.onnx',
    directory  => 'DATA_PUMP_DIR'
  );

  DBMS_OUTPUT.PUT_LINE('Model successfully loaded into Oracle ML.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
---------------------------------------------
-- Was checking if i have all the right perms 
---------------------------------------------
BEGIN
  -- Step 6: Load model from file into Oracle ML
  DBMS_VECTOR.LOAD_ONNX_MODEL(
    model_name => 'ALL_MINILM_L12_V2',
    file_name  => 'ALL_MINILM_L12_V2.onnx',
    directory  => 'DATA_PUMP_DIR'
  );
END;
/
-----------------------------------------------------------
--Validate that the model was imported to the database.
-----------------------------------------------------------
select model_name, algorithm, mining_function from user_mining_models where  model_name='ALL_MINILM_L12_V2';