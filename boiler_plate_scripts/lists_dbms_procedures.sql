SELECT procedure_name
FROM all_procedures
WHERE object_name = 'DBMS_VECTOR';

SELECT model_name, mining_function, algorithm, algorithm_type, ROUND(MODEL_SIZE/1024/1024) MB
FROM user_mining_models
WHERE model_name = 'ALL_MINILM_L12_V2';

----------------------
-- show errors
----------------------
SET SERVEROUTPUT ON
