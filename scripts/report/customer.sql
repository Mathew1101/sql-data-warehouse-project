/*
==============================================================================
Customer Report
==============================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors.

Highlights:
	1. Gathers essential fields such as names, ages and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
==============================================================================
*/

CREATE OR ALTER VIEW gold.report_customers AS 

WITH cte_cust_base AS
(
-- Query retrives basic informations about customers
SELECT
	fs.order_number,
	fs.customer_key,
	fs.product_key,
	fs.order_date,
	fs.sales,
	fs.quantity,
	dc.customer_number,
	CONCAT(dc.first_name, ' ',dc.last_name) AS customer_name,
	dc.gender,
	DATEDIFF(year,dc.birth_date,GETDATE()) AS age
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
WHERE order_date IS NOT NULL -- Only consider valid sales date 
),
cte_cust_aggregation AS
(
-- Querry aggreates informations about customers
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month,MIN(order_date),MAX(order_date)) AS lifespan 
FROM cte_cust_base
GROUP BY customer_key, customer_number, customer_name, age
)

-- Final query combines all customer results into one output
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	lifespan,
	DATEDIFF(month,last_order_date,GETDATE()) AS recency_months,
	CASE 
		WHEN total_sales >= 5000 AND lifespan >= 12 THEN 'VIP' 
		WHEN total_sales < 5000 AND lifespan > 12 THEN 'Regular'
		ELSE 'New'
	END AS customer_cat,
	CASE
		WHEN age < 18 THEN 'Under Age'
		WHEN age < 30 THEN '18+'
		WHEN age < 40 THEN '30+'
		WHEN age < 50 THEN '40+'
		WHEN age < 60 THEN '50+'
		ELSE '60+'
	END AS age_groups,
	CASE WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END avg_order_value,
	CASE WHEN lifespan = 0 THEN 0
		ELSE total_sales / lifespan
	END avg_monthly_spend
FROM cte_cust_aggregation;
