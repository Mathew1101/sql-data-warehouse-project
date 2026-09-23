Welcome to the Data Warehouse Project repository.

An end-to-end SQL Server data warehouse project that integrates CRM and ERP source data, processes it through Bronze, Silver and Gold layers, and exposes business-ready datasets for analytics and reporting.

# Project Overview

The project demonstrates a practical data engineering workflow:

1. **Data ingestion** – load CRM and ERP CSV files into the Bronze layer.
2. **Data cleansing and transformation** – standardize, validate and enrich data in the Silver layer.
3. **Data modeling** – integrate the cleansed data into a Gold-layer star schema.
4. **Data quality** – run checks for duplicates, NULLs, invalid values and referential integrity.
5. **Analytics and reporting** – create customer and product reporting views from the Gold layer.

## Data Architecture

The warehouse follows a three-layer architecture:

<img width="1108" height="608" alt="image" src="https://github.com/user-attachments/assets/91a34742-5b25-4a98-b83a-11d837f634c0" />

### Bronze layer

The Bronze layer stores source data with minimal transformation. CSV files from CRM and ERP systems are loaded into SQL Server tables using `BULK INSERT`.

### Silver layer

The Silver layer cleans and standardizes the Bronze data. Transformations include:

- trimming text values
- standardizing marital status, gender, country and product-line values
- removing source-system prefixes from customer identifiers
- handling invalid and future dates
- calculating missing sales values
- correcting invalid prices
- removing duplicate customer records by keeping the latest record
- deriving product validity periods

### Gold layer

The Gold layer contains business-ready views organized as a star schema. The views integrate CRM and ERP information and expose dimensions and a sales fact for analytical queries.

## Source Data

The repository includes the source CSV files required by the project:

| Source | File | Purpose |
|---|---|---|
| CRM | `cust_info.csv` | Customer master data |
| CRM | `prd_info.csv` | Product master data |
| CRM | `sales_details.csv` | Sales transactions |
| ERP | `CUST_AZ12.csv` | Customer birth date and gender |
| ERP | `LOC_A101.csv` | Customer location |
| ERP | `PX_CAT_G1V2.csv` | Product category and maintenance information |

## Setup and Execution

### Requirements

- SQL Server 2019+ (or a compatible SQL Server version supporting the T-SQL used by the project)
- SQL Server Management Studio (SSMS) or another SQL Server client
- Permission to create/drop databases and schemas
- The repository cloned or downloaded locally

### 1. Download or clone the repository

```bash
git clone https://github.com/Mathew1101/sql-data-warehouse-project.git
cd sql-data-warehouse-project
```

### 2. Configure the CSV file paths

The Bronze load procedure uses SQL Server `BULK INSERT`. Before running it, open:

```text
scripts/bronze/proc_load_bronze.sql
```

and replace the `C:\Users\...` paths with the absolute path to the repository's `datasets` directory on your machine.

For example:

```text
C:\path\to\sql-data-warehouse-project\datasets\source_crm\cust_info.csv
C:\path\to\sql-data-warehouse-project\datasets\source_crm\prd_info.csv
C:\path\to\sql-data-warehouse-project\datasets\source_crm\sales_details.csv
C:\path\to\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv
C:\path\to\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv
C:\path\to\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv
```

**Important:** `BULK INSERT` reads files from the SQL Server host. If SQL Server is running on another machine or in a container, that host must be able to access the CSV files and the SQL Server service account must have appropriate file-system permissions.

### 3. Create a fresh database

Open `scripts/init_database.sql` in SSMS and execute it.

This script:

- drops `DataWarehouseProject` if it already exists
- creates a new `DataWarehouseProject` database
- creates the `bronze`, `silver` and `gold` schemas

> **Warning:** the initialization script deletes the existing `DataWarehouseProject` database. Do not run it against a database containing data you need to keep.

### 4. Create Bronze tables and load source data

Execute:

```text
scripts/bronze/ddl_bronze.sql
scripts/bronze/proc_load_bronze.sql
```

Then run:

```sql
EXEC bronze.load_bronze;
```

You should see successful load messages for three CRM tables and three ERP tables.

### 5. Create Silver tables and run the Silver ETL

Execute:

```text
scripts/silver/ddl_silver.sql
scripts/silver/proc_load_silver.sql
```

Then run:

```sql
EXEC silver.load_silver;
```

The Silver procedure cleans and transforms the Bronze data before loading the Silver tables.

### 6. Create the Gold layer

Execute:

```text
scripts/gold/ddl_gold.sql
```

This creates:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

### 7. Run data-quality checks

Execute:

```text
scripts/tests/quality_checks_silver.sql
scripts/tests/quality_checks_gold.sql
```

In this repository the test files are stored under `tests/`, so use:

```text
tests/quality_checks_silver.sql
tests/quality_checks_gold.sql
```

Review the result sets and investigate any rows returned by checks that are intended to identify data-quality problems.

### 8. Create reporting views

Execute:

```text
scripts/report/customer.sql
scripts/report/product.sql
```

This creates:

- `gold.report_customers`
- `gold.report_products`

Example query:

```sql
SELECT *
FROM gold.report_customers;

SELECT *
FROM gold.report_products;
```

## End-to-End Execution Order

For a clean installation, execute the scripts in this order:

```text
1. scripts/init_database.sql
2. scripts/bronze/ddl_bronze.sql
3. scripts/bronze/proc_load_bronze.sql
4. EXEC bronze.load_bronze
5. scripts/silver/ddl_silver.sql
6. scripts/silver/proc_load_silver.sql
7. EXEC silver.load_silver
8. scripts/gold/ddl_gold.sql
9. tests/quality_checks_silver.sql
10. tests/quality_checks_gold.sql
11. scripts/report/customer.sql
12. scripts/report/product.sql
```

## Data Quality

The project includes checks covering areas such as:

- duplicate primary/business keys
- NULL values in required keys
- unwanted whitespace
- standardized categorical values
- invalid dates
- sales/quantity/price consistency
- Gold-layer uniqueness
- fact-to-dimension connectivity

## Analytics and Reporting

The reporting layer provides customer- and product-level KPIs, including:

- total orders
- total sales
- total quantity
- total products/customers
- customer recency
- customer lifespan
- average order value
- average monthly spend
- product recency
- average selling price
- average order revenue
- average monthly revenue

## Scope and Limitations

- The project uses the latest available source records and does not implement historical SCD tracking.
- Bronze ingestion currently relies on local file paths configured in `proc_load_bronze.sql`.
- The Gold layer is implemented as views rather than persisted dimension and fact tables.
- Surrogate keys in the Gold dimension views are generated dynamically with `ROW_NUMBER()`.
