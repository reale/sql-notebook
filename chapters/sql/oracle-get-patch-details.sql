
SELECT xmlserialize( document dbms_qopatch.get_opatch_install_info AS CLOB indent SIZE = 2 ) AS info

  FROM dual;
