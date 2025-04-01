create table if not exists t6(
    id NUMBER PRIMARY KEY,
    v  vector(3, * ) 
);

truncate table t6;

insert into t6 values 
    (1, '[1.1, 2.7, 7.1415922653589793238]'),
    (2, '[1.2, 2.9, 3.1415922653589793238]'),
    (3, '[1.3, 2.7, 3.1415922653589793238]'),
    (4, '[1.4, 2.7, 3.1415922653589793238]'),
    (5, '[1.9, 2.7, 3.1415922653589793238]'),
    (6, '[1.11, 2.2, 3.1415922653589793238]'),
    (7, '[1.12, 2.9, 3.14]');
    
commit;

select id, v
from t6
order by vector_distance(v, to_vector('[1.1, 2.7, 7.1415922653589793238]'), cosine)
fetch first 5 rows only;

select id, v
from t6
order by vector_distance(v, to_vector('[1.1, 2.7, 7.1415922653589793238]'), manhattan)
fetch first 5 rows only;