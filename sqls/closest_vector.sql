create table if not exists t7 (
    id   number primary key , 
    v    vector(2, float32)
); 

insert into t7  
     values (1, '[3, 3]'), (2, '[5, 3]'), (3, '[7, 3]'), 
            (4, '[3, 5]'), (5, '[5, 5]'), (6, '[7, 5]'), 
            (7, '[3, 7]'), (8, '[5, 7]'), (9, '[7, 7]');  
            
commit;

select id
from t7
order by vector_distance(to_vector('[5, 5]'), v, euclidean)
fetch first 3 rows only;