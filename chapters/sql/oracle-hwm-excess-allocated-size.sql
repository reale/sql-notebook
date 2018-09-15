WITH pars AS

        ( -- block size in MiB
 SELECT to_number(value) / 1024 / 1024 AS block_size_mib

          FROM -- no need to use gv$parameter here
 v$parameter

         WHERE name = 'db_block_size'
       )
SELECT file_name,

       blocks * pars.block_size_mib AS file_size,

       nvl(hwm, 1) * pars.block_size_mib AS high_water_mark,

       (blocks - nvl(hwm, 1)) * pars.block_size_mib AS excess

  FROM pars,

       dba_data_files df

  JOIN

        ( SELECT file_id,

               max(block_id + blocks - 1) AS hwm

          FROM dba_extents

         GROUP BY file_id
       ) ext USING (file_id);
