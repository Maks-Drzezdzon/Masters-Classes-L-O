select regexp_substr(val, '[^/]+/[^/]+', 1, 1) as part1,
    regexp_substr(val, '[^/]+$', 1, 1) as part2
from (select 'F/P/O' as val
    from dual) t


set feedback off
spool users/grim/downloads/name.csv
select /*csv*/ *
from emp;
spool off
// run on multiple/cpus/nodes etc
parrallel
(degree 4)
set feedback on


/*
use dual table to select things
this table doesnt exist and you cant actual get data from it

*/
select min(sal), max(sal), avg(sal)
from emp
where job = 'MANAGER';

select *
from emp
where comm > sal/2;

select ename, avg(sal)
from emp
group by ename
order by avg(sal) desc;

select ename, avg(sal)
from emp
group by ename
order by avg(sal) desc;

select sysdate
from dual;
select to_char(to_date('11-Nov-2020', 'DD-MON-YYYY'), 'Day') bdate
from dual;
/*https://docs.oracle.com/en/database/oracle/oracle-database/12.2/sqlrf/Single-Row-Functions.html#GUID-5652DBC2-41C7-4F07-BEDD-DAF620E35F3C*/
SELECT TO_DATE('2012-06-05', 'YYYY-MM-DD')
FROM dual;
SELECT CONVERT(DATETIME, '2012-06-05', 102)
from dual;
SELECT TRY_CONVERT(DATETIME, 'ABC')
from dual;
