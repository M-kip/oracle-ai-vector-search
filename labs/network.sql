
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
                    privilege_list => xs$name_list('connect'),
                    principal_name => 'WKSP_DEMO',
                    principal_type => xs_acl.ptype_db
                )
    );
END;
/

select * from dba_network_acls;
select * from dba_network_acl_privileges;