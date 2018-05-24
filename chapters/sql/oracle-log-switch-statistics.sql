SELECT inst_id,

       thread#,

       trunc(first_time) AS DAY,

       count(*) AS switches,

       to_char(count(*) / 24, '0.9999') AS avg_switches_per_hour,

       to_char(regr_slope(count(*), sysdate - trunc(first_time)) OVER (
                                                                       ORDER BY trunc(first_time)), '0.9999') AS switch_count_growth

  FROM gv$loghist

 GROUP BY inst_id,

          thread#,

          trunc(first_time)

 ORDER BY DAY;
