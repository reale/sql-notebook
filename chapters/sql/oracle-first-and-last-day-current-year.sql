SELECT trunc(sysdate, 'YEAR') first_day_curr_year,

       add_months(trunc(sysdate, 'YEAR'), 12) - 1 last_day_curr_year

  FROM dual;
