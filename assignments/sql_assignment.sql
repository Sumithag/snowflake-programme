
1) Display the details of all
employees ;


select * from employees;


2) Display the depart information from
department table ;

select * from departments;

3) Display the name and job for all the
employees;

select e.first_name, e.last_name,j.job_title from 
employees e , jobs j where e.job_id=j.job_id;



4) Display the name and salary  for all the employees;

select first_name,last_name,salary from employees;


5) Display the employee no and
totalsalary  for all the employees;



select employee_id, salary*12 as totalsalary from employees;


6) Display the employee name and annual
salary for all employees;


select first_name,last_name, salary as monthly_salary,salary*12 as annual_salary from employees;


7) Display the names of all the employees
who are working in depart number 10;

select first_name,last_name,department_id from employees where department_id = 10;



8) Display the names of all the employees
who are working as clerks and  drawing
a salary more than 3000;

select e.first_name,e.last_name,j.job_title,e.salary 
from employees e join jobs j on e.job_id=j.job_id 
where lower(j.job_title)='Purchasing Clerk' and e.salary<=3000;


9) Display the employee number and
name  who are earning comman salalry;



 select employee_id, first_name, salary 
from employees 
where salary in 
(
select salary 

from employees
group by salary 
having count(*) > 1
) order by salary;

10) Display the employee number and
name  who do not earn any common salary;

select employee_id,first_name,salary from employees 
where salary not in (
select salary from employees group by salary having count(*) > 1
);


11) Display the names of employees who
are working as clerks, salesman or 
analyst and drawing a salary more than 3000;


select e.first_name ,j.job_title,e.salary from employees e join jobs j
on e.job_id=j.job_id 
where j.job_title in('Purchasing Clerk','Sales Manager','analyst') and e.salary>3000;


12) Display the names of the employees
who are working in the company for  the
past 5 years; 



SELECT FIRST_NAME, LAST_NAME
FROM HR.PUBLIC.EMPLOYEES
WHERE DATEDIFF('YEAR', HIRE_DATE, CURRENT_DATE()) >= 5;


13) Display current Date;

select current_date;


14) Display the list of employees who
have joined the company before 
30-JUN-90 or after 31-DEC-90;

select * from employees 
where hire_date <'1990-06-30' or hire_date>'1990-12-31';


18) Display the names of employees
working in depart number 10 or 20 or 40 
or employees working as CLERKS,SALESMAN or ANALYST;

select first_name from employees e join jobs j 
on e.job_id=j.job_id
where e.department_id in( 10,20,40) or lower(j.job_title) in ('CLERK','SALESMAN','ANALYST');



19) Display the names of employees whose
name starts with alaphabet S;


select first_name from employees
where first_name like 'S%';


20) Display the Employee names for
employees whose name ends with alaphabet S;

select first_name,last_name from employees
where lower(last_name) like '%s';


21) Display the names of employees whose
names have second alphabet A in  their
names;


select first_name from employees 
where lower(first_name) like '_a%';


22) select the names of the employee
whose names is exactly five characters 
in length;

select first_name from employees 
where length(first_name)=5;


23) Display the names of the employee who
are not working as MANAGERS;


select e.first_name, j.job_title from employees e
join jobs j on e.job_id=j.job_id where not lower(j.job_title) like '%manager%';


24) Display the names of the employee who
are not working as SALESMAN OR  CLERK
OR ANALYST;


select e.first_name, j.job_title from employees e
join jobs j on e.job_id=j.job_id where j.job_title not in ('salesman', 'clerk', 'analyst');



26) Display the total number of employee
working in the company;


select count(*) as total_employees from employees;


27) Display the total salary beiging paid
to all employees;


select sum(salary) as total_salary from employees;


28) Display the maximum salary from emp
table;


select max(salary) from employees;29) Display the minimum salary from emp
table;


select min(salary) from employees;



30) Display the average salary from emp
table;


select avg(salary) as average_salary from employees;



31) Display the maximum salary being paid
to CLERK;


select max(e.salary) from employees e join 
jobs j on e.job_id = j.job_id where lower(j.job_title) like '%clerk%';



32) Display the maximum salary being paid
to depart number 20;

select max(salary) from employees where department_id=10;



33) Display the minimum salary being paid
to any SALESMAN;


select min(e.salary) from employees e join 
jobs j on e.job_id = j.job_id where lower(j.job_title) like '%salesman%';


34) Display the average salary drawn by
MANAGERS;

select avg(e.salary) from employees e join
jobs j on e.job_id=j.job_id where lower(j.job_title) like '%manager%';


35) Display the total salary drawn by
ANALYST working in depart number 40;

select sum(e.salary) from employees e join 
jobs j where e.job_id = j.job_id and lower(j.job_title) like '%clerk%' and e.department_id = 10;



36) Display the names of the employee in
order of salary i.e the name of  the
employee earning lowest salary should appear first;


select first_name,salary from employees order by salary;


37) Display the names of the employee in
descending order of salary;

select first_name, salary from employees order by salary desc;

38) Display the names of the employee in
order of employee name;

select first_name from employees order by first_name;



39) Display empno,ename,deptno,sal sort
the output first base on name and 
within name by deptno and with in deptno by sal;


select first_name,salary,department_id from employees 
order by first_name,department_id,salary;


40) Display the name of the employee
along with their annual salary(sal*12).The name of the employee earning
highest annual salary should apper first;


select first_name, salary*12 as annualsalary from employees 
order by annualsalary desc;


41) Display name,salary,hra,pf,da,total
salary for each employee. The  output
should be in the order of total salary,hra 15% of salary,da 10% of salary,pf
5%  salary,total salary will
be(salary+hra+da)-pf;

select first_name,salary, salary*0.15 as hra, 
salary*0.10 as da, salary*0.05 as pf, 
(salary+hra+da)-pf as total_salary from employees order by total_salary;


42) Display depart numbers and total
number of employees working in each 
department; 

select department_id,count(*)
from employees 
group by department_id 
order by department_id;


43) Display the various jobs and total
number of employees within each job 
group;

select j.job_title, count(e.employee_id) from 
jobs j join employees e 
on j.job_id = e.job_id
group by j.job_title;


44) Display the depart numbers and total
salary for each department;

select department_id,sum(salary) as total_salary
from employees 
group by department_id;


45) Display the depart numbers and max
salary for each department;

select department_id, max(salary) from employees
group by department_id;


46) Display the various jobs and total
salary for each job;

select j.job_title, sum(e.salary) as total_salary from
employees e join jobs j 
on e.job_id= j.job_id
group by j.job_title;

48) Display the depart numbers with more
than three employees in each dept;

select department_id from employees
group by department_id 
having count(*)>3;


49) Display the various jobs along with
total salary for each of the jobs 
Where total salary is greater than 40000;


select j.job_title, sum(e.salary) as total_salary from 
employees e join jobs j
on e.job_id= j.job_id 
group by j.job_title
having total_salary>30000;

50) Display the various jobs along with
total number of employees in each  job.
The output should contain only those jobs with more than three
employees;


select j.job_title , count(e.employee_id) as total_employee 
from employees e join jobs j 
on e.job_id = j.job_id
group by j.job_title 
having total_employee>=3;


51) Display the name of the employee who
earns highest salary;


select first_name 
 from employees where salary =
 (select max(salary) from employees);



52) Display the employee number and name
for employee working as clerk and 
earning highest salary among clerks;




select e.employee_id, e.first_name, 
row_number() over(order by e.salary desc) as max_salary
from employees e inner join jobs j
on e.job_id = j.job_id
where lower(j.job_title) like '%clerk%'
qualify max_salary = 1;


53) Display the names of salesman who
earns a salary more than the highest 
salary of any clerk;


select e.first_name, e.salary
from employees e join jobs j
on e.job_id = j.job_id
where lower(j.job_title) like '%sales%'
and e.salary > (select max(e2.salary) from employees e2 join jobs j2 on e2.job_id = j2.job_id where lower(j2.job_title) like '%clerk%');


54) Display the names of clerks who earn
a salary more than the lowest 
Salary  of any salesman;

select e.first_name, e.salary
from employees e join jobs j
on e.job_id = j.job_id
where lower(j.job_title) like '%clerk%'
and e.salary > (select min(e2.salary) from employees e2 join jobs j2 on e2.job_id = j2.job_id where lower(j2.job_title) like '%sales%');


Display the names of employees who earn a
salary more than that of  Jones or that
of salary grether than   that of
scott;


select first_name, salary from employees
where salary > ANY (
select salary from employees 
where lower(first_name) in ('jones','scott')
);


55) Display the names of the employees
who earn highest salary in their 
respective departments;

select first_name, department_id, salary,
dense_rank() over(partition by department_id order by salary desc) as drank
from employees qualify drank = 1;




56) Display the names of the employees
who earn highest salaries in their 
respective job groups;



select e.first_name,j.job_title, e.salary,
dense_rank() over(partition by j.job_title order by salary desc) as drank
from employees e join jobs j 
on e.job_id = j.job_id qualify drank = 1;



57) Display the employee names who are
working in accounting department;

select e.first_name, d.department_name 
from employees e join departments d
on e.department_id= d.department_id
where lower(d.department_name)='accounting';


58) Display the employee names who are
working in Chicago;

select e.first_name from employees e 
 join departments d on e.department_id = d.department_id
 join locations l on d.location_id = l.location_id
 where lower(l.city) = 'london';


59) Display the Job groups having total
salary greater than the maximum  salary
for managers;

SELECT j.job_title, SUM(e.salary) AS total_salary
FROM employees e JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_title
HAVING SUM(e.salary) > (
  SELECT MAX(e2.salary) FROM employees e2 JOIN jobs j2 ON e2.job_id = j2.job_id
  WHERE LOWER(j2.job_title) LIKE '%manager%'
);


60) Display the names of employees from
department number 10 with salary 
grether than that of any employee working in other department;

select first_name , salary from employees
where department_id=10 and salary > any
(
select salary from employees 
where not department_id=10
);



61) Display the names of the employees
from department number 10 with  salary
greater than that of all employee working in other departments;

select first_name , salary from employees
where department_id=10 and salary > all
(
select salary from employees 
where not department_id=10
);


62) Display the names of the employees in
Uppercase; 
 select upper(first_name)  as capital from employees;


 63) Display the names of the employees in
Lowecase;
select lower(first_name)  as capital from employees;


64) Display the names of the employees in
Propercase;

select initcap(first_name)  as capital from employees;


65) Display the length of Your name using
appropriate function;

select length('sumitha') ; 


66) Display the length of all the
employee names;
select first_name, length(first_name) as length from employees;


67) select name of the employee
concatenate with employee number;

select first_name , employee_id , concat(first_name,' ',employee_id) as concat from employees;


68) User appropriate function and extract
3 characters starting from 2 
characters from the following 
string 'Oracle'. i.e the out put should be 'ac';

select substr('Oracle',3,2);

69) Find the First occurance of character
'a' from the following string i.e 
'Computer Maintenance Corporation';

select position('a','computer maintenance corporation');


70) Replace every occurance of alphabhet
A with B in the string Allens(use 
translate function) ;

select replace('AllenA', 'A', 'B');
select translate('AllenA', 'A', 'B');

71) Display the informaction from emp
table.Where job manager is found it 
should be displayed as boos(Use replace function);

select * , replace(job_title, 'manager','boss') from employees e join jobs j 
on e.job_id=j.job_id ;

72) Display empno,ename,deptno from emp
table.Instead of display department 
numbers display the related department name(Use decode function);

select first_name , employee_id,
case department_id 
when 1 then 'Administration'
when 2 then 'Marketing'
when 3 then 'Purchasing'
when 4 then 'Human Resources'
when 5 then 'Shipping'
when 6 then 'IT'
when 7 then 'Public Relations'
when 8 then 'Sales'
when 9 then 'Executive'
when 10 then 'Finance'
when 11 then 'Accounting'
end from employees;


73) Display your age in days;

select datediff('day', '2001-07-03',current_date()) as days;

74) Display your age in months;
select datediff('month', '2001-07-03',current_date()) as month;


 75) display the current date as 15th
Augest Friday Nineteen Ninety Saven;

SELECT TO_CHAR(CURRENT_DATE(), '15th
Augest Friday Nineteen Ninety Saven') AS FORMATTED_DATE;


76) Display the following output for each
row from emp table. scott has joined the company on wednesday 13th August
ninten nintey;

select first_name || ' has joined company on '||
to_char(hire_date, 'DDth Month YYYY') as message
from employees;


77) Find the date for nearest saturday
after current date;

 select next_day(current_date(), 'sa') as next_saturday;

 78) Display current time;

 select current_time();

 
79) Display the date three months Before
the current date;

select dateadd('month',-3,current_date());

80) Display the common jobs from
department number 10 and 20;

select e.first_name ,j.job_title from employees e 
join jobs j on
e.job_id=j.job_id
where department_id=10 
intersect
select e.first_name ,j.job_title from employees e 
join jobs j 
on e.job_id= j.job_id
where department_id=20;


81) Display the jobs found in department
10 and 20 Eliminate duplicate jobs;



select e.first_name ,j.job_title from employees e 
join jobs j on
e.job_id=j.job_id
where department_id=10 
union
select e.first_name ,j.job_title from employees e 
join jobs j 
on e.job_id= j.job_id
where department_id=20;

82) Display the jobs which are unique to
department 10;

select distinct j.job_title
from employees e join jobs j 
on e.job_id = j.job_id 
where e.department_id = 10  and j.job_title not in 
(select distinct j.job_title 
from employees e join jobs j 
on e.job_id = j.job_id 
where e.department_id!= 10);



84) Display the details of those
employees who are in sales department and 
grade is 3;

select e.* from employees e 
join departments d on e.department_id = d.department_id
where d.department_name = 'Sales' ;


85) Display those who are not managers
and who are managers any one. i)display the managers names ii)display the who
are not managers ;

select e.first_name, j.job_title 
from employees e join jobs j 
on e.job_id = j.job_id 
where not lower(j.job_title) like '%manager%';

select first_name, last_name from employees
where employee_id in (select distinct manager_id from employees where manager_id is not null);


select first_name, last_name from employees
where employee_id not in (select distinct manager_id from employees where manager_id is not null);



86) Display those employee whose name
contains not less than 4 characters;

select first_name ,length(first_name) as result 
from employees
where result>=4;

87) Display those department whose name
start with "S" while the location 
name ends with "K";

select d.department_name 
from departments d join locations l 
on d.location_id=l.location_id
where lower(d.department_name) like 's%' and 
lower(l.city) like '%k%';



87) Display those department whose name
start with "s" while the location 
name ends with "k";


select d.department_name 
from departments d join locations l 
on d.location_id=l.location_id
where lower(d.department_name) like 's%' and 
lower(l.city) like '%o';



88) Display those employees whose manager
name is JONES;

select first_name from employees 
where manager_id in 
( select employee_id from employees 
where lower(first_name) like 'jones');


89) Display those employees whose salary
is more than 3000 after giving 20% 
increment;

select first_name , salary, salary*0.20+salary as incrementsalary
from employees where salary>3000;

90) Display all employees while their
dept names; 

select e.first_name, e.last_name, d.department_name
from employees e join departments d
on e.department_id = d.department_id;


91) Display ename who are working in
sales dept;

select e.first_name, e.last_name
from employees e join departments d
on e.department_id = d.department_id
where d.department_name = 'Sales';

92) Display employee name,deptname,salary
and comm for those sal in between  2000
to 5000 while location is chicago;

select e.first_name, d.department_name, e.salary
from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where e.salary between 2000 and 5000
and lower(l.city) = 'chicago';




93)Display those employees whose salary
greter than his manager salary;


select e.first_name, e.salary, m.first_name as manager_name, m.salary as manager_salary
from employees e
join employees m
on e.manager_id = m.employee_id
where e.salary > m.salary;


94) Display those employees who are
working in the same dept where his 
manager is work;



select e.first_name, e.salary, m.first_name as manager_name, m.salary as manager_salary
from employees e
join employees m
on e.manager_id = m.employee_id
where e.department_id=m.department_id;


95) Display those employees who are not
working under any manager;


 select first_name from employees 
 where manager_id is null;
 

97) Update the salary of each employee by
10% increment who are not  eligiblw for
commission;

update employees 
set salary = salary*0.10+salary;


select salary from employees
order by salary desc;


98) SELECT those employee who joined the
company before 31-dec-82 while  their
dept location is newyork or 
Chicago;

select e.first_name from 
employees e join departments d
on e.department_id= d.department_id
join locations l on d.location_id=l.location_id
where e.hire_date > '1988-12-31' and lower(l.city) in ('new york','chicago');


99) DISPLAY EMPLOYEE
NAME,JOB,DEPARTMENT,LOCATION FOR ALL WHO ARE WORKING  AS 
MANAGER? ;

select e.first_name , j.job_title,
d.department_name, l.city from 
employees e join jobs j 
on e.job_id= j.job_id
join departments d on 
e.department_id= d.department_id
join locations l on 
d.location_id=l.location_id
where e.employee_id in (
select distinct manager_id from employees where manager_id is not null
);


100) DISPLAY THOSE EMPLOYEES WHOSE
MANAGER NAME IS JONES?;


select e.first_name, e.last_name, m.first_name as manager_name
from employees e
join employees m on e.manager_id = m.employee_id
where lower(m.first_name) = 'jones';


101) Display name and salary of ford if
his salary is equal to his sal of his 
grade;

select e.first_name, e.salary
from employees e
join jobs j on e.job_id = j.job_id
where lower(e.first_name) = 'ford'
and e.salary between j.min_salary and j.max_salary;