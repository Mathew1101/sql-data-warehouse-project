/*
=======================================================================================================
Create Database and Schemas
=======================================================================================================

Script Purpose:
  This script creates a new database named 'DataWarehoseProject' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
  within the database: 'bronze', 'silver', 'gold'.

WARNING:
  Running this script will drop the entire 'DataWarehoseProject' databse if it exists.
  ALL data in the database will be pernamently deleted - proceed with caution 
  and ensure you have proper backups before running this script.
=======================================================================================================
*/

USE MASTER;
GO

-- Drop and recreate the 'DataWarehoseProject' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehoseProject')
BEGIN
  ALTER DATABASE DataWarehoseProject SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehoseProject;
END;
GO

-- Create the 'DataWarehoseProject' database  
CREATE DATABASE DataWarehoseProject;
GO
  
USE DataWarehouseProject;
GO
  
--Create Schemas
CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
