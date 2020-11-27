select *
from insurance;
/*
10 sql functions for report
*/

/*
discriptie statistics 

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

select count(*), smoker
from insurance
where smoker = 'no'
group by smoker;
/*1064*/

select count(*), smoker
from insurance
where smoker = 'yes'
group by smoker;
/*274*/

/* 5 number summary */
select max(charges) "max charges cost"
from insurance;
select min(charges) "min charges cost"
from insurance;
select median(charges) "middle charges cost value"
from insurance;

select charges
from ( 
    select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance
)
order by QUARTILE;

select sum(charges)
from insurance;
select round(sum(charges), 2)"all insurance charge costs"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance);

select round(sum(charges), 2)"insurance cost in first quartile"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance)
where quartile = 1;

select round(sum(charges), 2)"insurance cost in second quartile"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance)
where quartile = 2;

select round(sum(charges), 2)"insurance cost in third quartile"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance)
where quartile = 3;

select round(sum(charges), 2)"insurance cost in forth quartile"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance)
where quartile = 4;


/*
# trying to figure out how to write quartiles in sql

select charges, ntile(4) over(order by charges) as QUARTILE from insurance;
select charges, (case when NTILE(4) over(order by charges) <= 1 then 1
when NTILE(4) over(order by charges) <= 2 then 2
when NTILE(4) over(order by charges) <= 3 then 3
else 4
end) QUARTILE 
from insurance
order by charges
*/


/* std */
select round(stddev(charges), 2) "Standard Deviation of charges"
from insurance;


