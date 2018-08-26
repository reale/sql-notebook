SELECT n

  FROM dual

 WHERE 1 = 2 model dimension BY (0 AS KEY) measures (0 AS n) rules upsert ( n [for key from -100 to 100 increment 2] = cv(KEY) );
