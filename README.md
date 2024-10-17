# End-to-End Cloud E-Commerce Database Solution

## Overview
The **End-to-End E-Commerce Database Solution** project is designed to integrate various aspects of e-commerce data management, focusing on the essential components of data modeling, storage, integration, ingestion, pipeline automation, monitoring, and alerting. The project utilizes Snowflake and AWS services to provide a robust solution for managing e-commerce data related to products, customers, orders, payments, shipping, and reviews.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Data Modeling](#data-modeling)
- [Data Storage](#data-storage)
- [Data Integration](#data-integration)
- [Data Ingestion](#data-ingestion)
- [Pipeline Automation](#pipeline-automation)
- [Monitoring](#monitoring)
- [Alerting](#alerting)
- [Contributing](#contributing)
- [License](#license)


## Prerequisites
- Snowflake account
- AWS account with S3 bucket access
- Basic knowledge of SQL and Snowflake architecture

## Setup
1. **AWS S3 Configuration:**
   - Log in to your AWS account.
   - Create an S3 bucket named `ecom-snowflake`.
   - Generate an Access Key and Secret Key if you haven't already.
   - Upload your CSV files for products, customers, orders, payments, shipping, and reviews to the S3 bucket.

2. **Snowflake Configuration:**
   - Replace the placeholders for `AWS_KEY_ID` and `AWS_SECRET_KEY` in the SQL script with your actual AWS credentials.
   - Execute the SQL scripts provided to create the necessary stages, file formats, procedures, tasks, and tables.

## Data Modeling
The data modeling phase defines the structure of the e-commerce database. The key entities include:
- **Products:** Details about products available for sale.
- **Customers:** Information about users who purchase products.
- **Orders:** Records of customer purchases.
- **Order Items:** Line items for each order.
- **Payments:** Transactions related to orders.
- **Shipping:** Details of shipping for orders.
- **Reviews:** Customer feedback on products.


## Data Storage
Data is stored in Snowflake in various schemas representing different domains of the e-commerce platform. The database structure is designed to allow efficient queries and reporting.

Here is just create a csv files and put it to s3.

### Example Schema Structure
- `PRODUCT_SCHEMA` (Table: `PRODUCTS`)
- `CUSTOMER_SCHEMA` (Table: `CUSTOMERS`)
- `ORDER_SCHEMA` (Table: `ORDERS`)
- `ORDER_ITEM_SCHEMA` (Table: `ORDER_ITEMS`)
- `PAYMENT_SCHEMA` (Table: `PAYMENTS`)
- `SHIPPING_SCHEMA` (Table: `SHIPPING`)
- `REVIEW_SCHEMA` (Table: `REVIEWS`)

## Data Integration
Data integration involves pulling data from various sources (in this case, CSV files stored in S3) into the Snowflake database. This includes setting up stages and file formats to facilitate data loading.

### Key Steps
- Create stages for accessing data files in S3.
- Define file formats to read CSV data correctly.

## Data Ingestion
Data ingestion is managed through stored procedures that load data from the defined stages into the respective tables in Snowflake. Each procedure handles truncation and insertion of data efficiently.

### Example Procedure
```sql
CREATE OR REPLACE PROCEDURE ECOM.PRODUCT_SCHEMA.USP_LOAD_PRODUCTS()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS
'
BEGIN
    TRUNCATE TABLE ECOM.PRODUCT_SCHEMA.PRODUCTS;

    INSERT INTO ECOM.PRODUCT_SCHEMA.PRODUCTS (PRODUCT_ID, PRODUCT_NAME, CATEGORY, PRICE, DESCRIPTION, STOCK, BRAND)
    SELECT t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7
    FROM @ECOM.PUBLIC.ECOM_DATA_LOAD
    (FILE_FORMAT => ''ECOM.PUBLIC.ECOM_CSV_FORMAT'', PATTERN => ''.*products.*[.]csv'') t;

    RETURN ''Data loaded into PRODUCTS'';
END;
'; 
```

## Pipeline Automation
Pipeline automation is achieved through the creation of tasks in Snowflake that schedule and automate the execution of data loading procedures. Tasks can run on a defined schedule or be triggered on-demand.

### Example Task
```sql
CREATE OR REPLACE TASK ECOM.PRODUCT_SCHEMA.TASK_PRODUCTS
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON * * * * * UTC'
AS
    CALL ECOM.PRODUCT_SCHEMA.USP_LOAD_PRODUCTS(); 

```

## Monitoring
Monitoring involves tracking the execution of tasks and the status of data ingestion processes. A dedicated TASK_STATUS table logs execution details, including success or failure, timestamps, and error messages.

### Example Status Table
```sql
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

```

## Alerting
Alerts are set up using AWS Simple Notification Service (SNS) to notify stakeholders of task execution results, including failures and significant events in the data pipeline.

### Example Alert Setup
Alerts can be configured to trigger based on specific conditions in the `TASK_STATUS` table. For example, if a task fails, an SNS notification can be sent to a designated email list.


## Notes
- Make sure to customize any placeholder texts and paths to match your actual project structure and requirements.
- If you have visual aids or diagrams, such as a data model image, be sure to include them for better clarity.

### Key Features:
- Each section is clearly labeled and easy to navigate.
- Code blocks are formatted for SQL to enhance readability.
- You can easily copy and paste this Markdown text into your `README.md` file.

**Important Note**: Please refer to the comments and instructions within the code to avoid errors or conflicts while working on this project.

## How to Use

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/anilsolanki2645/Cloud-E-Commerce-Database-Solution.git
   cd Cloud-E-Commerce-Database-Solution

```