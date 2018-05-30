
SELECT xmltransform( dbms_qopatch.get_opatch_lsinventory, dbms_qopatch.get_opatch_xslt ).getclobval() AS lsinventory

  FROM dual;
