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
select median(charges)
from insurance;

select max(age)
from insurance;
select min(age)
from insurance;
select median(age)
from insurance;

select max(children)
from insurance;
select min(children)
from insurance;
select median(children)
from insurance;

select max(bmi)
from insurance;
select min(bmi)
from insurance;
select median(bmi)
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
select round(max(charges),2) "max charges cost"
from insurance;
/*63770.43*/
select round(min(charges),2) "min charges cost"
from insurance;
/*1121.87*/
select median(charges) "middle charges cost value"
from insurance;
/*9382.03*/

select charges
from ( 
    select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance
)
order by QUARTILE;

select sum(charges)
from insurance;
/*17,788,824.99*/
select round(sum(charges), 2)"all insurance charge costs"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance);

select round(sum(charges), 2)"insurance cost in first quartile"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance)
where quartile = 1;
/*955784.96*/

select round(sum(charges), 2)"insurance cost in second quartile"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance)
where quartile = 2;
/*2344668.18*/

select round(sum(charges), 2)"insurance cost in third quartile"
from (select charges, ntile(4) over(order by charges) as QUARTILE
    from insurance)
where quartile = 3;
/*4050700.59*/

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

select corr(children, age)
from insurance;
/*0.042*/
select corr(children, charges)
from insurance;
/*0.068*/
select corr(bmi, charges)
from insurance;
/*0.198*/
select corr(age, charges)
from insurance;
/*0.299*/

select rank(2344668.18 + 955784.96) within group (order by charges desc) "test"
from insurance;



