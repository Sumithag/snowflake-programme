----   stored procedure  -----
--Stored procedures in Snowflake are named blocks of code that perform actions, including DDL/DML operations, control flow logic, and administrative tasks. Unlike UDFs, they can modify data and execute SQL statements.

--Key characteristics:
--Written in SQL (Snowflake Scripting), JavaScript, Python, Java, or Scala
--Can perform INSERT, UPDATE, DELETE, CREATE, etc.
--Called with CALL
--Can return a single value
--UDF vs Stored Procedure: Use a UDF when you need a reusable expression in queries (SELECT). Use a stored procedure when you need to perform actions/side effects (data manipulation, admin tasks).



CREATE OR REPLACE TABLE VITECH_DEV.PUBLIC.EMPLOYEE (
    EID INT,
    NAME VARCHAR(100),
    SALARY NUMBER(12,2),
    DEPARTMENT VARCHAR(50),
    STATUS VARCHAR(20)
);

INSERT INTO VITECH_DEV.PUBLIC.EMPLOYEE (EID, NAME, SALARY, DEPARTMENT,STATUS ) VALUES
    (1, 'Alice Johnson', 75000.00, 'Engineering','aCTIVE') ;


SELECT * FROM EMPLOYEE;



-- create store procedure  ----
CREATE OR REPLACE PROCEDURE VITECH_DEV.PUBLIC.INSERT_EMPLOYEE(
    P_EID INT,
    P_NAME STRING,
    P_SALARY NUMBER(12,2),
    P_DEPARTMENT VARCHAR(30),
    P_STATUS VARCHAR(30)
)
RETURNS STRING
LANGUAGE SQL
AS
BEGIN
    INSERT INTO VITECH_DEV.PUBLIC.EMPLOYEE (EID, NAME, SALARY, DEPARTMENT, STATUS)
        VALUES (:P_EID, :P_NAME, :P_SALARY, :P_DEPARTMENT, :P_STATUS);
    RETURN 'Row inserted successfully';
END;

SELECT * FROM EMPLOYEE;


-- call stored procedure--
CALL VITECH_DEV.PUBLIC.INSERT_EMPLOYEE(3, ' rAVI', 75000.00, 'IT', 'ACTIVE');
CALL VITECH_DEV.PUBLIC.INSERT_EMPLOYEE(2, ' sumitha', 50000.00, 'data engineer', 'ACTIVE');

SELECT * FROM EMPLOYEE;
--- additional two rows inserted ---




----

--- normally to change status to inactive we use update statement , instead of that create stored procedure with update logic 


---stored procedure created using python---
CREATE OR REPLACE PROCEDURE VITECH_DEV.PUBLIC.MARK_INACTIVE(P_EID INT)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'mark_inactive'
AS
$$
def mark_inactive(session, p_eid):
    session.sql(f"UPDATE VITECH_DEV.PUBLIC.EMPLOYEE SET STATUS = 'INACTIVE' WHERE EID = {p_eid}").collect()
    return f'Employee {p_eid} marked as INACTIVE'
$$;



CALL VITECH_DEV.PUBLIC.MARK_INACTIVE(3);


SELECT * FROM VITECH_DEV.PUBLIC.EMPLOYEE;


--- same query as above but in sql--
CREATE OR REPLACE PROCEDURE VITECH_DEV.PUBLIC.MARK_INACTIVE(P_EID INT)
RETURNS STRING
LANGUAGE SQL
AS
BEGIN
  UPDATE VITECH_DEV.PUBLIC.EMPLOYEE SET STATUS = 'INACTIVE' WHERE EID = :P_EID;
  RETURN 'Employee ' || :P_EID || ' marked as INACTIVE';
END;
---

CALL VITECH_DEV.PUBLIC.MARK_INACTIVE(3);


SELECT * FROM VITECH_DEV.PUBLIC.EMPLOYEE;
-- output updated --



----write stored procedure to delete inactive employees every day
--below is for every two minutes


CREATE OR REPLACE PROCEDURE VITECH_DEV.PUBLIC.DELETE_INACTIVE_EMPLOYEES()
RETURNS STRING
LANGUAGE SQL
AS
BEGIN
    DELETE FROM VITECH_DEV.PUBLIC.EMPLOYEE WHERE UPPER(STATUS) = 'INACTIVE';
    RETURN 'Inactive employees deleted successfully';
END;


-- schedule the procedure to run every day at 8 AM UTC using a task
CREATE OR REPLACE TASK VITECH_DEV.PUBLIC.DELETE_INACTIVE_TASK
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '2 minute'
AS
  CALL VITECH_DEV.PUBLIC.DELETE_INACTIVE_EMPLOYEES();
  

-- resume the task (tasks are created in suspended state by default)
ALTER TASK VITECH_DEV.PUBLIC.DELETE_INACTIVE_TASK RESUME;

show tasks;

select * from employee ;
