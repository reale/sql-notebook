SELECT tablespace_name,

       OWNER,

       TABLE_NAME,

       num_rows,

       rank() OVER ( PARTITION BY tablespace_name
                    ORDER BY num_rows DESC ) AS rank

  FROM dba_tables

 WHERE num_rows IS NOT NULL

 ORDER BY tablespace_name;
