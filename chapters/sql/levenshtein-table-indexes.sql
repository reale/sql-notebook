SELECT OWNER,

       TABLE_NAME,

       index_name,

       utl_match.edit_distance(TABLE_NAME, index_name) edit_distance

  FROM dba_indexes

 WHERE GENERATED = 'N';
