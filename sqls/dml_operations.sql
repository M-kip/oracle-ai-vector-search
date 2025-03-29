drop table if exists t2;

create table if not exists t2 (
    id      number primary key,
    name    varchar2(32),
    v1      vector
);

insert into t2 values 
    ( 1, 'A', '[1.1]' ), 
    ( 2, 'B', '[2.2]' ), 
    ( 3, 'C', '[3.3]' ), 
    ( 4, 'D', '[4.4]' ), 
    ( 5, 'E', '[5.5]' );   

commit;

update t2
   set v1 = '[2.9]'
 where id = 2;
 
commit;