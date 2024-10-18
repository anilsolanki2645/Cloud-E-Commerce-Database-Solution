# Install the required libraries
!pip install snowflake-connector-python boto3

import os
import boto3
import snowflake.connector

# AWS credentials (replace with your credentials or configure AWS CLI on your local machine)
AWS_ACCESS_KEY = 'HELLOKEY'  # Avoid hardcoding credentials in production
AWS_SECRET_KEY = 'mwkpizMInK+HELLOSECRETE/KEY'
REGION_NAME = 'us-east-1'

# Snowflake connection details (replace with your actual credentials)
SNOWFLAKE_USER = 'USERNAME'
SNOWFLAKE_PASSWORD = 'PASSWORD'
SNOWFLAKE_ACCOUNT = 'bk82645.ap-southeast-1' # MAKE SURE THIS IS CORRECT
SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
SNOWFLAKE_DATABASE = 'COLLEGE'
SNOWFLAKE_SCHEMA = 'PUBLIC'
SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:AWS_ACC_ID:College-SNS'

# Initialize the SNS client
sns_client = boto3.client(
    'sns',
    aws_access_key_id=AWS_ACCESS_KEY,
    aws_secret_access_key=AWS_SECRET_KEY,
    region_name=REGION_NAME
)

# FUNCTION TO FETCH DETAILS FROM SNOWFLAKE
def check_task_status():
    # Connect to Snowflake
    conn = snowflake.connector.connect(
        user=SNOWFLAKE_USER,
        password=SNOWFLAKE_PASSWORD,
        account=SNOWFLAKE_ACCOUNT,
        warehouse=SNOWFLAKE_WAREHOUSE,
        database=SNOWFLAKE_DATABASE,
        schema=SNOWFLAKE_SCHEMA,
        authenticator='snowflake',
        client_session_keep_alive=True,  # Keeps the session alive, helpful for longer operations
        retry_attempts=3
    )

    try:
        # Query to check the status from TASK_STATUS table
        query = """
        SELECT TASK_NAME, SCHEMA_NAME, DATABASE_NAME, STATUS, ERROR_MESSAGE, QUERY_TEXT
        FROM ECOM.PUBLIC.TASK_STATUS;
        """

        cursor = conn.cursor()
        cursor.execute(query)
        results = cursor.fetchall()

        # Check the fetched results and send alerts based on specific conditions
        # Example condition: Check if the 'STATUS' column has 'FAILED' or any other failure indicator
        for row in results:
            # Modify based on your table's structure and the condition you want to monitor
            TASK_NAME, SCHEMA_NAME, DATABASE_NAME, STATUS, ERROR_MESSAGE, QUERY_TEXT = row  # Example row structure

            if STATUS == 'FAILED':  # Adjust condition based on your table structure
                message = (
                    f"Task Failure Alert :                   [1] "                                                                                                                                                                                                   
                    f"TASK_NAME : {TASK_NAME}                [2] "                                                                                                                                                                                                 
                    f"SCHEMA_NAME : {SCHEMA_NAME}            [3] "                                                                                                                                                                                                 
                    f"DATABASE_NAME : {DATABASE_NAME}        [4] "                                                                                                                                                                                                   
                    f"STATUS : {STATUS}                      [5] "                                                                                                                                                                                                       
                    f"ERROR_MESSAGE : {ERROR_MESSAGE}        [5] "                                                                                                        
                    f"QUERY_TEXT : {QUERY_TEXT}              "                                                                                                                                                                                        
                )
                print(f"Failures detected for task: {TASK_NAME}")
                send_alert(message)
            else:
                print(f"No failures detected for task: {TASK_NAME}")

    except Exception as e:
        print(f"An error occurred: {str(e)}")
    finally:
        cursor.close()
        conn.close()

# FUNCTION TO SEND ALERT
def send_alert(message):
    try:
        response = sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=message,
            Subject='Snowflake Task Status Alert'
        )
        print(f"Alert sent! Message ID: {response['MessageId']}")
    except Exception as e:
        print(f"Failed to send alert: {str(e)}")

#CALL THE FUNCTION
check_task_status()