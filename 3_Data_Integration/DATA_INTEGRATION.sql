------------------------------------------------------------------------------------------
                                    -- DATA INTEGRATION
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
                            -- Create a Common Stage for AWS S3:
------------------------------------------------------------------------------------------

/* Important Queries
select GET_DDL('FILE_FORMAT','MY_CSV_FORMAT');
*/


-- Create a Stage for S3 Data Loading
-- NOTE : Please Change AWS_KEY_ID and AWS_SECRET_KEY

CREATE STAGE ECOM.PUBLIC.ECOM_DATA_LOAD 
    URL = 's3://ecom-snowflake/'
    CREDENTIALS = ( AWS_KEY_ID = 'KFGRDTSHFC' AWS_SECRET_KEY = 'DSANDJSNDJS+HSDHHSBDHSAB/JSKDSJBFJ' ) 
    DIRECTORY = ( ENABLE = true AUTO_REFRESH = true ) 
    COMMENT = 'All Latest Data File are Comming Daily Basis';