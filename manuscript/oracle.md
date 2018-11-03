# Oracle Database

## String Manipulation

### Count the client sessions with a FQDN

Assume a FQDN has the form `N_1.N_2.....N_t`, where `t > 1` and each `N_i` can contain lowercase letters, numbers and the dash.

[embedmd]:# (sql/oracle-count-fqdn-client-hostnames.sql)
```sql
SELECT machine

  FROM v$session

 WHERE regexp_like(machine, '^([[:alnum:]]+\.)+[[:alnum:]-]+$');
```

### Calculate the edit (or Levenshtein) distance between a table name and the names of its dependent indexes

[embedmd]:# (sql/oracle-levenshtein-table-indexes.sql)
```sql
SELECT OWNER,

       TABLE_NAME,

       index_name,

       utl_match.edit_distance(TABLE_NAME, index_name) edit_distance

  FROM dba_indexes

 WHERE GENERATED = 'N';
```


## Numerical Recipes

### Calculate the sum of a geometric series

[embedmd]:# (sql/oracle-sum-of-geometric-series.sql)
```sql
SELECT sum(power(2, - LEVEL)) SUM

  FROM dual
CONNECT BY LEVEL < & n;
```


## Grouping and Reporting

### Count the data files for each tablespaces and for each filesystem location

Assume a Unix filesystem, do not follow symlinks. Moreover, generate subtotals for each of the two dimensions (*scil*. tablespace and filesystem location).
 
[embedmd]:# (sql/oracle-group-and-count-data-files.sql)
```sql
WITH df AS

        (SELECT tablespace_name,

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
```


## Data Analytics

### Calculate statistics about the redo log switches

[embedmd]:# (sql/oracle-log-switch-statistics.sql)
```sql
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
```

### Rank all the tables in the system based on their cardinality

We partition the result set by tablespace.

[embedmd]:# (sql/oracle-rank-tables-by-cardinality.sql)
```sql
SELECT tablespace_name,

       OWNER,

       TABLE_NAME,

       num_rows,

       rank() OVER (PARTITION BY tablespace_name
                    ORDER BY num_rows DESC) AS rank

  FROM dba_tables

 WHERE num_rows IS NOT NULL

 ORDER BY tablespace_name;
```

### Sort the object types by their average name length

By sorting the object types by the average name length of their instances, we find a metric about how *exoteric* a given object type is.

[embedmd]:# (sql/oracle-sort-object-types-by-avg-name-length.sql)
```sql
SELECT object_type,

       avg(length(object_name)) avg_name_length

  FROM dba_objects

 GROUP BY object_type

 ORDER BY avg(length(object_name)) DESC;
```

### Forecast tablespace usage growth through linear regression

[embedmd]:# (sql/oracle-tablespace-growth-forecast.sql)
```sql
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
```


## The MODEL clause

### Generate the even integers between -100 and 100, inclusive

[embedmd]:# (sql/oracle-model-row-generator.sql)
```sql
SELECT n

  FROM dual

 WHERE 1 = 2 model dimension BY (0 AS KEY) measures (0 AS n) rules upsert (n [for key from -100 to 100 increment 2] = cv(KEY));
```

*Cf.* http://www.orafaq.com/wiki/Oracle_Row_Generator_Techniques.


## Time is a Tyrant

### Show the first and last day of the current month

[embedmd]:# (sql/oracle-first-and-last-day-current-month.sql)
```sql
SELECT trunc(sysdate, 'MONTH') first_day_curr_month,

       trunc(last_day(sysdate)) last_day_curr_month

  FROM dual;
```

### Show the first and last day of the current year

[embedmd]:# (sql/oracle-first-and-last-day-current-year.sql)
```sql
SELECT trunc(sysdate, 'YEAR') first_day_curr_year,

       add_months(trunc(sysdate, 'YEAR'), 12) - 1 last_day_curr_year

  FROM dual;
```

*Cf.* the code at http://viralpatel.net/blogs/useful-oracle-queries/.

### Show the maximum possible date

December 31, 9999 CE, one second to midnight.

[embedmd]:# (sql/oracle-max-possible-date.sql)
```sql
SELECT to_char(to_date('9999-12-31', 'YYYY-MM-DD') + (1 - 1 / 24 / 60 / 60), 'DD-MON-YYYY hh12:mi:ss AD') AS latest_date

  FROM dual;
```

*Cf.* the code at http://stackoverflow.com/questions/687510/.

### Show the minimum possible date

[embedmd]:# (sql/oracle-min-possible-date.sql)
```sql
SELECT to_char(to_date(1, 'J'), 'DD-MON-YYYY hh12:mi:ss AD') AS earliest_date

  FROM dual;
```

*Cf.* the code at http://stackoverflow.com/questions/687510/, Oracle bug 106242.

### Calculate the calendar date of Easter, from 1583 to 2999

[embedmd]:# (sql/oracle-easter.sql)
```sql
WITH t0 AS

        (SELECT LEVEL + 1582 AS YEAR

          FROM dual
       CONNECT BY LEVEL <= 2299 - 1582
       ),

       t1 AS

        (SELECT YEAR,

               CASE
              WHEN YEAR < 1700 THEN 22

                    WHEN YEAR < 1900 THEN 23

                    WHEN YEAR < 2200 THEN 24

                    ELSE 25

                     END AS m,

               CASE
              WHEN YEAR < 1700 THEN 2

                    WHEN YEAR < 1800 THEN 3

                    WHEN YEAR < 1900 THEN 4

                    WHEN YEAR < 2100 THEN 5

                    WHEN YEAR < 2200 THEN 6

                    ELSE 0

                     END AS n,

               mod(YEAR, 19) AS a,

               mod(YEAR, 4) AS b,

               mod(YEAR, 7) AS c

          FROM t0
       ),

       t2 AS

        (SELECT YEAR,

               m,

               n,

               a,

               b,

               c,

               mod(19 * a + m, 30) AS d

          FROM t1
       ),

       t3 AS

        (SELECT YEAR,

               m,

               n,

               a,

               b,

               c,

               d,

               mod(2 * b + 4 * c + 6 * d + n, 7) AS e

          FROM t2
       ),

       t4 AS

        (SELECT YEAR,

               m,

               n,

               a,

               b,

               c,

               d,

               e,

               22 + d + e AS DAY,

               3 AS
         MONTH

          FROM t3
       ),

       t5 AS

        (SELECT YEAR,

               m,

               n,

               a,

               b,

               c,

               d,

               e,

               CASE
              WHEN DAY > 31 THEN DAY - 31

                    ELSE DAY

                     END AS DAY,

               CASE
              WHEN DAY > 31 THEN MONTH + 1

                    ELSE MONTH

                     END AS
         MONTH

          FROM t4
       ),

       t6 AS

        (SELECT YEAR,

               CASE
              WHEN DAY = 26
                   AND MONTH = 4                                 THEN 19

                    WHEN DAY = 25
                   AND MONTH = 4
                   AND d = 28
                   AND e = 6
                   AND a > 10 THEN 18

                    ELSE DAY

                     END AS DAY,


         MONTH

          FROM t5
       ),

       t7 AS

        (SELECT YEAR,

               to_date(to_char(DAY, '00') || to_char(MONTH, '00') || to_char(YEAR, '0000'), 'DDMMYYYY') AS easter_sunday

          FROM t6
       )
SELECT YEAR AS YEAR,

       easter_sunday - 52 AS jeudi_gras,

       easter_sunday - 48 AS carnival_monday,

       easter_sunday - 47 AS mardi_gras,

       easter_sunday - 46 AS ash_wednesday,

       easter_sunday - 7 AS palm_sunday,

       easter_sunday - 3 AS maundy_thursday,

       easter_sunday - 2 AS good_friday,

       easter_sunday - 1 AS holy_saturday,

       easter_sunday AS easter_sunday,

       easter_sunday + 1 AS easter_monday,

       easter_sunday + 39 AS ascension_of_christ,

       easter_sunday + 49 AS whitsunday,

       easter_sunday + 50 AS whitmonday,

       easter_sunday + 60 AS corpus_christi

  FROM t7;
```

*Cf.* the code at http://www.adp-gmbh.ch/ora/plsql/calendar.html.


## XML Database 101

### Return the total number of installed patches

[embedmd]:# (sql/oracle-count-installed-patches.sql)
```sql
SELECT extractvalue(dbms_qopatch.get_opatch_count, '/patchCountInfo')

  FROM dual;
```

### List user passwords (hashed, of course...)

From 11g onwards, password hashes do not appear in `dba_users` anymore. Of course they are still visible in `sys.user$`, but we can do better...

[embedmd]:# (sql/oracle-list-user-passwords.sql)
```sql
SELECT username,

       extract(xmltype(dbms_metadata.get_xml('USER', username)), '//USER_T/PASSWORD/text()').getstringval() AS password_hash

  FROM dba_users;
```

### Return patch details such as patch and inventory location

[embedmd]:# (sql/oracle-get-patch-details.sql)
```sql
SELECT xmlserialize(document dbms_qopatch.get_opatch_install_info AS CLOB indent SIZE = 2) AS info

  FROM dual;
```

*Cf.* the script at https://github.com/xtender/xt_scripts/blob/master/opatch/info.sql.

### Show patch inventory

[embedmd]:# (sql/oracle-show-patch-inventory.sql)
```sql
SELECT xmltransform(dbms_qopatch.get_opatch_lsinventory, dbms_qopatch.get_opatch_xslt).getclobval() AS lsinventory

  FROM dual;
```

*Cf.* the script at https://github.com/xtender/xt_scripts/blob/master/opatch/lsinventory.sql.

### Show patch inventory, part 2

[embedmd]:# (sql/oracle-show-patch-inventory-2.sql)
```sql
WITH opatch AS

        (SELECT dbms_qopatch.get_opatch_lsinventory patch_output

          FROM dual
       )
SELECT patches.*

  FROM opatch,

       xmltable('InventoryInstance/patches/*' passing opatch.patch_output columns patch_id NUMBER path 'patchID', patch_uid NUMBER path 'uniquePatchID', description varchar2(80) path 'patchDescription', applied_date varchar2(30) path 'appliedDate', sql_patch varchar2(8) path 'sqlPatch', rollbackable varchar2(8) path 'rollbackable') patches;
```

*Cf.* the script at https://github.com/xtender/xt_scripts/blob/master/opatch/patches.sql.

### Show bugs fixed by each installed patch

[embedmd]:# (sql/oracle-show-bugs-fixed.sql)
```sql
WITH bugs AS

        (SELECT id,

               description

          FROM xmltable('/bugInfo/bugs/bug' passing dbms_qopatch.get_opatch_bugs columns id NUMBER path '@id', description varchar2(100) path 'description')
       )
SELECT *

  FROM bugs;
```

*Cf.* the code at https://github.com/xtender/xt_scripts/blob/master/opatch/bug_fixed.sql.


## Décroissance

### Calculate the high-water and excess allocated size for datafiles

[embedmd]:# (sql/oracle-hwm-excess-allocated-size.sql)
```sql
WITH pars AS

        (-- block size in MiB
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

        (SELECT file_id,

               max(block_id + blocks - 1) AS hwm

          FROM dba_extents

         GROUP BY file_id
       ) ext USING (file_id);
```

### Calculate a fragmentation factor for tablespaces

The fragmentation column gives an overall score with respect to how badly a
tablespace is fragmented; a 100% score indicates no fragmentation at all.

It is calculated according to the following formula:

                ___________      
              \/max(blocks)      
                         
    1 - ------------------------ 
                         
                    =====        
         4_______   \            
        \/blocks##    >    blocks 
                    /            
                    =====        
 
[embedmd]:# (sql/oracle-index-fragmentation-factor.sql)
```sql
SELECT tablespace_name AS TABLESPACE,

       count(*) AS free_chunks,

       nvl(max(bytes) / 1048576, 0) AS largest_chunk,

       100 * (1 - nvl(sqrt(max(blocks) / (sqrt(sqrt(count(blocks))) * sum(blocks))), 0)) AS fragmentation

  FROM dba_free_space

 GROUP BY tablespace_name;
```

*Cf.* the book *Oracle Performance Troubleshooting*, by Robin Schumacher.


## Miscellanea

### Get local host name and local IP address of the database server

[embedmd]:# (sql/oracle-host-name-ip-address-db-server.sql)
```sql
SELECT utl_inaddr.get_host_name hostname,

       utl_inaddr.get_host_address ip_addr

  FROM dual;
```

### Count number of segments for each order of magnitude

Note: IEC prefixes are used.

[embedmd]:# (sql/oracle-count-segments-by-order-of-magnitude.sql)
```sql
SELECT decode(trunc(log(1024, bytes)), 0, 'bytes', 1, 'KiB', 2, 'MiB', 3, 'GiB', 4, 'TiB', 5, 'PiB', 6, 'EiB', 7, 'ZiB', 8, 'YiB', 'UNKNOWN') AS order_of_magnitude,

       count(*) COUNT

  FROM dba_segments

 GROUP BY trunc(log(1024, bytes))

 ORDER BY trunc(log(1024, bytes));
```

### Display the findings discovered by all advisors in the database

[embedmd]:# (sql/oracle-all-advisory-findings.sql)
```sql
SELECT f.type,

       t.execution_start,

       t.execution_end,

       t.status,

       f.impact,

       f.impact_type,

       f.message

  FROM dba_advisor_findings f

  JOIN dba_advisor_tasks t
    ON f.task_id = t.task_id

 WHERE (--  Oracle Bug 12347332

         (SELECT VERSION
          FROM product_component_version
          WHERE product LIKE 'Oracle Database%' ) NOT LIKE '10.2.0.5%'
       OR f.message <> 'Significant virtual memory paging was detected on the host operating system.');
```


