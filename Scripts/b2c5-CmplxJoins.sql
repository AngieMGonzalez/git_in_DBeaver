--Book2, Ch 5
--Complex Joins 

-- Find employees who haven't made any sales and the name of the dealership they work at.
SELECT
    e.first_name,
    e.last_name,
    d.business_name,
    s.price
FROM employees e
INNER JOIN dealershipemployees de ON e.employee_id = de.employee_id
INNER JOIN dealerships d ON d.dealership_id = de.dealership_id
LEFT JOIN sales s ON s.employee_id = e.employee_id
WHERE s.price IS NULL;
--11 employees

-- Get all the departments in the database,
-- all the employees in the database and the floor price of any vehicle they have sold.
SELECT
    d.business_name,
    e.first_name,
    e.last_name,
    v.floor_price
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON e.employee_id = de.employee_id
INNER JOIN sales s ON s.employee_id = e.employee_id
INNER JOIN vehicles v ON s.vehicle_id = v.vehicle_id;
--5131 results of vehicles

-- Use a self join to list all sales that will be picked up on the same day,
-- including the full name of customer picking up the vehicle. .
SELECT
    CONCAT  (c.first_name, ' ', c.last_name) AS customer_name,
    s1.invoice_number,
    s1.pickup_date
FROM sales s1
INNER JOIN sales s2
    ON s1.sale_id <> s2.sale_id 
    AND s1.pickup_date = s2.pickup_date
INNER JOIN customers c
   ON c.customer_id = s1.customer_id;
--4610 sales results 
   
-- Get employees and customers who have interacted through a sale.
-- Include employees who may not have made a sale yet.
-- Include customers who may not have completed a purchase.
SELECT
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name
FROM employees e
FULL OUTER JOIN sales s ON e.employee_id = s.employee_id
FULL OUTER JOIN customers c ON s.customer_id = c.customer_id;
--5026 results
--includes where emp has no cust-- customer is NULL 
--includes where there is no emp for cust-- employee is NULL 

-- Get a list of all dealerships and which roles each of the employees hold.
SELECT
    d.business_name,
    et.employee_type_name AS et_name
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON de.employee_id = e.employee_id
RIGHT JOIN employeetypes et ON e.employee_type_id = et.employee_type_id;
--1028 results of dealerships employees

--PRACTICE
--Practice: Sales Type by Dealership
--Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.
SELECT 
	d.business_name AS business,
	st.sales_type_name  AS salestype
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id 
JOIN salestypes st ON s.sales_type_id = st.sales_type_id;

--sales per dealership

SELECT 
    d.business_name AS business,
    COUNT(s.sale_id) AS sales_count
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id 
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
GROUP BY d.business_name
ORDER BY sales_count ASC;

--leases per dealership
SELECT 
	d.business_name AS business,
	COUNT(*) AS lease_count
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id 
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name ILIKE 'lease'
GROUP BY d.business_name;


SELECT 
    d.business_name AS business,
    COUNT(*) AS lease_count
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id 
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_id = 2
GROUP BY d.business_name;

--combining them
SELECT 
    d.business_name AS business,
    COUNT(s.sale_id) AS sales_count,
    COUNT(CASE WHEN st.sales_type_name ILIKE 'lease' THEN 1 ELSE NULL END) AS lease_count
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id 
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
GROUP BY d.business_name
ORDER BY sales_count ASC;


--Practice: Leased Types
--Produce a report that determines the most popular vehicle model that is leased.
--Corvette 
SELECT 
    vt.model AS model,
    COUNT(*) AS lease_count
FROM sales s
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
JOIN vehicles v ON s.dealership_id = v.dealership_location_id 
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
WHERE st.sales_type_id = 2
GROUP BY vt.model;


--Who Sold What:
--What is the most popular vehicle make in terms of number of sales?
--Nissan

--SELECT
--	v.vehicle_id AS id,
--    MAX(vt.make) AS make,
--    COUNT(s.sale_id) AS sale_count
--FROM sales s
--JOIN salestypes st ON s.sales_type_id = st.sales_type_id
--JOIN vehicles v ON s.dealership_id = v.dealership_location_id 
--JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
--WHERE st.sales_type_id = 2
--GROUP BY v.vehicle_id 
--ORDER BY sale_count DESC;

--There were 705 Nissans sold, making it the most popular make in terms of sales.
SELECT DISTINCT 
	vt.make AS carMake, 
	COUNT(sales.vehicle_id) AS sales
FROM sales 	
LEFT JOIN vehicles v USING (vehicle_id)			
LEFT JOIN vehicletypes vt USING (vehicle_type_id)
WHERE v.is_sold IS true			
GROUP BY carMake
ORDER BY sales DESC
LIMIT 1;


--Which employee type sold the most of that make?

--SELECT
--    MAX(vt.make) AS make,
--    et.employee_type_name AS employeetype,
--    COUNT(s.sale_id) AS sale_count
--FROM sales s
--JOIN salestypes st ON s.sales_type_id = st.sales_type_id
--JOIN vehicles v ON s.vehicle_id = v.vehicle_id 
--JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
--JOIN employees e ON s.employee_id = e.employee_id 
--JOIN employeetypes et ON e.employee_type_id = et.employee_type_id 
--WHERE vt.make = 'Nissan'
--GROUP BY et.employee_type_name
--ORDER BY sale_count DESC;
--Nissan - Customer Service

--Customer Service employees sold 242 Nissans.
SELECT 
	et.employee_type_id, 
	et.employee_type_name, 
	COUNT(v.vehicle_id) AS sales
FROM sales	
LEFT JOIN vehicles AS v USING (vehicle_id)
LEFT JOIN vehicletypes AS vt USING (vehicle_type_id)
LEFT JOIN employees AS e USING (employee_id)
LEFT JOIN employeetypes AS et USING (employee_type_id)
WHERE make ILIKE 'Nissan'	
GROUP BY et.employee_type_id, et.employee_type_name
ORDER BY sales DESC;
