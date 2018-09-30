SELECT to_char(to_date('9999-12-31', 'YYYY-MM-DD') + (1 - 1 / 24 / 60 / 60), 'DD-MON-YYYY hh12:mi:ss AD') AS latest_date

  FROM dual;
