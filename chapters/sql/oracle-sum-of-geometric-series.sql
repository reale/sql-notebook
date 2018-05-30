SELECT sum(power(2, - LEVEL)) SUM

  FROM dual
CONNECT BY LEVEL < & n;
