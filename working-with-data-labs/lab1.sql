drop table student
cascade constraints;

create table STUDENT
(
    student_number VARCHAR2(20) PRIMARY KEY,
    first_name VARCHAR2(20),
    surname VARCHAR2(20),
    dob DATE,
    prog_code VARCHAR2(6)
);

insert into STUDENT
    (student_number, first_name, surname, dob, prog_code)
values
    ('D020150120', 'Brendan', 'Tierney', to_date('19/01/1995', 'DD/MM/YYYY'), 'DT228B');

insert into STUDENT
    (student_number, first_name, surname, dob, prog_code)
values
    ('D020150121', 'Damian', 'Gordon', to_date('20/06/1965', 'DD/MM/YYYY'), 'DT228B');

insert into STUDENT
    (student_number, first_name, surname, dob, prog_code)
values
    ('D020150122', 'Deirdre', 'Lawless', to_date('04/10/1973', 'DD/MM/YYYY'), 'DT228B');

insert into STUDENT
    (student_number, first_name, surname, dob, prog_code)
values
    ('D020150123', 'Robert', 'Ross', to_date('28/12/2000', 'DD/MM/YYYY'), 'DT228B');

select *
from student;
select first_name
from student
where prog_code = 'DT228B';
select first_name
from student
where first_name like 'D%';

select *
from student
where student_number = 'D020150123';

update STUDENT
set prog_code = 'DT228A'
where student_number = 'D020150123';

select *
from student
where student_number = 'D020150123';


delete from STUDENT where student_number = 'D020150123';
delete from STUDENT where first_name like 'D%';

insert into STUDENT
    (student_number, first_name, surname, dob, prog_code)
values
    ('C15311966', 'Maks', 'Drzezdzon', to_date('17/10/1995', 'DD/MM/YYYY'), 'DT060');

insert into STUDENT
    (student_number, first_name, surname, dob, prog_code)
values
    ('C15311666', 'Maks_twin', 'Drzezdzon', to_date('17/10/1995', 'DD/MM/YYYY'), 'TU063');
select *
from STUDENT;

update STUDENT
set 
first_name = 'Maksymilian', prog_code = 'TU063'
where student_number = 'C15311966';

update STUDENT
set 
prog_code = 'TU062'
where student_number = 'D020150120';
select *
from STUDENT;


create table COURSE_CODES
(
    COURSE_ID VARCHAR2(20) PRIMARY KEY,
    COURSE_CODE VARCHAR2(10),
    COURSE_DESCRIPTION VARCHAR2(100)
);

insert into COURSE_CODES
    (COURSE_ID, COURSE_CODE, COURSE_DESCRIPTION)
values
    ('TU060', 'TU060', 'Msc Computer Science - Data Science');

insert into COURSE_CODES
    (COURSE_ID, COURSE_CODE, COURSE_DESCRIPTION)
values
    ('TU061', 'TU061', 'Msc Computer Science - Software Development');

insert into COURSE_CODES
    (COURSE_ID, COURSE_CODE, COURSE_DESCRIPTION)
values
    ('TU062', 'TU062', 'Msc Computer Science - Data Engineering');

insert into COURSE_CODES
    (COURSE_ID, COURSE_CODE, COURSE_DESCRIPTION)
values
    ('TU063', 'TU063', 'Msc Computer Science - Black Magick');
select *
from COURSE_CODES;

alter table COURSE_CODES add FULL_PART_TIME  VARCHAR2(2);
select *
from COURSE_CODES;

update COURSE_CODES
set full_part_time = 'FT'
where course_code = 'TU060' or course_code = 'TU062';

update COURSE_CODES
set full_part_time = 'PT'
where course_code = 'TU061' or course_code = 'TU063';
select *
from COURSE_CODES;


select student_number, first_name, course_description
from STUDENT join COURSE_CODES on student.prog_code = course_codes.course_code;

select count(*), course_description
from STUDENT join COURSE_CODES on student.prog_code = course_codes.course_code
group by course_description;
