Welcome to the Data Warehouse repository.
This project demonstrates a comprehensive data warehousing and analytics solution, from building a Data Warehouse 
to genereting actionable insights. 

--------------------
Project Overview
--------------------

This project involves:
1. Data architecture: Designing Data Warehouse with Bronze, Silver and Gold Layers.
2. ETL Pipelines: Extracting, transforming and loading data from source systems into the Data Warehouse.
3. Data modeling: Developing fact and dimension tables optimized for analitycal queries.

--------------------
Data Architecture
--------------------

The data architecrture for this project consists of Bronze, Silver and Golder Layer:

<img width="1108" height="608" alt="image" src="https://github.com/user-attachments/assets/91a34742-5b25-4a98-b83a-11d837f634c0" />

1. Bronze Layer: stores raw data as - is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. Silver Layer: includes data cleansing, standarization and normalization processes to prepare data.
3. Golden Layer: houses business - ready data modeled into star schema for reporting and analytics.

--------------------
Project Requirements
--------------------

Build the Data Warehouse using SQL Server to consolidate sales data, enabling analitical reporting and informed 
decision-making.

Specifications:
1. Data Sources: Iport Data from two source systems (ERP and CRM) provided as CSV Files.
2. Data Quality: Cleanse and resolve data quality issues.
3. Integretion: Combine both sources into a single, user friendly data model designed for analitical queries.
4. Scope: Focus on latest datasets only, historization of data not required.
5. Documentation: Provide a clear documentation.  
