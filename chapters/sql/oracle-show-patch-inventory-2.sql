WITH opatch AS

        ( SELECT dbms_qopatch.get_opatch_lsinventory patch_output

          FROM dual
       )
SELECT patches.*

  FROM opatch,

       xmltable( 'InventoryInstance/patches/*' passing opatch.patch_output columns patch_id NUMBER path 'patchID', patch_uid NUMBER path 'uniquePatchID', description varchar2(80) path 'patchDescription', applied_date varchar2(30) path 'appliedDate', sql_patch varchar2(8) path 'sqlPatch', rollbackable varchar2(8) path 'rollbackable' ) patches;
