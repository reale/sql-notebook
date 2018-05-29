SELECT object_type,

       avg(length(object_name)) avg_name_length

  FROM dba_objects

 GROUP BY object_type

 ORDER BY avg(length(object_name)) DESC;
