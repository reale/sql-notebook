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


## Data Analytics

### Rank all the tables in the system based on their cardinality

We partition the result set by tablespace.

[embedmd]:# (sql/oracle-rank-tables-by-cardinality.sql)

### Sort the object types by their average name length

By sorting the object types by the average name length of their instances, we find a metric about how *exoteric* a given object type is.

[embedmd]:# (sql/oracle-sort-object-types-by-avg-name-length.sql)

### Forecast tablespace usage growth through linear regression

[embedmd]:# (sql/oracle-tablespace-growth-forecast.sql)


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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
