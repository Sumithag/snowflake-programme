create database tabletypes;


----permanent table-----

'This is a permanent table. It's the default type when you don't specify TEMPORARY, TRANSIENT, or VOLATILE.

Key characteristics of permanent tables in Snowflake:

Persists until explicitly dropped
Supports Time Travel (up to 90 days on Enterprise edition)
Supports Fail-safe (7 days of additional recovery)
Incurs storage costs for both Time Travel and Fail-safe';

create table student
(
id int,
name varchar(20),
address varchar(20)
);
---kind---table---

-----transient table type----

'Transient tables persist until explicitly dropped and are visible to all users with privileges.
They support Time Travel for up to 1 day only (vs 90 days for permanent).
No Fail-safe period — reducing storage costs.
Ideal for intermediate/staging data that can be recreated if lost.';

create transient table teachers
(
id int,
address varchar(20),
name varchar(20)
);
---kind---transient---

'trying to create transient table with permanent table name
create transient table student same as permanent table name';
(
id int,
name varchar(20),
address varchar(20)
);
'error- object already exists because 
cannot create name with same as permanent table';



---temporary table---

'A temporary table is the most short-lived table type in Snowflake.

Key characteristics:

Session-scoped — exists only for the duration of your current session; automatically dropped when the session ends
Only visible to the user/session that created it — other users cannot see or access it
Supports Time Travel up to 1 day only
No Fail-safe period
Ideal for scratch work, intermediate calculations, or temporary staging within a session';

create temporary table hod 
(
id int,
name varchar(20),
address varchar(20)
);
--- output---kind---TEMPORARY 

' create table name same as permanent table';

create temporary table student
(
id int,
name varchar(20),
address varchar(20)
);
'successfully created';
'a temporary table takes precedence over a permanent (or transient) table with the same name within the same session.

Here's what happens:

The temporary table student is created alongside the permanent table student — it doesn't replace or drop it
For the rest of your session, any reference to student will resolve to the temporary table (it "shadows" the permanent one)
The permanent table still exists but is hidden/inaccessible until the session ends or the temporary table is dropped
Once your session ends, the temporary table is automatically dropped, and the permanent table becomes accessible again';

insert into student values 
(
1,'sumitha','budigere cross'
);
insert into student values
(
2,'sujatha','rm nagar'
);

select * from student;
' here the priority was given to temporary table,so all datas was inserted 
inserted into temporary table';
-----
'perform drop explicitly or else temporary table is dropped automatically 
when the session ends';
-----

drop table student;
'termporary table is dropped';

select * from student;
' query produced no results';
'we are still able to access it because its permanemt it 
and it did not show any inserted data is becasue
its permanent table and priority was given to temporary
from now on priority is on perment table';

--------
show tables;




----external table-


'Read-only — you cannot INSERT, UPDATE, or DELETE
Data stays in your cloud storage (S3, Azure, GCS)
Slower than native Snowflake tables (data isn't optimized internally)
Includes a built-in VALUE column (VARIANT type) for all data
Supports auto-refresh of metadata when new files arrive';




CREATE OR REPLACE STAGE TABLETYPES.PUBLIC.loan_payment_stage
  URL = 's3://bucketsnowflakes3/'
  FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1);


  list @tabletypes.public.loan_payment_stage;

CREATE OR REPLACE EXTERNAL TABLE TABLETYPES.PUBLIC.LOAN_PAYMENT_EXT (
  Loan_ID STRING AS (VALUE:c1::STRING),
  loan_status STRING AS (VALUE:c2::STRING),
  past_due_days STRING AS (VALUE:c3::STRING),
  age STRING AS (VALUE:c4::STRING)
)
WITH LOCATION = @TABLETYPES.PUBLIC.loan_payment_stage
PATTERN = '.*Loan_payments_data.csv'
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1);

ALTER EXTERNAL TABLE TABLETYPES.PUBLIC.LOAN_PAYMENT_EXT REFRESH;


'not performing any copy into ie loading data from
s3 because its read only format, we will not load any data from s3 buckets';

SELECT * FROM TABLETYPES.PUBLIC.LOAN_PAYMENT_EXT;

-----create for orders

CREATE OR REPLACE EXTERNAL TABLE tabletypes.PUBLIC.ORDER_DETAILS_EXT (
  ORDER_ID VARCHAR AS (value:c1::VARCHAR),
  AMOUNT VARCHAR AS (value:c2::VARCHAR),
  PROFIT VARCHAR AS (value:c3::VARCHAR),
  QUANTITY VARCHAR AS (value:c4::VARCHAR),
  CATEGORY VARCHAR AS (value:c5::VARCHAR),
  SUB_CATEGORY VARCHAR AS (value:c6::VARCHAR)
)
WITH LOCATION = @tabletypes.public.loan_payment_stage
PATTERN = '.*OrderDetails.*'
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1);

SELECT * FROM tabletypes.PUBLIC.ORDER_DETAILS_EXT LIMIT 10;


----dynamic table type------

'In simple terms: you tell Snowflake what you want the data to look like (via a SELECT query) and how fresh it should be (via target lag), and Snowflake takes care of the when and how to refresh it.

It replaces the traditional pattern of streams + tasks + merge statements with a single declarative object.';

select * from netflix_data;

CREATE OR REPLACE DYNAMIC TABLE NETFLIX_DATA_DYN
  TARGET_LAG = '1 minutes'
  WAREHOUSE = COMPUTE_WH
  REFRESH_MODE = AUTO
  INITIALIZE = ON_CREATE
  AS
    SELECT
      SHOW_ID,
      TITLE,
      DIRECTOR,
      COUNTRY
    FROM NETFLIX_DATA;


   select * from NETFLIX_DATA_DYN ;
--7230 

delete from netflix_data where lower(country) like '%taiwan%';

delete from netflix_data where lower(country) like '%india%';

select * from netflix_data;
select * from netflix_data_dyn;









---------tasks-----
'A Task in Snowflake is a scheduled object that automatically executes a SQL statement on a defined schedule or in response to other tasks completing.';

create table netfilx_final as (
   select * from  NETFLIX_DATA_DYN 
   ) ;


   select * from netfilx_final;

--- create task to refresh netfilx_final every 2 minutes

CREATE OR REPLACE TASK NETFLIX_REFRESH_TASK
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '2 MINUTES'
  AS
    INSERT OVERWRITE INTO NETFILX_FINAL
    SELECT * FROM NETFLIX_DATA_DYN;

ALTER TASK NETFLIX_REFRESH_TASK RESUME;

SHOW TASKS IN SCHEMA manage_db.external_stages;
--wait for two minutes---
select * from netfilx_final;