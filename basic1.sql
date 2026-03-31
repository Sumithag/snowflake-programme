create database class2;

create table student ( 
id int,
name varchar(20),
mob varchar(20)
);

select * from student;

insert into student values
(1,'sumitha',6360007486),
(2,'sujatha',9663309730),
(3,'mathi',7338020113);

select id from student;
select id,name from student where not name ='sumitha';

select name as student_name from student where name like 's%';


alter table student add address varchar(20);

select * from student;

update student set address= 'bangalore';

update student set address= 'chennai' where name='sumitha';




create table student ( 
id int,
name varchar(20),
mob varchar(20)
);

select * from student;

delete from student;


alter table student drop column address;


delete from student where id =1;


truncate table student;
select * from student;

drop table student;
select * from student;

select 5;
select 10+5;
select 10+5 as total;

select 20;
select 50-20;
select 50+32-10 as calculations;


select * from student;
undrop table student;
drop table student;





#####3-----------------------------------


MERGE INTO target_table AS t
USING source_table AS s
ON t.key_column = s.key_column
WHEN MATCHED THEN
  UPDATE SET 
    t.column1 = s.column1,
    t.column2 = s.column2
WHEN NOT MATCHED THEN
  INSERT (column1, column2)
  VALUES (s.column1, s.column2);

  
  -----------------------------------#####



  --------string functions---------

  -----concat()-----
  select concat('hello',' ','world') as result;
  select concat('1',',','2') ;

  select concat(id,' ',name) from student;

  select concat(id ,' ',name) from student where name='sumitha';
  ----------------------------


  

  --------------length()-----------------
  select name,length(name) as total_characters from student;

select length('sumitha') as total_characters;

 select name, length(name) as total_characters from student where name='mathi';
 ------------------------------------------------------------------



 -----------------------upper() and lower()-----------------------

 select upper('sumitha');
 select name, upper(name) as caps from student;
 select name,lower(name) from student;
 select name as NAME,lower(name) as lowercase from ;

-----------------------------------------------------------


------------------------reverse()--------------------------

 select reverse('mathi');

 select reverse(name) as reversed_name from student;

 select reverse(name) as reversed_name from student where name='mathi';
 ---------------------------------------------------------------------



 ------------------------replace()--------------------------------------

select replace('sumitha', 'sum','suj') as replaced_string;

select replace(name ,'suritha','sumitha') as replaced from student;

-------------------------------------------------------------------------

------------------------------left() and right()--------------------------

select left(name,2) from student;
select right(name,2) from student;

select name, left(name,4) from student where name='mathi';

update student set name=' sumitha gevaran ' where id=1;

select * from student;

select name, right(name,4)
from student where id=1;

----------------------------------------------------------------------------


---------------------------trim()-------------------------------------------------

select trim('  hello  ') as result;

select trim(name) from student where id=1;
select * from student;
 SELECT 
  name,
  TRIM(name) as trimmed_name,
  TRIM('!' FROM '!!!Hello!!') as trim_special_char,
  LTRIM(name) as left_trimmed,
  RTRIM(name) as right_trimmed,
  TRIM(BOTH ' ' FROM '   spaced   ') as both_sides_trimmed
FROM student;


select name, trim(name) from student;
select name, ltrim(name) from student;
select name, rtrim(name) from student;
select name, trim(name, 's') from student;
----------------------------------------------------------

------------------------substr()------------------

select substr(name, 1, 3) from student;

select substr(name,1,2) from student;
---------------------------------------------------


-----------------------number functions-----------------

------------------abs()---------------------------------

select abs(-25);
select abs(25);
---------------------------------------------------------

-------------------------ceil() and floor()-------------------------
select ceil(12.1);
select ceil(12.8);
select floor(12.9);
---------------------------------------------------------------------

---------------------------------round()-------------------------------

select round(12.5);
select round(12.3);
select round(12.8);
select round(12.98, 1);

--------------------------------------------------------------------------


---------------------------------sqrt()-------------------------------

select sqrt(25);
select sqrt(12.5);
-----------------------------------------------------------------------

------------------------------------pow()----------------------------

select pow(2,2);
select pow(3,3);
--------------------------------------------------------------------------


-------------------------------------mod()---------------------------------
select mod(10,3);


select id from student where mod(id,2)=0;

----------------------------------------------------------------------------

-------------------------------------aggregate functions------------------

select * from student;

alter table student add fee int;

update student set fee=50000 where name='sumitha gevaran';