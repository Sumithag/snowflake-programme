CREATE DATABASE VITECH_DEV ;

CREATE SCHEMA VITECH_DEV.BRONZE ;

CREATE SCHEMA VITECH_DEV.SILVER ;

CREATE SCHEMA VITECH_DEV.GOLD ;

show schemas;



----creating table at bronze schema

CREATE OR REPLACE TABLE VITECH_DEV.BRONZE.ORDERS (
    ORDER_ID NUMBER AUTOINCREMENT PRIMARY KEY,
    CUSTOMER_ID NUMBER NOT NULL,
    ORDER_DATE DATE NOT NULL,
    ORDER_STATUS VARCHAR(50) NOT NULL,
    TOTAL_AMOUNT NUMBER(12,2) NOT NULL,
    SHIPPING_ADDRESS VARCHAR(500)
) ;

SELECT * FROM VITECH_DEV.BRONZE.ORDERS ;
---query produced no results



----------------------create streams ---------------------------------
' stream in Snowflake is like a security camera for your table — it watches and records every change that happens.

What it tracks:

Inserts — new rows added
Updates — existing rows modified
Deletes — rows removed
How it works (simply):

You create a stream on a table
Someone inserts/updates/deletes rows in that table
The stream captures what changed and what kind of change it was
You read the stream to process those changes
Once consumed in a DML statement, the stream resets and starts watching for new changes';


'Three metadata columns tell you what happened:

Column	Meaning
METADATA$ACTION	INSERT or DELETE
METADATA$ISUPDATE	TRUE if it was an update (shown as DELETE + INSERT pair)
METADATA$ROW_ID	Unique ID for the row';
-------------------------------------


CREATE OR REPLACE STREAM VITECH_DEV.BRONZE.ORDERS_STREAM 
      ON TABLE VITECH_DEV.BRONZE.ORDERS APPEND_ONLY = FALSE;

SELECT * FROM VITECH_DEV.BRONZE.ORDERS_STREAM;
--- query processed no results




--SOURCE ---STREAM OBJECT --- TARGET TABLE 
CREATE OR REPLACE TABLE VITECH_DEV.SILVER.ORDERS_TRANSFORMED (
    ORDER_ID NUMBER AUTOINCREMENT PRIMARY KEY,
    CUSTOMER_ID NUMBER NOT NULL,
    ORDER_DATE DATE NOT NULL,
    ORDER_STATUS VARCHAR(50) NOT NULL,
    TOTAL_AMOUNT NUMBER(12,2) NOT NULL,
    SHIPPING_ADDRESS VARCHAR(500)
) ;


SELECT * FROM VITECH_DEV.SILVER.ORDERS_TRANSFORMED ;
---query processed no results




---create tasks 

CREATE OR REPLACE TASK VITECH_DEV.SILVER.oRDERS_TASK
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON * * * * * UTC'
  AS 
MERGE INTO VITECH_DEV.SILVER.ORDERS_TRANSFORMED AS TGT
USING VITECH_DEV.BRONZE.ORDERS_STREAM AS SRC
    ON TGT.ORDER_ID = SRC.ORDER_ID
WHEN MATCHED AND SRC.METADATA$ACTION = 'DELETE' THEN
    DELETE
WHEN MATCHED AND SRC.METADATA$ACTION = 'INSERT' THEN
    UPDATE SET
        TGT.CUSTOMER_ID = SRC.CUSTOMER_ID,
        TGT.ORDER_DATE = SRC.ORDER_DATE,
        TGT.ORDER_STATUS = SRC.ORDER_STATUS,
        TGT.TOTAL_AMOUNT = SRC.TOTAL_AMOUNT,
        TGT.SHIPPING_ADDRESS = SRC.SHIPPING_ADDRESS
WHEN NOT MATCHED AND SRC.METADATA$ACTION = 'INSERT' THEN
    INSERT (ORDER_ID, CUSTOMER_ID, ORDER_DATE, ORDER_STATUS, TOTAL_AMOUNT, SHIPPING_ADDRESS)
    VALUES (SRC.ORDER_ID, SRC.CUSTOMER_ID, SRC.ORDER_DATE, SRC.ORDER_STATUS, SRC.TOTAL_AMOUNT, SRC.SHIPPING_ADDRESS);




show tasks;
----initially tasks will be in suspended state 
---code to resume
alter task VITECH_DEV.SILVER.oRDERS_TASK resume;






----perform insert operation



INSERT INTO VITECH_DEV.BRONZE.ORDERS (CUSTOMER_ID, ORDER_DATE, ORDER_STATUS, TOTAL_AMOUNT, SHIPPING_ADDRESS)
VALUES
 ---  (101, '2026-03-25', 'Shipped', 249.99, '123 Main St, New York, NY 10001'),
    (1021, '2026-03-26', 'Processing', 89.50, '456 Oak Ave, Los Angeles, CA 90001'),
    (1031, '2026-03-27', 'Delivered', 549.00, '789 Pine Rd, Chicago, IL 60601'),
    (1041, '2026-03-28', 'Pending', 124.75, '321 Elm St, Houston, TX 77001'),
    (1051, '2026-03-31', 'Shipped', 315.20, '654 Maple Dr, Phoenix, AZ 85001');

---view in order table
    SELECT * FROM VITECH_DEV.BRONZE.ORDERS ;
    
----view the insert changes reflected in streams
    SELECT * FROM VITECH_DEV.BRONZE.ORDERS_STREAM;
    
---view insertion changes in stream automatically
--- inserted into silver layer target table
--- due to tasks
    select * from VITECH_DEV.SILVER.ORDERS_TRANSFORMED;





    -----now perform update on bronze layer source TABLE
    UPDATE VITECH_DEV.BRONZE.ORDERS SET ORDER_STATUS = 'Completed' 
    where CUSTOMER_ID = 1021 ;


--- view in source table
 SELECT * FROM VITECH_DEV.BRONZE.ORDERS ;



 ---view in STREAM
 SELECT * FROM VITECH_DEV.BRONZE.ORDERS_STREAM;
 --- here you will see two action performed for UPDATE
 --- 1) delete with metadata$isupdate=true
 ----2) insert with metadata$isupdate=true





---view in target table at silver layer
---wait for the scheduled TIME

 select * from VITECH_DEV.SILVER.ORDERS_TRANSFORMED;
 show tasks;
 





----now perform delete operation
    delete from VITECH_DEV.BRONZE.ORDERS ;


    ---view in streams
     SELECT * FROM VITECH_DEV.BRONZE.ORDERS_STREAM;


----now in target table
 select * from VITECH_DEV.SILVER.ORDERS_TRANSFORMED;