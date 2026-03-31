create database examples;
create table a 
(
value int
);

create table b 
(
num integer
);

insert into a values
(1),
(2),
(3),
(4);

select * from a;



insert into b values
(4),
(5),
(6),
(7);



select * from b;

select * from a inner join
b on a.value=b.num;

select * from a
left join b on a.value=b.num;

select * from a 
right join b on a.value=b.num;



select * from a 
full join b on a.value=b.num;


select *from a 
cross join b;


create table c 
( value int);

create table d 
(num int);


insert into c values
(1),
(1),
(2),
(3),
(3);


select * from c;



insert into d values
(1),
(4),
(2),
(3),
(3),
(5);








select * from d;

select * from c
inner join d on c.value = d.num;


select * from c
left join d on c.value = d.num;

select * from c
right join d on c.value = d.num;


select * from c
full join d on c.value = d.num;



select count(*) from c
cross join d;


select value from a
union
select num from b;

select value from a
union all
select num from b;

select value from a
minus
select num from b;


select value from a
intersect 
select num from b;

insert into a values
(null);


select * from a;

select * ,coalesce(value,10) from a;




-------------------------assignment---------------------------------
 create table teams 
 ( team varchar());


 insert into teams values
 ('rcb'),
 ('sunrises hyderabad'),
 ('chennai super kings'),
 ('mumbai indians');


 select * from teams;

 select a.team,'vs' as vs, b.team from teams a cross join teams b
 where a.team <b.team;



 ----------------------------------------

 2)insert duplicate values and see joins count ;

"insert into c values
(1),
(1),
(2),
(3),
(3);


insert into d values
(1),
(4),
(2),
(3),
(3),
(5);";


select count(*) as leftjoincount from c
inner join d on c.value = d.num;

select count(*) as rigthjoincount from c
right join d on c.value = d.num;

select count(*) as fulljoincount from c
full join d on c.value = d.num;

select count(*) from c
cross join d; 
