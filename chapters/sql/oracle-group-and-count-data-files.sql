WITH df AS

        ( SELECT tablespace_name,

               regexp_replace(file_name, '/[^/]+$', '') dirname,

               regexp_substr (file_name, '/[^/]+$') basename

          FROM dba_data_files
       )
SELECT tablespace_name,

       dirname path,

       count(basename) file_count

  FROM df

 GROUP BY cube(tablespace_name, dirname)

 ORDER BY tablespace_name,

          dirname;
