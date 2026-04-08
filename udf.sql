create database vitech_dev ;


create table vitech_dev.public.orders  clone 
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS ;
--SQL compilation error: Cannot clone from a table that was imported from a share.


create table vitech_dev.public.orders  as 
(select top 10000 * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS) ;
--table created successfully 


select * from vitech_dev.public.orders ;
--10000 data read


--built-in function 
select substr(o_orderpriority,0,1) from vitech_dev.public.orders ;






---                 user defined functions                 ---
--User-defined functions (UDFs) in Snowflake are custom functions you create to extend Snowflake's built-in functionality. They accept parameters, perform logic, and return a result. Snowflake supports UDFs written in SQL, JavaScript, Python, Java, and Scala.




--create user defined function(udf) 
--this function return a string 
CREATE OR REPLACE FUNCTION VITECH_DEV.PUBLIC.GET_FIRST_CHAR(input_str STRING)
RETURNS STRING
AS
$$
    SUBSTR(input_str, 0, 1)
$$;



select * from vitech_dev.public.orders ;

--using the user defined function and passing input to the function
SELECT O_CUSTKEY,GET_FIRST_CHAR(O_CLERK), 
GET_FIRST_CHAR(o_orderpriority) FROM VITECH_DEV.PUBLIC.ORDERS;


--- you can perform your own logic as well--

CREATE OR REPLACE FUNCTION VITECH_DEV.PUBLIC.GET_sum(input_str1 INT,input_str2 INT)
RETURNS INT
AS
$$
   INPUT_STR1 + input_str2 
$$;


select get_sum(10,30) as sum;
--result: 40



SELECT SYSDATE() ;


CREATE OR REPLACE FUNCTION VITECH_DEV.PUBLIC.GET_year(input_str STRING)
RETURNS STRING
AS
$$
    SUBSTR(input_str, 0, 4)
$$;

select get_year(sysdate());