SELECT trunc(sysdate, 'MONTH') first_day_curr_month,

       trunc(last_day(sysdate)) last_day_curr_month

  FROM dual;
