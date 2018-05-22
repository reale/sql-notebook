SELECT machine

  FROM v$session

 WHERE regexp_like(machine, '^([[:alnum:]]+\.)+[[:alnum:]-]+$');
