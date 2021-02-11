select *
from emp;
select *
from salgrade;

select max(sal), CAST(AVG(sal) AS DECIMAL(10,2)), max(sal) - CAST(AVG(sal) AS DECIMAL(10,2))
from emp;
select count(empno)
from emp;

select dept.dname, count(*) as employee_count
from emp
    inner join dept on emp.deptno = dept.deptno
group by dept.dname
having count(*) > 2;

select ename, sal
from emp
where sal > (select avg(sal)
from emp)
order by sal desc;

CREATE TABLE pivot_test
(
    id NUMBER,
    customer_id NUMBER,
    product_code VARCHAR2(5),
    quantity NUMBER
);

INSERT INTO pivot_test
VALUES
    (1, 1, 'A', 10);
INSERT INTO pivot_test
VALUES
    (2, 1, 'B', 20);
INSERT INTO pivot_test
VALUES
    (3, 1, 'C', 30);
INSERT INTO pivot_test
VALUES
    (4, 2, 'A', 40);
INSERT INTO pivot_test
VALUES
    (5, 2, 'C', 50);
INSERT INTO pivot_test
VALUES
    (6, 3, 'A', 60);
INSERT INTO pivot_test
VALUES
    (7, 3, 'B', 70);
INSERT INTO pivot_test
VALUES
    (8, 3, 'C', 80);
INSERT INTO pivot_test
VALUES
    (9, 3, 'D', 90);
INSERT INTO pivot_test
VALUES
    (10, 4, 'A', 100);
COMMIT;
SELECT *
FROM (SELECT product_code, quantity
    FROM pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR
(product_code) IN
('A' AS a, 'B' AS b, 'C' AS c));

