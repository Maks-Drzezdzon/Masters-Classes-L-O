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