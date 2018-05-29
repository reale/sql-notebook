SELECT d.name db,

       t.name tablespace_name,

       regr_slope(tablespace_usedsize, snap_id) usage_growth,

       regr_r2(tablespace_usedsize, snap_id) r_squared

  FROM dba_hist_tbspc_space_usage h

  JOIN v$database d USING(dbid)

  JOIN v$tablespace t
    ON (h.tablespace_id = t.ts #)

 GROUP BY d.name,

          t.name

 ORDER BY db,

          tablespace_name;
