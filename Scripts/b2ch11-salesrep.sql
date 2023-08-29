--book2 ch 11: Employee Recognition
--Carnival Sales Reps

--Employee Reports

--1. How many emloyees are there for each role?
SELECT 
	et.employee_type_id,
	et.employee_type_name,
	COUNT(*) AS employee_count
FROM employeetypes et
JOIN employees e ON et.employee_type_id = e.employee_type_id
GROUP BY et.employee_type_id
ORDER BY et.employee_type_id;

--2. How many finance managers work at each dealership?
--finance manager = employee_type_id 2

SELECT
	d.dealership_id,
	d.business_name,
	COUNT(*) AS finance_MGR_count
FROM employees e 
JOIN dealershipemployees de ON e.employee_id = de.employee_id 
JOIN dealerships d ON de.dealership_id = d.dealership_id 
JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
WHERE et.employee_type_name ILIKE 'Finance Manager'
--OR e.employee_type_id = 2
GROUP BY d.dealership_id, d.business_name 
ORDER BY finance_MGR_count;

--3. Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT 
	e.first_name || ' ' || e.last_name AS top_employee,
	COUNT(de.dealership_id) AS dealership_count
FROM employees e 
JOIN dealershipemployees de ON e.employee_id = de.employee_id 
GROUP BY e.employee_id, e.first_name, e.last_name 
ORDER BY dealership_count DESC 
LIMIT 3;

--Sub-query: employees at >1 dealership
SELECT de.employee_id
FROM dealershipemployees de
GROUP BY de.employee_id
HAVING COUNT(DISTINCT de.dealership_id) > 1
--
-- Full query
SELECT 
	DISTINCT s.employee_id,
	e.first_name || ' ' || e.last_name AS top_employee, 
	SUM(s.price) AS total_sold
FROM sales s
JOIN employees e ON s.employee_id =e.employee_id 
WHERE s.employee_id IN 
	(SELECT de.employee_id
	FROM dealershipemployees de
	GROUP BY de.employee_id
	HAVING COUNT(DISTINCT de.dealership_id) > 1)
GROUP BY s.employee_id, top_employee
ORDER BY total_sold DESC
LIMIT 3

--4. Get a report on the top two employees who has made the most sales through leasing vehicles.

SELECT
    e.first_name,
    e.last_name,
    COUNT(*) AS lease_sales_count
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name = 'Lease'
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY lease_sales_count DESC
LIMIT 2;

SELECT
    e.first_name,
    e.last_name,
    SUM(s.price) AS total_lease_sales_amount
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name = 'Lease'
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_lease_sales_amount DESC
LIMIT 2;