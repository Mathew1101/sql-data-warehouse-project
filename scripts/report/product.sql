/*
=============================================================================================
Product Report
=============================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields sucha as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantuty sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue
		- average monthly revenue
=============================================================================================
*/

CREATE OR ALTER VIEW gold.report_products AS 

WITH cte_prod_base AS
(
-- Query retrieves basic information about products
SELECT
	fs.order_number,
	fs.order_date,
	fs.customer_key,
	fs.sales,
	fs.quantity,
	dp.product_key,
	dp.product_name,
	dp.category,
	dp.subcategory,
	dp.cost
FROM gold.fact_sales AS fs 
LEFT JOIN gold.dim_products AS dp
ON fs.product_key = dp.product_key
WHERE order_date IS NOT NULL -- Only consider valid sales dates 
),

cte_prod_aggregation AS
(
-- Query aggregates informations about products
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
FROM cte_prod_base
GROUP BY product_key, product_name, category, subcategory, cost
)


-- Final query combines all product results into one output
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(month,last_sale_date,GETDATE()) recency_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales > 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END product_segment,
	lifespan,
	total_orders,
	total_quantity,
	total_customers,
	avg_selling_price,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders 
	END AS avg_order_revenue,
	CASE
		WHEN lifespan = 0 THEN 0
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM cte_prod_aggregation
