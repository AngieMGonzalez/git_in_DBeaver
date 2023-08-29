--Team Project: Creating Carnival Reports
--Carnival would like to harness the full power of reporting. Let's begin to look further at querying the data in our tables. Carnival would like to understand more about thier business and needs you to help them build some reports.
--
--Goal
--Below are some desired reports that Carnival would like to see. Use your query knowledge to find the following metrics.
--
--Employee Reports
--Best Sellers
--1. Who are the top 5 employees for generating sales income?

SELECT
	e.employee_id,
	e.first_name || ' ' || e.last_name AS employee_name, 
	SUM(s.price) AS sales_income
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id 
GROUP BY e.employee_id, employee_name
ORDER BY sales_income DESC 
LIMIT 5;

--2. Who are the top 5 dealership for generating sales income?
SELECT
	d.dealership_id,
	d.business_name,
	SUM(s.price) AS sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id 
GROUP BY d.dealership_id, d.business_name
ORDER BY sales_income DESC 
LIMIT 5;

--3. Which vehicle model generated the most sales income?
--Maxima
SELECT 
	vt.model,
	SUM(s.price) AS sales_income
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id 
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
GROUP BY vt.model
ORDER BY sales_income DESC 
LIMIT 1;


--Top Performance
--1. Which employees generate the most income per dealership?
--WINDOW FUNCTION / CTE
--inner: employee income
--outter: dealership


SELECT 
	dealership_id,
	business_name,
	employee_id,
	CONCAT(first_name, ' ', last_name) AS employee_name,
	sales_income
FROM (
	SELECT
		d.dealership_id,
		d.business_name,
		e.employee_id,
		e.first_name, 
		e.last_name,
		SUM(s.price) AS sales_income,
		RANK() OVER (PARTITION BY d.dealership_id ORDER BY SUM(s.price) DESC) AS sales_rank
	FROM sales s
	JOIN employees e ON s.employee_id = e.employee_id 
	JOIN dealerships d ON s.dealership_id = d.dealership_id
	GROUP BY d.dealership_id, d.business_name, e.employee_id, e.first_name, e.last_name 
) ranked_sales
WHERE sales_rank = 1


--Query 1 uses a subquery to calculate sales income and rank employees within each dealership.
--Query 2 uses Common Table Expressions (CTEs) to first find the maximum sales income per dealership and then join it with employee sales data.
--Window Function vs. CTE:
--
--Query 1 uses a window function (RANK()) to rank employees based on sales income.
--Query 2 calculates the maximum sales income using a window function (MAX() OVER) in the dlr_max CTE.
--Distinct vs. Group By:
--
--Query 2 uses DISTINCT in the dlr_max CTE to find the maximum sales income for each dealership.
--Query 1 uses GROUP BY to calculate sales income and rank employees within each dealership.
--JOIN vs. LEFT JOIN:
--
--Query 1 uses a LEFT JOIN to include all dealerships, even if they don't have a top-performing employee.
--Query 2 also uses a LEFT JOIN but includes all employees within the dealership with the top sales income.


--dlr_max
WITH dlr_max AS
(
	SELECT DISTINCT 
		dealership_id, 
		MAX(SUM(price)) OVER (PARTITION BY dealership_id) dlr_max
	FROM sales
	GROUP BY dealership_id, employee_id
	ORDER BY dealership_id
),
emp_sales AS
(
	SELECT 
		dealership_id, 
		employee_id, 
		SUM(price) emp_sales
	FROM sales
	GROUP BY dealership_id, employee_id
)
SELECT 
	dm.dealership_id, 
	first_name, 
	last_name, 
	employee_id, 
	emp_sales
FROM dlr_max dm LEFT JOIN emp_sales es 
	ON dm.dealership_id = es.dealership_id
	AND dm.dlr_max = es.emp_sales
	LEFT JOIN employees USING (employee_id)
ORDER BY dealership_id


--Vehicle Reports
--Inventory
--1. In our Vehicle inventory, show the count of each Model that is in stock.
SELECT 
	vt.model,
	COUNT(v.vehicle_id) AS model_count
FROM vehicles v 
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
WHERE v.is_sold IS FALSE 
GROUP BY model;

--2. In our Vehicle inventory, show the count of each Make that is in stock.
SELECT 
	vt.make,
	COUNT(v.vehicle_id) AS make_in_stock
FROM vehicles v 
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
WHERE v.is_sold IS FALSE 
GROUP BY make;

--3. In our Vehicle inventory, show the count of each BodyType that is in stock.
SELECT 
	vt.body_type,
	COUNT(v.vehicle_id) AS body_count
FROM vehicles v 
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
WHERE v.is_sold IS FALSE 
GROUP BY body_type
ORDER BY body_count DESC;


--Purchasing Power
--1. Which US state's customers have the highest average purchase price for a vehicle?
SELECT 
	DISTINCT c.state,
	ROUND(AVG(s.price) OVER(PARTITION BY c.state), 2) avg_price
FROM sales s 
JOIN customers c ON s.customer_id = c.customer_id 
GROUP BY c.state, s.price 
ORDER BY avg_price DESC 
LIMIT 1;

--2. Now using the data determined above, which 5 states have the customers with the highest average purchase price for a vehicle?
SELECT 
	DISTINCT c.state,
	ROUND(AVG(s.price) OVER(PARTITION BY c.state), 2) avg_price
FROM sales s 
JOIN customers c ON s.customer_id = c.customer_id 
GROUP BY c.state, s.price 
ORDER BY avg_price DESC 
LIMIT 5;

