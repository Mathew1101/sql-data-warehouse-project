-------------------
General Principles
-------------------

1. Naming Conventions: Use snake_case with lowercase letters and underscore (_) to separate words.
2. Language: Use english for all names.
3. Avoid Resered Words: Do not use SQL reserved words as object names.

-------------------------
Table Naming Conventions
-------------------------

Bronze Rules
1. All names must start with the source system name and table names must match their original names without renaming.
2. [sourcesystem]_[entity]
    - [sourcesystem]: Name of the source system (e.g. cre, erp).
    - [entity]: Exact table name from source system.
    - Example: crm_customer_info -> Customer information from the CRM system.

Silver Rules
1. All names must start with the source system name and table names must match their original names without renaming
2. [source_system]_[entity]
    - [sourcesystem]: Name of the source system (e.g. cre, erp).
    - [entity]: Exact table name from source system.
    - Example: crm_customer_info -> Customer information from the CRM system.

Gold Rules
1. All names must use meaningful, business - aligned names for tables, starting with category prefix.
2. [category]_[entity]
    - [category]: Describes the role of the table, such as dim (dimension table), fact (fact table) or agg (aggregated table).
    - [entity]: Descriptive name of the table, aligned with the business domain (e.g. customers, products, sales).
    - Example: dim_customers -> Dimension table for customer data.

Surrogate Keys
1. All primary keys in dimension tables must use the suffix '_key'. 
2. [table_name]_key
    - [table_name]: Refers to the name of the table or entity the key belongs to.
    - Example: customer_key -> Surrogate key in the dim_customers table.

Technical Columns
1. All technical columns must start with 'dwh_' prefix, followed by a descriptive name indicating the column's purpose.
2. dwh_[column_name]
    - [column_name]: Descriptive name indicating the column's purpose.
    - Example: dwh_load_data -> System - generated column used to store the data when the record was loaded.

Stored Procedure:
1. All stored procedures used for loading data must follow the naming pattern 'load_<layer>'.
    - [layer]: Represents the layer being loaded, such as  'bronze', 'silver', 'gold'.
    - Example: load_silver -> Procedure truncates 'silver' tables and inserts transformed and cleansed data from 'bronze' to 'silver'.
