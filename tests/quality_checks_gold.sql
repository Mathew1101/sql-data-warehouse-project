/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepencies found during the checks.
================================================================================
*/

--------------------------------
-- Checking 'gold.dim_customers'
--------------------------------

-- Check Uniqueness of Customers Key in gold.dim_customers
-- Expectation : No result

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

--------------------------------
-- Checking 'gold.dim_products'
--------------------------------

-- Check for Uniqueness of Product Keys in gold.dim_products
-- Expectation : No result

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY  product_key
HAVING COUNT(*) > 1;

--------------------------------
-- Checking 'gold.fact_sales'
--------------------------------

-- Check connectivity between fact table and dimensions

SELECT
	  *
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key 
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key 
WHERE c.customer_key IS NULL OR p.product_key IS NULL
