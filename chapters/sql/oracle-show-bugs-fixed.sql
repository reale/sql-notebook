WITH bugs AS

        (SELECT id,

               description

          FROM xmltable('/bugInfo/bugs/bug' passing dbms_qopatch.get_opatch_bugs columns id NUMBER path '@id', description varchar2(100) path 'description')
       )
SELECT *

  FROM bugs;
