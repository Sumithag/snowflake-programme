create database json_example;

--- loaction s3://sumithag/json/


create or replace stage musical_stage
url = 's3://sumithag/json/'
file_format =(type='json');

list @musical_stage;



---- storage integration

CREATE STORAGE INTEGRATION musical_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::832767338097:role/storage_access'
  STORAGE_ALLOWED_LOCATIONS = ('s3://sumithag/json/','s3://sumithag/csv/');

  describe INTEGRATION musical_integration;


  ---user arn    arn:aws:iam::640083578061:user/externalstages/cich5d0000
---external id    

create or replace stage musical_stage
url = 's3://sumithag/json/'
storage_integration= musical_integration
file_format =(type='json');

list @musical_stage;

create or replace table musical_table
(
raw_data variant
);

copy into musical_table
from @musical_stage;


select * from musical_table;
select count(*) from musical_table;
-----o/p   10261

-----snowpipe

create or replace pipe musical_pipe
auto_ingest = true
as
copy into musical_table
from @musical_stage;

describe pipe musical_pipe;

alter pipe musical_pipe refresh;

select * from musical_table;

SELECT SYSTEM$PIPE_STATUS('musical_pipe');

alter pipe musical_pipe set pipe_execution_paused= true;
SELECT SYSTEM$PIPE_STATUS('musical_pipe');
alter pipe musical_pipe set pipe_execution_paused= false;
alter pipe musical_pipe refresh;
SELECT SYSTEM$PIPE_STATUS('musical_pipe');


----adding new files

select * from musical_table;
SELECT SYSTEM$PIPE_STATUS('musical_pipe');
select * from musical_table;




------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
----------unloading: snowflake to s3 buckets----------------
------------------------------------------------------------
------------------------------------------------------------
list @musical_stage;



select * from musical_table;