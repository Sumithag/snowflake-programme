---create s3 bucket
---folders and upload FILES
----location    s3://sumithag/csv/'
create or replace stage netflix
url = 's3://sumithag/csv/';

list @netflix;

----cannot access because no connection btw aws and snowdlake---

---step 1  describe storage /s3 integration--
--create iam roles
--- arn    arn:aws:iam::832767338097:role/storage_access
-- s3 storage access doc and copy code


CREATE STORAGE INTEGRATION access_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::832767338097:role/storage_access'
  STORAGE_ALLOWED_LOCATIONS = ('s3://sumithag/csv/', 's3://sumithag/json/');

  describe integration access_integration;


  --external arn id    RL61611_SFCRole=5_bGSZE4XYFX82DkaDFuieSa9wAks=
--user arn   arn:aws:iam::640083578061:user/externalstages/cich5d0000
---copied from output
--- edit trust relationships on iam role

create or replace stage netflix
url = 's3://sumithag/csv/'
storage_integration=access_integration;

list @netflix;
--upload files on cvs on s3 

list @netflix;
---uploaded file is also accessible




CREATE OR REPLACE FILE FORMAT csv_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';


    CREATE OR REPLACE TABLE netflix_data (
    show_id       STRING,
    type          STRING,
    title         STRING,
    director      STRING,
    cast          STRING,
    country       STRING,
    date_added    STRING,
    release_year  INT,
    rating        STRING,
    duration      STRING,
    listed_in     STRING,
    description   STRING
);

copy into netflix_data 
from @netflix
file_format=csv_format
files = ('netflix_titles.csv');

select top 5 * from netflix_data;





-----snowpipe



 CREATE OR REPLACE TABLE netflix_data (
    show_id       STRING,
    type          STRING,
    title         STRING,
    director      STRING,
    cast          STRING,
    country       STRING,
    date_added    STRING,
    release_year  INT,
    rating        STRING,
    duration      STRING,
    listed_in     STRING,
    description   STRING
);




CREATE OR REPLACE FILE FORMAT csv_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';




CREATE OR REPLACE PIPE netflix_pipe
    AUTO_INGEST = TRUE
    AS
copy into netflix_data 
from @netflix
file_format=csv_format
on_error= 'continue';





describe pipe netflix_pipe;


--notification channel
--arn:aws:sqs:eu-north-1:640083578061:sf-snowpipe-AIDAZKB7UJTGQZAKLTISI-eWYGMbRvsA_G0g8bR2Lbxg

alter pipe netflix_pipe refresh ;


select * from netflix_data;



SELECT SYSTEM$PIPE_STATUS('NETFLIX_PIPE');


ALTER PIPE NETFLIX_PIPE SET PIPE_EXECUTION_PAUSED = TRUE;

ALTER PIPE NETFLIX_PIPE SET PIPE_EXECUTION_PAUSED = FALSE;

alter pipe netflix_pipe refresh ;

SELECT SYSTEM$PIPE_STATUS('NETFLIX_PIPE');


-------------employee data 
---------------
-----------------
---------------

CREATE OR REPLACE TABLE employee_table (
    id            STRING,
    first_name    STRING,
    last_name     STRING,
    email         STRING,
    location      STRING,
    department    STRING
);


CREATE OR REPLACE PIPE employee_pipe
    AUTO_INGEST = TRUE
    AS
copy into employee_table 
from @netflix
file_format=csv_format
on_error= 'continue';

describe pipe employee_pipe;

alter pipe employee_pipe refresh;

select * from employee_table;

SELECT SYSTEM$PIPE_STATUS('employee_pipe');

select * from employee_table;

------even after altering the contents and
---uploading same file will not read again
--because file already read
---new file name it will read


-------------------------------------------------------------
-------------------unloading---------------------------------
-------------------------------------------------------------


list @netflix;

select * from netflix_data;

select object_construct(*) from netflix_data;


-- Step 6: Create a JSON file format for unloading
CREATE OR REPLACE FILE FORMAT json_format
    TYPE = 'JSON';


-- Step 7: Create an external stage pointing to the S3 JSON folder
CREATE OR REPLACE STAGE snowflaketos3
    URL = 's3://sumithag/json/'
    STORAGE_INTEGRATION = access_integration
    FILE_FORMAT = json_format;



-- Step 8: Unload netflix_data to S3 JSON folder
COPY INTO @snowflaketos3
FROM (
    SELECT OBJECT_CONSTRUCT(*) 
    FROM netflix_data 
)
FILE_FORMAT = (TYPE = 'JSON' compression ='none')
OVERWRITE = TRUE;



LIST @snowflaketos3;



-- 1. List the files on S3 to confirm they exist
LIST @snowflaketos3;

-- 2. Query the files directly from the stage to check the data
SELECT $1 FROM @snowflaketos3 LIMIT 5;

-- 3. Compare row counts: table vs unloaded files
SELECT COUNT(*) AS table_count FROM netflix_data;

SELECT COUNT($1) AS file_count FROM @snowflaketos3;




-------------------------------------



--offset timestamp query id 

create or replace table netflix_data1 as (
    select * from netflix_data at (offset => -60 * 2 )
);

insert into netflix_data 
select * from netflix_data1;




show tables;



ALTER TABLE netflix_data 
SET DATA_RETENTION_TIME_IN_DAYS = 30;

select sysdate() ;


delete from netflix_data ;

SELECT * FROM netflix_data
    AT(TIMESTAMP => '2026-03-27 07:08:10.313'::TIMESTAMP);


INSERT INTO netflix_data
SELECT * FROM netflix_data
BEFORE(STATEMENT => '01c34d8c-0001-95f3-000e-094e0004af3a');


select * from netflix_data;


delete from netflix_data where type ='Movie' ;
 select sysdate();


insert into netflix_data (
SELECT * FROM netflix_data
    AT(TIMESTAMP => '2026-03-27 07:04:27.157'::TIMESTAMP));

select * from netflix_data;


delete from netflix_data where type ='Movie' ;

select * from netflix_data;

select sysdate();

SELECT * FROM netflix_data
    AT(TIMESTAMP => '2026-03-27 07:04:00.157'::TIMESTAMP);


   insert into netflix_data
   SELECT * FROM netflix_data
BEFORE(STATEMENT => '01c34da3-0001-95f3-000e-094e000500a6');


select * from netflix_data;


delete from netflix_data where type ='Movie' ;

select * from netflix_data;

 create or replace table netflix_data as
 SELECT * FROM netflix_data
BEFORE(STATEMENT => '01c34dbb-0001-965d-000e-094e0004c93e');
select * from netflix_data;

-------------------


--zero copy cloning

create table netflix_data_clone clone netflix_data;

select count(*) from netflix_data_clone; 