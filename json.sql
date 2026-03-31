----loading json data----
----semi structured data------
--when dealing with semi structured data 
--  data type variant is important --


create database MANAGE_DB;


create schema EXTERNAL_STAGES;

CREATE OR REPLACE stage MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
     url='s3://bucketsnowflake-jsondemo';

list @jsonstage;


create table hr_data 
(raw_data  variant) ;



   copy into hr_data  
      from @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE 
      FILE_FORMAT = (type=json);

select * from hr_data;


select $1:city:: string as city  ,
        $1:first_name,
        raw_data: gender,
        $1:job.salary as salary ,
        $1:job.title as titile ,
        $1:spoken_languages[0].language 
 from hr_data ;


  select $1:city:: string as city  ,
        $1:first_name,
        raw_data: gender
 from hr_data ;


SELECT
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM hr_data  ,
LATERAL FLATTEN(input => $1:spoken_languages) hr;



SELECT
  raw_data:id:: int as id ,
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM hr_data ,
LATERAL FLATTEN(input => raw_data:spoken_languages) hr;
