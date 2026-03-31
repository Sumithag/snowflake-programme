create database parquet;

create schema parquet_objects;

create or replace stage parquet1
url='s3://snowflakeparquetdemo'
file_format= (type='parquet');

list @parquet1;

create or replace table parquet_data
(raw_data variant);


copy into parquet_data
from @parquet1
file_format= (type='parquet')
on_error='continue';


select * from parquet_data;

select 
raw_data:cat_id:: string as cat_id
from parquet_data;

select 
raw_data:cat_id:: string as cat_id,
raw_data:d:: int as d,
raw_data:date:: int as date,
raw_data:dept_id:: varchar(20) as dept_id,
raw_data:id:: varchar(20) as id,
raw_data:state_id:: string as state_id,
raw_data:value:: int as value
from parquet_data;