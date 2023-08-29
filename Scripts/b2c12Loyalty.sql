--Book 2 ch 12: Carnival Loyalty
--Carnival Customers
--States With Most Customers
--1. What are the top 5 US states 
--with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT * FROM salestypes;

SELECT 
	s.sale_id AS S_ID,
	s.sales_type_id AS ST_ID,
	d.dealership_id AS d_id,
	d.state AS d_state,
	c.customer_id AS c_id,
	c.first_name || ' ' || c.last_name AS c_name, 
	c.state c_state,
	s.customer_id AS cust_id
FROM sales s 
JOIN dealerships d ON s.dealership_id = d.dealership_id 
JOIN customers c ON s.customer_id = c.customer_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id 
WHERE st.sales_type_name ILIKE 'Purchase'
ORDER BY c_id;


SELECT
    c.state AS state,
    COUNT(DISTINCT c.customer_id) AS customer_count
FROM
    sales s
JOIN
    dealerships d ON s.dealership_id = d.dealership_id
JOIN
    customers c ON s.customer_id = c.customer_id
JOIN
    salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
    st.sales_type_name ILIKE 'Purchase'
GROUP BY
    c.state
ORDER BY
    customer_count DESC
LIMIT 5;

SELECT 
	d.state,
	COUNT(DISTINCT c.customer_id) AS customer_count
FROM customers c 
JOIN sales s ON c.customer_id = s.customer_id 
JOIN dealerships d ON s.dealership_id = d.dealership_id 
GROUP BY d.state 
ORDER BY customer_count DESC 
LIMIT 5;


--2. What are the top 5 US zipcodes 
--with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
    c.zipcode,
    c.state,
    COUNT(DISTINCT c.customer_id) AS customer_count
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN
    salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
    st.sales_type_name ILIKE 'Purchase'
GROUP BY c.zipcode, c.state
ORDER BY customer_count DESC
LIMIT 5;



--3. What are the top 5 dealerships with the most customers?

SELECT
    d.business_name,
    COUNT(DISTINCT c.customer_id) AS customer_count
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.business_name
ORDER BY customer_count DESC
LIMIT 5;

SELECT
    d.dealership_id,
    d.business_name AS dealership_name,
    COUNT(DISTINCT c.customer_id) AS customer_count
FROM
    dealerships d
JOIN
    sales s ON d.dealership_id = s.dealership_id
JOIN
    customers c ON s.customer_id = c.customer_id
GROUP BY
    d.dealership_id, d.business_name
ORDER BY
    customer_count DESC
LIMIT 5;
