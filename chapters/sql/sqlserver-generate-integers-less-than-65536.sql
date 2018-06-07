WITH e1(n) AS

        (SELECT 1

     UNION ALL SELECT 1
       ), --2 rows
 e2(n) AS

        (SELECT 1

          FROM e1 a,

               e1 b
       ), --4 rows
 e4(n) AS

        (SELECT 1

          FROM e2 a,

               e2 b
       ), --16 rows
 e8(n) AS

        (SELECT 1

          FROM e4 a,

               e4 b
       ), --256 rows
 e16(n) AS

        (SELECT 1

          FROM e8 a,

               e8 b
       ) --65536 rows

SELECT row_number() OVER (
                          ORDER BY
                            (SELECT NULL)) [n]

  FROM e16;
