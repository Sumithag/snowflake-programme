
create database streams;


create schema bronze;
create schema silver;
create schema gold;


show schemas;


CREATE OR REPLACE TABLE BRONZE.ORDERS (
    ORDER_ID NUMBER AUTOINCREMENT PRIMARY KEY,
    CUSTOMER_ID NUMBER NOT NULL,
    ORDER_DATE DATE NOT NULL,
    ORDER_STATUS VARCHAR(50) NOT NULL,
    TOTAL_AMOUNT NUMBER(12,2) NOT NULL,
    SHIPPING_ADDRESS VARCHAR(500)
) ;


create or replace stream bronzestream
on table bronze.orders;


CREATE OR REPLACE TABLE silver.ORDERS (
    ORDER_ID NUMBER AUTOINCREMENT PRIMARY KEY,
    CUSTOMER_ID NUMBER NOT NULL,
    ORDER_DATE DATE NOT NULL,
    ORDER_STATUS VARCHAR(50) NOT NULL,
    TOTAL_AMOUNT NUMBER(12,2) NOT NULL,
    SHIPPING_ADDRESS VARCHAR(500)
) ;


CREATE OR REPLACE TASK bronze_to_silver_task
    WAREHOUSE = 'COMPUTE_WH'
    SCHEDULE = '1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('bronzestream')
    AS
        MERGE INTO silver.ORDERS AS tgt
        USING (
            SELECT ORDER_ID, CUSTOMER_ID, ORDER_DATE, ORDER_STATUS, TOTAL_AMOUNT, SHIPPING_ADDRESS,
                   METADATA$ACTION, METADATA$ISUPDATE
            FROM bronzestream
        ) AS src
        ON tgt.ORDER_ID = src.ORDER_ID
        WHEN MATCHED AND src.METADATA$ACTION = 'DELETE' AND src.METADATA$ISUPDATE = FALSE THEN
            DELETE
        WHEN MATCHED AND src.METADATA$ACTION = 'INSERT' AND src.METADATA$ISUPDATE = TRUE THEN
            UPDATE SET
                tgt.CUSTOMER_ID = src.CUSTOMER_ID,
                tgt.ORDER_DATE = src.ORDER_DATE,
                tgt.ORDER_STATUS = src.ORDER_STATUS,
                tgt.TOTAL_AMOUNT = src.TOTAL_AMOUNT,
                tgt.SHIPPING_ADDRESS = src.SHIPPING_ADDRESS
        WHEN NOT MATCHED AND src.METADATA$ACTION = 'INSERT' AND src.METADATA$ISUPDATE = FALSE THEN
            INSERT (ORDER_ID, CUSTOMER_ID, ORDER_DATE, ORDER_STATUS, TOTAL_AMOUNT, SHIPPING_ADDRESS)
            VALUES (src.ORDER_ID, src.CUSTOMER_ID, src.ORDER_DATE, src.ORDER_STATUS, src.TOTAL_AMOUNT, src.SHIPPING_ADDRESS);

            

ALTER TASK bronze_to_silver_task RESUME;



INSERT INTO BRONZE.ORDERS (CUSTOMER_ID, ORDER_DATE, ORDER_STATUS, TOTAL_AMOUNT, SHIPPING_ADDRESS)
VALUES
  (101, '2026-03-25', 'Shipped', 249.99, '123 Main St, New York, NY 10001'),
    (1021, '2026-03-26', 'Processing', 89.50, '456 Oak Ave, Los Angeles, CA 90001'),
    (1031, '2026-03-27', 'Delivered', 549.00, '789 Pine Rd, Chicago, IL 60601'),
    (1041, '2026-03-28', 'Pending', 124.75, '321 Elm St, Houston, TX 77001'),
    (1051, '2026-03-31', 'Shipped', 315.20, '654 Maple Dr, Phoenix, AZ 85001');

select * from bronze.orders;


select * from bronzestream;


select * from silver.ORDERS;


UPDATE BRONZE.ORDERS SET ORDER_STATUS = 'Completed' 
    where CUSTOMER_ID = 1021 ;

select * from bronzestream;


select * from silver.ORDERS;




----------------views-------------------------------

---views are virtual table, 
---read only access ie one cannot perform any insert,update or delete on views
---views are database objects , containing select statement built on one or more tables
---changes made in original table is automatically reflected / refreshed in the views 
---its supports joins,sub-queries
---there are three types
---1 normal views 
---2 secured views
---3 materialized views




------ views in gold schema----

select * from silver.ORDERS;


create or replace view gold.order_view
as 
select customer_id ,order_date, 
order_status from silver.orders;


select * from gold.order_view;



---any changes like insertion,deletion,updation is automatically refreshed in the views , doesnt require any manual query
-------update the data in order at bronze level-----

UPDATE BRONZE.ORDERS SET ORDER_STATUS = 'shipped' 
    where CUSTOMER_ID = 1041 ;
    
---execution or data flow---
---checking if data updated in source table---
select * from bronze.orders;

---checking if changes reflected in streams---
select * from bronzestream;

---checking if tasks automaticall read the changes and reflected in table--
select * from silver.ORDERS;

---checking if the update is refreshed automatically in view---
select * from gold.order_view;




---trying to change data directly in views table---

delete from order_view where customer_id =1041;

---error :SQL compilation error: DELETE statement's target must be a table;same goes for insertion and updation, ie views provide read only access

---so basically the view created above is normal view--




---2 secured view
---Secure views hide the view's SQL definition and internal logic from users who query it but don't own it.


---below is sql view definition
create or replace secure view gold.sec_order_view
as 
select customer_id ,order_date, 
order_status from silver.orders;
---this is hidden in the show views statement output---

select * from gold.sec_order_view;

show views;
---output---
---ORDER_VIEW:    is_secure:false  is_materialized:false
---SEC_ORDER_VIEW:  is_secure:true  is_materialized:false




---3 materialized views---
--query performance is improved
--Single table only — must query from one base table
--Limited SQL — no joins, limited aggregate funtion and window functions, UDFs, HAVING, ORDER BY, LIMIT, or nested views allowed
--When to use: When you have expensive aggregations or filters on large tables that are queried frequently but the underlying data changes infrequently.

-- Remove caching just to have a fair test -- Part 1

---ALTER SESSION SET USE_CACHED_RESULT=FALSE; -- disable global caching
ALTER warehouse compute_wh suspend;
ALTER warehouse compute_wh resume;



-- Prepare table
CREATE OR REPLACE TRANSIENT DATABASE ORDERS;

CREATE OR REPLACE SCHEMA TPCH_SF100;



---creating a table and inserting data , already available in snowflake
CREATE OR REPLACE TABLE TPCH_SF100.ORDERS AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;

---error because its is impported share
CREATE OR REPLACE TABLE TPCH_SF100.ORDERS 
CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;

SELECT * FROM ORDERS LIMIT 100;




---taking too much of time because million of records available
SELECT * FROM ORDERS ;


-- Example statement view -- 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);




-- Create materialized view
CREATE OR REPLACE MATERIALIZED VIEW ORDERS_MV
AS 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE);


SHOW  VIEWS;
---is_materialized :true


-- Query view
SELECT * FROM ORDERS_MV
ORDER BY YEAR;



-- UPDATE or DELETE values
UPDATE ORDERS
SET O_CLERK='Clerk#99900000' 
WHERE O_ORDERDATE='1992-01-01';





   -- Test updated data --
-- Example statement view -- 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);



-- Query view
SELECT * FROM ORDERS_MV
ORDER BY YEAR;


SHOW MATERIALIZED VIEWS;



--------------------------------------
-------------------------






--    cache   --
--Caching in Snowflake stores query results so repeated identical queries return instantly without re-executing.


--Three cache layers:

--Result Cache — If the same query runs again and the underlying data hasn't changed, Snowflake returns the cached result (free, no warehouse needed). Lasts 24 hours.

--Local Disk Cache (SSD) — Warehouse nodes cache table data on local SSD. Helps when querying the same data repeatedly on the same warehouse.

--Remote Disk Cache — Data cached in the shared storage layer, slower than local but faster than a full scan.






ALTER SESSION SET USE_CACHED_RESULT=true; 



SELECT * FROM STREAMS.BRONZE.ORDERS;

select * FROM STREAMS.BRONZE.ORDERS where order_id = 5;
---click on query id on query history, then query profile you will see the table scan has happedned then result is produced



---now run again--
select * FROM STREAMS.BRONZE.ORDERS where order_id = 5;
--- query profile you will see query result reuse


--suppose you changed data in base table ie orders and then ran the query it will go to table scan ,second time it will be fetched from result cache




--IF THE SAME QUERY RUNS AT EVERY TIME IT WILL GO TO CACHE 
--UNTILL THE TABLE DATA IS NOT CHANGED 
--cached data will be avialble in 24 hrs 



select COUNT(*)  FROM STREAMS.BRONZE.ORDERS;
---metadata based result cache
---second time if you run, then fom query result cache 