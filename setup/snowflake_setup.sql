-- ================================================
-- commerce_analytics - Snowflake Setup Script
-- Run this as ACCOUNTADMIN in Snowflake worksheet
-- ================================================

SELECT CURRENT_ACCOUNT();
SELECT CURRENT_USER();

-- Create role for dbt
CREATE ROLE IF NOT EXISTS dbt_role;
GRANT ROLE dbt_role TO ROLE ACCOUNTADMIN;

-- Create warehouse (compute engine)
CREATE WAREHOUSE IF NOT EXISTS dbt_wh
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

-- Create database
CREATE DATABASE IF NOT EXISTS commerce_analytics;

-- Create schemas (layers)
CREATE SCHEMA IF NOT EXISTS commerce_analytics.raw;
CREATE SCHEMA IF NOT EXISTS commerce_analytics.staging;
CREATE SCHEMA IF NOT EXISTS commerce_analytics.intermediate;
CREATE SCHEMA IF NOT EXISTS commerce_analytics.marts;

-- Grant permissions to dbt_role
GRANT USAGE ON WAREHOUSE dbt_wh TO ROLE dbt_role;
GRANT ALL ON DATABASE commerce_analytics TO ROLE dbt_role;
GRANT ALL ON ALL SCHEMAS IN DATABASE commerce_analytics TO ROLE dbt_role;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE commerce_analytics TO ROLE dbt_role;
GRANT ALL ON FUTURE TABLES IN DATABASE commerce_analytics TO ROLE dbt_role;

-- Grant access to Snowflake free sample data
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE_SAMPLE_DATA TO ROLE dbt_role;

-- Assign role to your user
GRANT ROLE dbt_role TO USER LEARNINGPATH;

-- Verify
SELECT CURRENT_ACCOUNT_LOCATOR(), CURRENT_REGION();
