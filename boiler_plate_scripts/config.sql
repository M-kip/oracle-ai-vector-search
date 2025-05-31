DECLARE
  user VARCHAR2(100) :=C##MOSES;
BEGIN
--------------------------------
-- GRANT privilages to user
----------------------------------
GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO user;
GRANT READ ON DIRECTORY DATA_PUMP_DIR TO C##MOSES;
-----------------------------------------
-- Execution privilages for dbms_vector
-----------------------------------------
GRANT EXECUTE ON DBMS_VECTOR TO C##MOSES;

-----------------------------------------
-- Grant execution privilages to user
----------------------------------------
GRANT CREATE ANY CONTEXT TO C##MOSES;
GRANT CREATE ANY DIRECTORY TO C##MOSES;

------------------------------
-- Verify user name
------------------------------
SELECT USER FROM dual;

------------------------------
-- Grant model privilages 
-------------------------------
GRANT CREATE MODEL TO C##MOSES;
GRANT DROP MODEL TO C##MOSES;

-----------------------------
-- Grant Machine Learning
-----------------------------
GRANT MLUSER TO C##MOSES;
--------------------------------------
-- Even with EXECUTE ON DBMS_VECTOR, Oracle 23c Free (or other editions) 
-- may still require extra internal roles or system privileges to:
--Load ONNX models
---------------------------------------------------------------------

GRANT CREATE ANY CONTEXT TO C##MOSES;
GRANT CREATE JOB TO C##MOSES;
GRANT CREATE EXTERNAL JOB TO C##MOSES;
GRANT CREATE MINING MODEL TO C##MOSES;
GRANT EXECUTE ON DBMS_VECTOR TO C##MOSES;
GRANT EXECUTE ON DBMS_DATA_MINING TO C##MOSES;
