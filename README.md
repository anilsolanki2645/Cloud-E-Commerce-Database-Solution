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
