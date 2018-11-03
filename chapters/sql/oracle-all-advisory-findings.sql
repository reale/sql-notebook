SELECT f.type,

       t.execution_start,

       t.execution_end,

       t.status,

       f.impact,

       f.impact_type,

       f.message

  FROM dba_advisor_findings f

  JOIN dba_advisor_tasks t
    ON f.task_id = t.task_id

 WHERE (--  Oracle Bug 12347332

         (SELECT VERSION
          FROM product_component_version
          WHERE product LIKE 'Oracle Database%' ) NOT LIKE '10.2.0.5%'
       OR f.message <> 'Significant virtual memory paging was detected on the host operating system.');
