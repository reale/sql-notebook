# Oracle Database

## String Manipulation

### Count the client sessions with a FQDN

Assume a FQDN has the form `N_1.N_2.....N_t`, where `t > 1` and each `N_i` can contain lowercase letters, numbers and the dash.

[embedmd]:# (sql/count-fqdn-client-hostnames.sql)

### Calculate the edit (or Levenshtein) distance between a table name and the names of its dependent indexes

[embedmd]:# (sql/levenshtein-table-indexes.sql)


## Numerical Recipes

### Calculate the sum of a geometric series

[embedmd]:# (sql/sum-of-geometric-series.sql)


## Data Analytics

### Rank all the tables in the system based on their cardinality

We partition the result set by tablespace.

[embedmd]:# (sql/rank-tables-by-cardinality.sql)

### Sort the object types by their average name length

By sorting the object types by the average name length of their instances, we find a metric about how *exoteric* a given object type is.

[embedmd]:# (sql/sort-object-types-by-avg-name-length.sql)

### Forecast tablespace usage growth through linear regression

[embedmd]:# (sql/tablespace-growth-forecast.sql)


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
