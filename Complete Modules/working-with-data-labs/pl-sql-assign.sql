CREATE TABLE BANK
(
    age NUMBER,
    job_type VARCHAR(255),
    marital VARCHAR(255),
    education VARCHAR(255),
    credit_default VARCHAR(255),
    balance NUMBER,
    housing VARCHAR(255),
    loan VARCHAR(255),
    contact VARCHAR(255),
    cday VARCHAR(255),
    cmonth VARCHAR(255),
    cduration NUMBER,
    campaign NUMBER,
    pdays NUMBER,
    previous NUMBER,
    poutcome VARCHAR(255),
    y VARCHAR(255)
);


select distinct age
from bank;
set SERVEROUTPUT ON;

create or replace procedure get_data
as
    counter number :=0;
    d bank."age"%type;
begin
    select distinct "age"
    into d
    from bank;
    exception WHEN too_many_rows THEN
    dbms_output.put_line
    ('Errors fetching data');

while counter <= 2 loop
        counter := counter +1;
        DBMS_OUTPUT.PUT_LINE
(counter);
end loop;
end;

DECLARE
begin
    get_data;
end;

declare cursor cursor1
is
select distinct education
from bank
order by education;
record1 cursor1%rowtype;
begin
    for record1 in cursor1 loop
DBMS_OUTPUT.PUT_line
    ('Education returned ' || record1.education);
end
loop;
end;

declare
    sig number;
    mean number := 1;
    stdev number := 1;
begin
    SYS.dbms_stat_funcs.normal_dist_fit
('mdrzezdzon', 'bank', 'age', 'KOLMOGOROV_SMIRNOV', mean, stdev, sig);
    SYS.dbms_stat_funcs.POISSON_DIST_FIT
('mdrzezdzon', 'bank', 'age', 'KOLMOGOROV_SMIRNOV', stdev, sig);
    
    SYS.dbms_stat_funcs.normal_dist_fit
('mdrzezdzon', 'bank', 'balance', 'KOLMOGOROV_SMIRNOV', mean, stdev, sig);
    SYS.dbms_stat_funcs.POISSON_DIST_FIT
('mdrzezdzon', 'bank', 'balance', 'KOLMOGOROV_SMIRNOV', stdev, sig);
    
    SYS.dbms_stat_funcs.normal_dist_fit
('mdrzezdzon', 'bank', 'cduration', 'KOLMOGOROV_SMIRNOV', mean, stdev, sig);
    SYS.dbms_stat_funcs.POISSON_DIST_FIT
('mdrzezdzon', 'bank', 'cduration', 'KOLMOGOROV_SMIRNOV', stdev, sig);

end;

set serveroutput on;

declare
begin
    dbms_stats.gather_table_stats
('mdrzezdzon', 'bank', estimate_percent => dbms_stats.auto_sample_size);
end;


DECLARE
    v_age bank.age%type;
    v_mode_age bank.age%type;
    v_avg_age bank.age%type;
    v_job_type bank.job_type%type;
    v_marital bank.marital%type;

begin
    select round(STDDEV(age),2)
    into v_age
    from bank;

    select round(stats_mode(age),2)
    into v_mode_age
    from bank;

    select round(AVG(age),2)
    into v_avg_age
    from bank;

    select stats_mode(job_type)
    into v_job_type
    from bank;

    select stats_mode(marital)
    into v_marital
    from bank;

    DBMS_OUTPUT.put_line
    ('Standard of deviation Age: ' || v_age);
DBMS_OUTPUT.put_line
('Average Age: ' || v_avg_age);
    DBMS_OUTPUT.put_line
('Most Common Age: ' || v_mode_age);
    DBMS_OUTPUT.put_line
('Most Common Job: ' || v_job_type);
    DBMS_OUTPUT.put_line
('Most Common Marital status: ' || v_marital);
end;

select education, count(*)
into edu_1
from bank
group by education;

select distinct *
from bank;
select distinct job_type
from bank;

UPDATE bank
SET job_type = 'admin'
WHERE job_type = 'admin.';

select job_type, 'Occupations', count(job_type)
from bank
group by job_type;


select job_type, round((Count(job_type)* 100 / (Select Count(*)
    From bank)), 2)"%"
from bank
group by job_type;
select marital, round((Count(marital)* 100 / (Select Count(*)
    From bank)), 2)"%"
from bank
group by marital;
select education, round((Count(education)* 100 / (Select Count(*)
    From bank)), 2)"%"
from bank
group by education;

Delete from bank where education = 'unknown';
Delete from bank where job_type = 'unknown';

set serveroutput on;
DECLARE
begin 
    DBMS_OUTPUT.PUT_LINE
('');
    DBMS_OUTPUT.PUT_LINE
('Job Type Distribution');
    for rec in
(select job_type, round((Count(job_type)* 100 / (Select Count(*)
    From bank)), 2)"%"
from bank
group by job_type)
loop
    DBMS_OUTPUT.PUT_LINE
('| ' || rec.job_type || ' | %' || rec."%"|| '|');
end loop;
    
    DBMS_OUTPUT.PUT_LINE
('');
    DBMS_OUTPUT.PUT_LINE
('Marital Status Distribution');
    for rec in
(select marital, round((Count(marital)* 100 / (Select Count(*)
    From bank)), 2)"%"
from bank
group by marital)
loop
    DBMS_OUTPUT.PUT_LINE
('| ' || rec.marital || ' | %' || rec."%"|| '|');
end loop;

    DBMS_OUTPUT.PUT_LINE
('');
    DBMS_OUTPUT.PUT_LINE
('Education Distribution');
    for rec in
(select education, round((Count(education)* 100 / (Select Count(*)
    From bank)), 2)"%"
from bank
group by education)
loop
    DBMS_OUTPUT.PUT_LINE
('| ' || rec.education || ' | %' || rec."%" || '|');
end loop;

end;


DECLARE
    cursor_ SYS_REFCURSOR;

BEGIN

    OPEN cursor_
    FOR
    SELECT *
    FROM bank;
END;