--book 2 ch 9: Carnival Sales

--Purchase Income by Dealership
--1. Write a query that shows the total purchase sales income per dealership.

SELECT * FROM salestypes;
--sales_type_id 1 = Purchase sales_type_name

SELECT 
	d.dealership_id,	
	d.business_name, 
   	SUM(s.price) AS total_purchase_sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name ILIKE 'Purchase'
GROUP BY d.business_name, d.dealership_id 
ORDER BY d.dealership_id ASC;


--2. Write a query that shows the purchase sales income per dealership for July of 2020.
SELECT
	d.business_name, 
   	SUM(s.price) AS purchase_sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE 	st.sales_type_name ILIKE 'Purchase' AND 
		s.purchase_date >= '2020-07-01' AND s.purchase_date < '2020-08-01'
--		EXTRACT(YEAR FROM s.purchase_date) = 2020
--		AND EXTRACT(MONTH FROM s.purchase_date) = 7
		--TEXT(s.purchase_date) LIKE '2020-07%'
GROUP BY d.business_name
ORDER BY purchase_sales_income ASC;

--3. Write a query that shows the purchase sales income per dealership for all of 2020.
SELECT
	d.business_name, 
   	SUM(s.price) AS purchase_sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE 	st.sales_type_name ILIKE 'Purchase' AND 
		EXTRACT(YEAR FROM s.purchase_date) = 2020
--		TEXT(s.purchase_date) LIKE '2020%'
GROUP BY d.business_name
ORDER BY purchase_sales_income ASC;

--Lease Income by Dealership
--1. Write a query that shows the total lease income per dealership.
--sales_type_id 2 = Lease sales_type_name

SELECT d.business_name, 
       SUM(s.price) AS lease_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name ILIKE 'Lease'
GROUP BY d.business_name
ORDER BY lease_income DESC;

--2. Write a query that shows the lease income per dealership for Jan of 2020.
SELECT d.business_name, 
       SUM(s.price) AS lease_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name ILIKE 'Lease' AND 
	s.purchase_date >= '2020-01-01' AND s.purchase_date < '2020-02-01'
GROUP BY d.business_name
ORDER BY lease_income DESC;

--3. Write a query that shows the lease income per dealership for all of 2019.
SELECT d.business_name, 
       SUM(s.price) AS lease_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name ILIKE 'Lease' AND 
	s.purchase_date >= '2019-01-01' AND s.purchase_date < '2020-01-01'
--	EXTRACT(YEAR FROM s.purchase_date) = 2019
GROUP BY d.business_name
ORDER BY lease_income DESC;

--Total Income by Employee
--1. Write a query that shows the total income (purchase and lease) per employee.
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name seller,
    SUM(s.price) AS total_income
FROM sales s
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
JOIN employees e ON s.employee_id = e.employee_id
WHERE st.sales_type_id = 1 OR st.sales_type_id = 2
GROUP BY e.employee_id, seller
ORDER BY total_income DESC;
