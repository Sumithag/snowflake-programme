create database OUR_FIRST_DB;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT (
  Loan_ID STRING,
  loan_status STRING,
  Principal STRING,
  terms STRING,
  effective_date STRING,
  due_date STRING,
  paid_off_time STRING,
  past_due_days STRING,
  age STRING,
  education STRING,
  Gender STRING);

--------extract----------------
COPY INTO OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT
  FROM 's3://bucketsnowflakes3/Loan_payments_data.csv'
  FILE_FORMAT = (type=csv    FIELD_DELIMITER = ',' SKIP_HEADER = 1 );



  
select * from OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT ; 

select 
loan_id , loan_status ,
coalesce(past_due_days , 0 ) as past_due_days
from OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT;


select loan_id , loan_status ,age 
from OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT;


------------------  ETL -----------------

create schema  stage ;

create or replace stage OUR_FIRST_DB.stage.LOAN_PAYMENT_stage 
url = 's3://bucketsnowflakes3/Loan_payments_data.csv' 
FILE_FORMAT = (type=csv    FIELD_DELIMITER = ',' SKIP_HEADER = 1 );



list @OUR_FIRST_DB.stage.LOAN_PAYMENT_stage ; 

 
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v1 (
  Loan_ID STRING,
  loan_status STRING,
  past_due_days STRING ,
  age string);


copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v1
from (
select $1 ,
       $2 ,
       coalesce($8 , 0 ) as past_due_days,
       $8 
       from @OUR_FIRST_DB.stage.LOAN_PAYMENT_stage );


select * from OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v1 ;

-------------------------ELT-------------------------------


create or replace stage OUR_FIRST_DB.stage.int_stage 
url = 's3://bucketsnowflakes3/Loan_payments_data.csv' 
FILE_FORMAT = (type=csv    FIELD_DELIMITER = ',' SKIP_HEADER = 1 );

list @OUR_FIRST_DB.stage.int_stage ;


COPY INTO OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT
  FROM  @OUR_FIRST_DB.stage.int_stage
  FILE_FORMAT = (type=csv    FIELD_DELIMITER = ',' SKIP_HEADER = 1 );

    select * from OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT ; 
    ---------------------------------------------------

create or replace stage OUR_FIRST_DB.stage.LOAN_PAYMENT_stage_v1 
url = 's3://bucketsnowflakes3' 
FILE_FORMAT = (type=csv    FIELD_DELIMITER = ',' SKIP_HEADER = 1 );

list @OUR_FIRST_DB.stage.LOAN_PAYMENT_stage_v1 ;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v5 (
  Loan_ID STRING,
  loan_status STRING,
  Principal STRING,
  terms STRING,
  effective_date STRING,
  due_date STRING,
  paid_off_time STRING,
  past_due_days STRING,
  age STRING,
  education STRING,
  Gender STRING);

    

  copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v5 
  from @OUR_FIRST_DB.stage.LOAN_PAYMENT_stage_v1 ;

    copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v5 
  from @OUR_FIRST_DB.stage.LOAN_PAYMENT_stage_v1 
  on_error = continue ;


    select * from OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v5 ;


  copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v5 
  from @OUR_FIRST_DB.stage.LOAN_PAYMENT_stage_v1 
  files = ('Loan_payments_data.csv') ;

    copy into OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT_v5 
  from @OUR_FIRST_DB.stage.LOAN_PAYMENT_stage_v1 
  pattern = '.*Loan.*.csv' ;

---------------------------------------------------




 ------------assignment------------------------------



create or replace stage OUR_FIRST_DB.stage.order_stage_v1
url = 's3://bucketsnowflakes3' 
FILE_FORMAT = (type=csv    FIELD_DELIMITER = ',' SKIP_HEADER = 1 );

list @OUR_FIRST_DB.stage.order_stage_v1 ;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));



select * from OUR_FIRST_DB.PUBLIC.ORDERS;

   copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') ;
  
   select * from OUR_FIRST_DB.PUBLIC.ORDERS ;   



select count(*) from OUR_FIRST_DB.PUBLIC.ORDERS;




select *,
case 
  when profit = 0 then 'no gain or loss'
  when profit > 0 then 'profit'
  else 'loss'
end as profit_status
from orders; 



select amount, quantity , amount*quantity as revenue from orders; 



----------------------copyn options -------------------

create or replace stage OUR_FIRST_DB.stage.order_stage_v1
url = 's3://bucketsnowflakes3' 
FILE_FORMAT = (type=csv    FIELD_DELIMITER = ',' SKIP_HEADER = 1 );

list @OUR_FIRST_DB.stage.order_stage_v1 ; 


CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
    
    
select * from OUR_FIRST_DB.PUBLIC.ORDERS ;  

   copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') ;

select * from OUR_FIRST_DB.PUBLIC.ORDERS ;  

---1500 records are read from orderdetails.csv ---
----performing copy operation again on existing table w/o drop ---------

  copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') ;
---load skipped because file was already read-----
---to load the data again use force=true ---------
 copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') 
  force=true;
----------- 1500 records loaded----------------
select * from OUR_FIRST_DB.PUBLIC.ORDERS ;
-------------3000 records are there in total----
 -------again-----
 copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') 
  force=true;

select * from OUR_FIRST_DB.PUBLIC.ORDERS ;

-----4500 records are available--------
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(3),
    SUBCATEGORY VARCHAR(30));
    

copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') ;
----throws error
--User character length limit (3) exceeded by ---string 'Furniture' File 'OrderDetails.csv'--------
--ie category column length is more in file data----
--to solve this use truncatecolumns=true---

copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') 
  truncatecolumns=true;
  ---loaded-----
  --o/p  despite more length three chracters will be loaded
  --fur
  --clo
  --ele so on....

select * from orders;
------------------


----ex 100 rows 20 bad datas rows
--still want to load w/o stopping
--use on_error=continue will load as
--much as data possible skipping error rows

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)); 
    
copy into OUR_FIRST_DB.PUBLIC.ORDERS
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') 
  on_error=continue;
-----------------------------------------




-----convert tabular data into json-----

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS1 (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)); 

        
copy into OUR_FIRST_DB.PUBLIC.ORDERS1
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') 
  on_error=continue;
  select *from orders1;

select OBJECT_CONSTRUCT(*) as converted_json from Orders1;

-----------------------------------------

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS2 (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)); 
    

        
copy into OUR_FIRST_DB.PUBLIC.ORDERS2
  from @OUR_FIRST_DB.stage.order_stage_v1 
  files = ('OrderDetails.csv') 
  on_error=continue;
  select *from orders2;

SELECT TO_XML(OBJECT_CONSTRUCT(*)) AS XML_DATA FROM OUR_FIRST_DB.PUBLIC.ORDERS2;







-------------------2) URL =    's3://bucketsnowflakes3'  
--without creating the tables manually need to load data 
  --   hint: infer_schema 



  create or replace stage practise
  url = 's3://bucketsnowflakes3' 
  file_format=(type='csv');


  list @practise;

SELECT * FROM TABLE(
  INFER_SCHEMA(
    LOCATION => '@practise/Loan_payments_data.csv',
    FILE_FORMAT => 'OUR_FIRST_DB.STAGE.my_csv_format'
  )
);

CREATE OR REPLACE FILE FORMAT OUR_FIRST_DB.STAGE.my_csv_format
  TYPE = 'CSV' PARSE_HEADER = TRUE;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.AUTO
USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION => '@practise/Loan_payments_data.csv',
      FILE_FORMAT => 'OUR_FIRST_DB.STAGE.my_csv_format'
    )
  )
);

COPY INTO OUR_FIRST_DB.PUBLIC.AUTO
FROM @practise/Loan_payments_data.csv
FILE_FORMAT = (FORMAT_NAME = 'OUR_FIRST_DB.STAGE.my_csv_format')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

SELECT * FROM OUR_FIRST_DB.PUBLIC.AUTO;

---------------------------------------------


CREATE OR REPLACE FILE FORMAT OUR_FIRST_DB.STAGE.my_csv_format1
  TYPE = 'CSV' PARSE_HEADER = TRUE;



CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.AUTO1
USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION => '@practise/OrderDetails.csv',
      FILE_FORMAT => 'OUR_FIRST_DB.STAGE.my_csv_format1'
    )
  )
);

COPY INTO OUR_FIRST_DB.PUBLIC.AUTO1
FROM @practise/OrderDetails.csv
FILE_FORMAT = (FORMAT_NAME = 'OUR_FIRST_DB.STAGE.my_csv_format1')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

SELECT * FROM OUR_FIRST_DB.PUBLIC.AUTO1;


----------------------------------

 list @practise;

 CREATE OR REPLACE FILE FORMAT OUR_FIRST_DB.STAGE.my_csv_format2
  TYPE = 'CSV' PARSE_HEADER = TRUE;



CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.AUTO2
USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION => '@practise/sampledata.csv',
      FILE_FORMAT => 'OUR_FIRST_DB.STAGE.my_csv_format2'
    )
  )
);

COPY INTO OUR_FIRST_DB.PUBLIC.AUTO2
FROM @practise/sampledata.csv
FILE_FORMAT = (FORMAT_NAME = 'OUR_FIRST_DB.STAGE.my_csv_format2')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
 
SELECT * FROM OUR_FIRST_DB.PUBLIC.AUTO2;