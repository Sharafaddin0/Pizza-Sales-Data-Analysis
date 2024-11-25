-- Create a database first
CREATE DATABASE IF NOT EXISTS pizza_sales_db;

-- Import .csv file directly from 'Table Data Import Wizard'

-- Convert order_date column into `date` format
UPDATE pizza_sales_db.sales_table
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y')
WHERE order_date NOT LIKE '%-%-%';

-- ------------------------------------------------------------------------------------------------------ --
-- ----------------------------------------KPI's Requirements-------------------------------------------- --
-- ------------------------------------------------------------------------------------------------------ --

-- 1. Total Revenue
SELECT ROUND(SUM(total_price)) AS total_revenue
FROM pizza_sales_db.sales_table;

-- 2. Average Order Value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS avg_order 
FROM pizza_sales_db.sales_table;

-- 3. Total Pizzas Sold	
SELECT COUNT(quantity) AS tot_num_pizza
FROM pizza_sales_db.sales_table;

-- 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_db.sales_table;

-- 5. Average Pizzas per Order
SELECT CAST(SUM(quantity) AS DECIMAL(10, 2)) /
	CAST(COUNT(DISTINCT order_id) AS DECIMAL(10, 2)) AS avg_pizza_per_order
FROM pizza_sales_db.sales_table;

-- ------------------------------------------------------------------------------------------------------ --
-- ----------------------------------------CHART's Requirements-------------------------------------------- --
-- ------------------------------------------------------------------------------------------------------ --

-- 1. Daily Trend for Total Orders
SELECT dayname(order_date) AS order_day,
	COUNT(order_id) AS num_of_order
FROM pizza_sales_db.sales_table
GROUP BY dayname(order_date);

-- 2. Hourly Trend for Total Orders
SELECT hour(order_time) AS order_hours,
	COUNT(order_id) AS num_of_orders
FROM pizza_sales_db.sales_table
GROUP BY hour(order_time)
ORDER BY hour(order_time);

-- 3. Percentage of Sales by Pizza Category
SELECT pizza_category,
	CAST(SUM(total_price) AS DECIMAL(10, 2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (
    SELECT SUM(total_price)
    FROM pizza_sales_db.sales_table) AS DECIMAL(10, 2)) AS pct_sales
FROM pizza_sales_db.sales_table
GROUP BY pizza_category;

-- 4. Percentage of Sales by Pizza Size
SELECT pizza_size,
	CAST(SUM(total_price) AS DECIMAL(10, 2)) AS total_revenue,
    CAST(SUM(total_price) * 100 /(
    SELECT SUM(total_price)
    FROM pizza_sales_db.sales_table) AS DECIMAL(10, 2)) AS pct_sales 
FROM pizza_sales_db.sales_table
GROUP BY pizza_size;
	
-- 5. Total Pizzas Sold by Pizza Category on February 2015
SELECT pizza_category,
	SUM(quantity) AS total_sold
FROM pizza_sales_db.sales_table
WHERE month(order_date) = 2
GROUP BY pizza_category
ORDER BY total_sold DESC;

-- 6. Top 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name,
	SUM(quantity) AS total_sold
FROM pizza_sales_db.sales_table
GROUP BY pizza_name
ORDER BY total_sold DESC
LIMIT 5;

-- 7. Bottom 5 Worst Sellers by Total Pizzas Sold
SELECT pizza_name,
	SUM(quantity) AS total_sold
FROM pizza_sales_db.sales_table
GROUP BY pizza_name
ORDER BY total_sold ASC
LIMIT 5;