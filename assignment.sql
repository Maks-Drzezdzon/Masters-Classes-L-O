/*
a temp file to keep all the sql written to analyse data
*/

select *
from insurance;
/*
10 sql functions for report
*/

select max(charges)
from insurance;
select min(charges)
from insurance;

select max(age)
from insurance;
select min(age)
from insurance;

select max(children)
from insurance;
select min(children)
from insurance;

select max(bmi)
from insurance;
select min(bmi)
from insurance;

select count(*), count(smoker='no')
from insurance;