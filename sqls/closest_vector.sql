CREATE TABLE IF NOT EXISTS t7 (
    ID   NUMBER PRIMARY KEY , 
    V    vector(2, float32) -- create a vector with 2 dimensions of the type float 32bytes
); 

INSERT INTO t7  
     VALUES (1, '[3, 3]'), (2, '[5, 3]'), (3, '[7, 3]'), 
            (4, '[3, 5]'), (5, '[5, 5]'), (6, '[7, 5]'), 
            (7, '[3, 7]'), (8, '[5, 7]'), (9, '[7, 7]');  
            
COMMIT;

SELECT ID
FROM t7
ORDER BY vector_distance(to_vector('[5, 0]'), V, euclidean)
FETCH FIRST 3 ROWS ONLY;
