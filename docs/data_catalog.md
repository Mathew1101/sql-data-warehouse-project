------------------------------
Data Dictionary for Gold Layer
------------------------------

Overview

The Gold Layer is the business - level data representation structured to support analytical and reporting use cases.
It consist of dimension tables and fact tables for specific business metrics.

1. gold.dim_customers
   - Purpose: Stores customers details enriched with demographic and geographic data.
   - Colums:


Column name:          Data Type:           DESCRIPTION

customer_ key         INT                  Surrgate key uniquely identifing each customer record in dimension table.
customer_id           INT                  Unique numerical identifier assigned to each customer.
customer_number       NVARCHAR(50)         Alphanumerical identifier representing the customer, used for tracking and referencing.
first_name            NVARCHAR(50)         The customer's first name as record in the system.
last_name             NVARCHAR(50)         The customer's last name as record in the system.
country               NVARCHAR(50)         The country of residence of the customer (e.g. 'Australia').
marital_status        NVARCHAR(50)         The marital status of the customer (e.g. 'Married', 'Single').
gender                NVARCHAR(50)         The gender of the customer (e.g. 'Female', 'Male', 'n/a').
birthday              DATE                 The date of birth of the customer, formated as YYYY-MM-DD (e.g. 1983-11-04).
create_date           DATE                 The date and time when the customer record was created in the system.

2. gold.dim_products
   - Purpose: Provides information about the products and their atributes.
   - Columns:


Column name:          Data Type:           DESCRIPTION

product_ key          INT                  Surrgate key uniquely identifing each product record in dimension table.
product_id            INT                  A unique identifier assigned to the product for internal tracking and referencing.
product_number        NVARCHAR(50)         A structured alphanumerical identifier representing the product, used for categorization or inventory.
product_name          NVARCHAR(50)         Descriptive name of the product, including details such as type, color and size.
category_id           NVARCHAR(50)         A unique identifier for the product's category, linking to it's high level classification.
category              NVARCHAR(50)         The broader classification of the product.
subcategory           NVARCHAR(50)         A more detailed classification of the product within the category.
cost                  NVARCHAR(50)         The cost or base price of the product.
maintenance           INT                  Indicates whether the product requires maintenance (e.g. 'Yes', 'No').
product_line          NVARCHAR(50)         The specific product line or seires to which the product belongs (e.g. 'Road', 'Mountain').
start_date            DATE                 The date when the product became avaible for sale or use.

3. gold.fact_sales
   - Purpose: Stores transactional sales data for analytical purposes.
   - Columns:


order_number          NVARCHAR(50)         A unique identifier for each sales order (e.g. 'SO54496').
product_ key          INT                  Surrgate key linking the order to the product dimension table.
customer_key          INT                  Surrgate key linking the order to the customer dimension table.
order_date            DATE                 The date when the order was placed.
shipping_date         DATE                 The date when the order was shipped to the customer.
due_date              DATE                 The date when the order payment was due.
sales                 INT                  The total monetary value of the sale.
quantity              INT                  The number of units of the product ordered.
price                 INT                  The price per unit of the product.
