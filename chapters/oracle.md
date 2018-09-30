# Oracle Database

## String Manipulation

### Count the client sessions with a FQDN

Assume a FQDN has the form `N_1.N_2.....N_t`, where `t > 1` and each `N_i` can contain lowercase letters, numbers and the dash.

[embedmd]:# (sql/oracle-count-fqdn-client-hostnames.sql)

### Calculate the edit (or Levenshtein) distance between a table name and the names of its dependent indexes

[embedmd]:# (sql/oracle-levenshtein-table-indexes.sql)


## Numerical Recipes

### Calculate the sum of a geometric series

[embedmd]:# (sql/oracle-sum-of-geometric-series.sql)


## Grouping and Reporting

### Count the data files for each tablespaces and for each filesystem location

Assume a Unix filesystem, do not follow symlinks. Moreover, generate subtotals for each of the two dimensions (*scil*. tablespace and filesystem location).
 
[embedmd]:# (sql/oracle-group-and-count-data-files.sql)


## Data Analytics

### Calculate statistics about the redo log switches

[embedmd]:# (sql/oracle-log-switch-statistics.sql)

### Rank all the tables in the system based on their cardinality

We partition the result set by tablespace.

[embedmd]:# (sql/oracle-rank-tables-by-cardinality.sql)

### Sort the object types by their average name length

By sorting the object types by the average name length of their instances, we find a metric about how *exoteric* a given object type is.

[embedmd]:# (sql/oracle-sort-object-types-by-avg-name-length.sql)

### Forecast tablespace usage growth through linear regression

[embedmd]:# (sql/oracle-tablespace-growth-forecast.sql)


## The MODEL clause

### Generate the even integers between -100 and 100, inclusive

[embedmd]# (sql/oracle-model-row-generator.sql)

*Cf.*: http://www.orafaq.com/wiki/Oracle_Row_Generator_Techniques.


## Time is a Tyrant

### Show the first and last day of the current month

[embedmd]:# (sql/oracle-first-and-last-day-current-month.sql)

### Show the first and last day of the current year

[embedmd]:# (sql/oracle-first-and-last-day-current-year.sql)

*Cf.* the code at http://viralpatel.net/blogs/useful-oracle-queries/.

### Show the maximum possible date

December 31, 9999 CE, one second to midnight.

[embedmd]:# (sql/oracle-max-possible-date.sql)

*Cf.* the code at http://stackoverflow.com/questions/687510/.

### Show the minimum possible date

[embedmd]:# (sql/oracle-min-possible-date.sql)

*Cf.* the code at http://stackoverflow.com/questions/687510/, Oracle bug 106242.

### Calculate the calendar date of Easter, from 1583 to 2999

[embedmd]:# (sql/oracle-easter.sql)

*Cf.* the code at http://www.adp-gmbh.ch/ora/plsql/calendar.html.


## XML Database 101

### Return the total number of installed patches

[embedmd]:# (sql/oracle-count-installed-patches.sql)

### List user passwords (hashed, of course...)

From 11g onwards, password hashes do not appear in `dba_users` anymore. Of course they are still visible in `sys.user$`, but we can do better...

[embedmd]:# (sql/oracle-list-user-passwords.sql)

### Return patch details such as patch and inventory location

[embedmd]:# (sql/oracle-get-patch-details.sql)

*Cf.* the script at https://github.com/xtender/xt_scripts/blob/master/opatch/info.sql.

### Show patch inventory

[embedmd]:# (sql/oracle-show-patch-inventory.sql)

*Cf.* the script at https://github.com/xtender/xt_scripts/blob/master/opatch/lsinventory.sql.

### Show patch inventory, part 2

[embedmd]:# (sql/oracle-show-patch-inventory-2.sql)

*Cf.* the script at https://github.com/xtender/xt_scripts/blob/master/opatch/patches.sql.

### Show bugs fixed by each installed patch

[embedmd]:# (sql/oracle-show-bugs-fixed.sql)

*Cf.* the script at https://github.com/xtender/xt_scripts/blob/master/opatch/bug_fixed.sql.


## Décroissance

### Calculate the high-water and excess allocated size for datafiles

[embedmd]:# (sql/oracle-hwm-excess-allocated-size.sql)

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

*Cf.* the book *Oracle Performance Troubleshooting*, by Robin Schumacher.


## Miscellanea

### Get local host name and local IP address of the database server

[embedmd]:# (sql/oracle-host-name-ip-address-db-server.sql)

### Count number of segments for each order of magnitude

Note: IEC prefixes are used.

[embedmd]:# (sql/oracle-count-segments-by-order-of-magnitude.sql)


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
