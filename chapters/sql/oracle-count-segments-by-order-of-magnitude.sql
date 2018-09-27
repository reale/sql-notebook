### COUNT number OF segments

   FOR EACH

 ORDER OF magnitude * keywords*: decode
FUNCTION,

       analytic functions iec prefixes ARE used.
SELECT decode( trunc(log(1024, bytes)), -- 0, 'bytes',
 1, 'KiB', 2, 'MiB', 3, 'GiB', 4, 'TiB', 5, 'PiB', 6, 'EiB', 7, 'ZiB', 8, 'YiB', 'UNKNOWN') AS order_of_magnitude,

       count(*) COUNT

  FROM dba_segments

 GROUP BY trunc(log(1024, bytes))

 ORDER BY trunc(log(1024, bytes));
