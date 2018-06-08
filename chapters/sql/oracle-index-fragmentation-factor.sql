SELECT tablespace_name AS TABLESPACE,

       count(*) AS free_chunks,

       nvl(max(bytes) / 1048576, 0) AS largest_chunk,

       100 * (1 - nvl(sqrt(max(blocks) / (sqrt(sqrt(count(blocks))) * sum(blocks))), 0)) AS fragmentation

  FROM dba_free_space

 GROUP BY tablespace_name;
