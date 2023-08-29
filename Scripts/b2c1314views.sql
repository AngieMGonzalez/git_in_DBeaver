--Book 2 ch 13: Virtual Tables w/ Views


CREATE VIEW employee_dealership_names AS
  SELECT 
    e.first_name,
    e.last_name,
    d.business_name
  FROM employees e
  INNER JOIN dealershipemployees de ON e.employee_id = de.employee_id
  INNER JOIN dealerships d ON d.dealership_id = de.dealership_id;
 
 
 SELECT
	*
FROM
	employee_dealership_names;
 


--Practice: Carnival
--Create a view that lists all vehicle body types, makes and models.

CREATE VIEW v_body_types AS
	SELECT
		vt.body_type,
		vt.make,
		vt.model
	FROM vehicletypes vt;
	
SELECT
	*
FROM v_body_types


--Create a view that shows the total number of employees for each employee type.

CREATE VIEW employee_type_numbers AS
	SELECT
		et.employee_type_name,
		COUNT(e.employee_id) AS employee_count
	FROM employeetypes et
	LEFT JOIN employees e ON et.employee_type_id = e.employee_type_id 
	GROUP BY et.employee_type_name;

SELECT *
FROM employee_type_numbers;

--Create a view that lists all customers without exposing their emails, phone numbers and street address.

SELECT * FROM customers c;

CREATE VIEW cust_view AS
	SELECT 
		c.customer_id,
		c.first_name || ' ' || c.last_name AS c_name,
		c.company_name
	FROM customers c

SELECT * FROM cust_view;


--Create a view named sales2018 that shows the total number of sales for each sales type for the year 2018.

SELECT * FROM sales s WHERE s.sales_type_id = 3;
SELECT * FROM salestypes s 

CREATE VIEW sales2018 AS
	SELECT 
		st.sales_type_id ,
		st.sales_type_name,
		COUNT(s.sale_id) AS total_sales
	FROM sales s
	FULL JOIN salestypes st ON s.sales_type_id = st.sales_type_id
	WHERE s.purchase_date >= '2018-01-1' AND s.purchase_date < '2019-01-01'
	GROUP BY st.sales_type_id, st.sales_type_name 

SELECT 
    st.sales_type_id,
    st.sales_type_name,
    COUNT(s.sale_id) AS total_sales
FROM
    salestypes st
LEFT JOIN
    sales s ON st.sales_type_id = s.sales_type_id AND
               s.purchase_date >= '2018-01-01' AND s.purchase_date < '2019-01-01'
GROUP BY
    st.sales_type_id, st.sales_type_name;

	
SELECT * FROM sales2018;

-- ??????????

--Create a view that shows the employee at each dealership with the most number of sales.

CREATE VIEW employee_most_sales AS
	SELECT 
		dealership_id,
		business_name,
		employee_id,
		CONCAT(first_name, ' ', last_name) AS employee_name,
		no_of_sales
	FROM (
		SELECT
			d.dealership_id,
			d.business_name,
			e.employee_id,
			e.first_name, 
			e.last_name,
			COUNT(s.sale_id) AS no_of_sales,
			RANK() OVER (PARTITION BY d.dealership_id ORDER BY COUNT(s.sale_id) DESC) AS sales_rank
		FROM sales s
		JOIN employees e ON s.employee_id = e.employee_id 
		JOIN dealerships d ON s.dealership_id = d.dealership_id
		GROUP BY d.dealership_id, d.business_name, e.employee_id, e.first_name, e.last_name 
	) ranked_sales
	WHERE sales_rank = 1

SELECT * FROM employee_most_sales;


--book 2 ch 14
-- SAVING VIEWS
--Converting Your Practice Queries into Views
--It's time to convert some of your report queries into views
-- so that other database developers, and application developers
-- can quickly gain access to useful reports without having to write their own SQL.

--Review all of the queries that you wrote for chapters 8, 9, 10, and 11.

--Determine which of those views you feel would be most useful over time. 

--Consider the view itself, or how it could be integrated into another query and/or view.
--If there were several software applications written that access this database 
--(e.g. HR applications, sales/tax applications, online purchasing applications, etc.), 
--which, if any of your queries should be converted into views that multiple applications would like use?

--Be prepared to discuss, and defend your choices in the next class.
