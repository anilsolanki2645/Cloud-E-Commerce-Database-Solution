------------------------------------------------------------------------------------------
                                    -- MONITORING
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
                -- [1] Create a Table to Track Task Log status
------------------------------------------------------------------------------------------

-- Create a Table to Track Task Status with Additional Columns

CREATE OR REPLACE TABLE ECOM.PUBLIC.TASK_STATUS (
    TASK_NAME STRING,
    SCHEMA_NAME STRING,
    DATABASE_NAME STRING,
    SCHEDULED_TIME TIMESTAMP_LTZ,
    COMPLETED_TIME TIMESTAMP_LTZ,
    STATUS STRING,
    STATE STRING,
    QUERY_START_TIME TIMESTAMP_LTZ,
    ERROR_CODE STRING,
    ERROR_MESSAGE STRING,
    ATTEMPT_NUMBER NUMBER,
    QUERY_TEXT STRING,
    TIMESTAMP TIMESTAMP_LTZ
);


------------------------------------------------------------------------------------------
                -- [2] Create a Stored Procedure for Status Logging data loading
------------------------------------------------------------------------------------------ 

-- Create or Replace Procedure to Update Task Status for Current Day
CREATE OR REPLACE PROCEDURE ECOM.PUBLIC.UPDATE_TASK_STATUS()
RETURNS STRING
LANGUAGE SQL
AS
'
BEGIN
    -- Clear the previous days data
    TRUNCATE TABLE ECOM.PUBLIC.TASK_STATUS;

    -- Insert the latest task statuses for the current day
    INSERT INTO ECOM.PUBLIC.TASK_STATUS (
        TASK_NAME, 
        SCHEMA_NAME, 
        DATABASE_NAME, 
        SCHEDULED_TIME, 
        COMPLETED_TIME, 
        STATUS, 
        STATE, 
        QUERY_START_TIME, 
        ERROR_CODE, 
        ERROR_MESSAGE, 
        ATTEMPT_NUMBER, 
        QUERY_TEXT, 
        TIMESTAMP
    )
    SELECT
        NAME,  -- Task name
        SCHEMA_NAME,  -- Schema name where task is defined
        DATABASE_NAME,  -- Database name where task is defined
        SCHEDULED_TIME,  -- Scheduled time of task execution
        COMPLETED_TIME,  -- Time when task execution was completed
        CASE
            WHEN STATE = ''SUCCEEDED'' THEN ''SUCCESS''
            WHEN STATE = ''FAILED'' THEN ''FAILED''
            ELSE ''UNKNOWN''
        END AS STATUS,  -- Simplified status derived from state
        STATE,  -- Actual state of the task
        QUERY_START_TIME,  -- Query start time
        ERROR_CODE,  -- Error code if task failed
        ERROR_MESSAGE,  -- Error message if task failed
        ATTEMPT_NUMBER,  -- Attempt number of the task
        QUERY_TEXT,  -- Query text executed by the task
        CURRENT_TIMESTAMP() AS TIMESTAMP  -- Timestamp of record entry
    FROM SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY
    WHERE QUERY_START_TIME >= CAST(CURRENT_DATE() AS TIMESTAMP) 
      AND QUERY_START_TIME < CAST(CURRENT_DATE() + 1 AS TIMESTAMP)
      AND DATABASE_NAME != ''SNOWFLAKE''
      AND NAME != ''TASK_ECOM_DATA_LOAD'';

    RETURN ''Task status updated for the current day'';
END;
';

-- MANUALLY CALL THE PROCEDURE UPDATE_TASK_STATUS FOR UPDATE TASK LOG DATA

CALL ECOM.PUBLIC.UPDATE_TASK_STATUS();

-- CREATE A STATUS TASK FOR EXECUTE UPDATE_TASK_STATUS PROCEDURE FOR LOG  

CREATE OR REPLACE TASK ECOM.PUBLIC.TASK_UPDATE_TASK_STATUS
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 50 16 * * * UTC'
AS   
    CALL ECOM.PUBLIC.UPDATE_TASK_STATUS(); 
    

-- CHECK DATA IS PROPER LOAD OR NOT AFTER THAT YOU CAN RESUME THE TASK

ALTER TASK ECOM.PUBLIC.TASK_UPDATE_TASK_STATUS SUSPEND;
ALTER TASK ECOM.PUBLIC.TASK_UPDATE_TASK_STATUS RESUME;

-- TRUNCATE TABLE ECOM.PUBLIC.TASK_STATUS;

SELECT * FROM ECOM.PUBLIC.TASK_STATUS;

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY;