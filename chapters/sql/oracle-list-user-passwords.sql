SELECT username,

       extract( xmltype( dbms_metadata.get_xml('USER', username)), '//USER_T/PASSWORD/text()' ).getstringval() AS password_hash

  FROM dba_users;
