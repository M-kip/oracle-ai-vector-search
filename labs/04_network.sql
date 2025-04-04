-------------
-- "ADMIN" --
-------------

SELECT * FROM DBA_NETWORK_ACLS;

BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
                    principal_name => 'WKSP_RAG',
                    privilege_list => xs$name_list('connect'),
                    principal_type => xs_acl.ptype_db
                )
    );
END;
/



select * from dba_network_acls;
select * from dba_network_acl_privileges;