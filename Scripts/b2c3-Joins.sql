--Book2 ch 3
--JOINS

SELECT
    first_name,
    last_name,
    email
FROM
    students
INNER JOIN emails
    ON students.student_id = emails.student_id;
    
SELECT
    s.first_name,
    s.last_name,
    e.email
FROM
    students s
LEFT JOIN emails e
    ON s.student_id = e.student_id;
    
SELECT
    s.first_name,
    s.last_name,
    c.zoom_link
FROM
    students s
RIGHT JOIN cohorts c
    ON s.cohort_id = c.cohort_id;
    
--CARNIVAL
   
--Get a list of the sales that were made for each sales type.
SELECT * 
FROM sales s
JOIN salestypes st 
ON s.sales_type_id = st.sales_type_id; 

SELECT st.sales_type_name, COUNT(s.sale_id) AS total_sales_per_type
FROM sales s
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
GROUP BY st.sales_type_name;


--Get a list of sales with the VIN of the vehicle, 
--the first name and last name of the customer, 
--first name and last name of the employee who made the sale and the name, 
--city and state of the dealership.
SELECT 
	v.vin,
	c.first_name AS customer_fn,
	c.last_name AS cust_ln,
	e.first_name AS employee_fn,
	e.last_name AS emp_ln,
	d.city,
	d.state 
FROM vehicles v 
JOIN sales s ON v.vehicle_id = s.vehicle_id 
JOIN customers c ON s.customer_id = c.customer_id
JOIN employees e ON s.employee_id = e.employee_id
JOIN dealerships d ON s.dealership_id = d.dealership_id;

SELECT 
    v.vin,
    c.first_name || ' ' || c.last_name AS customer_name,
    e.first_name || ' ' || e.last_name AS employee_name,
    d.city,
    d.state 
FROM vehicles v 
JOIN sales s ON v.vehicle_id = s.vehicle_id 
JOIN customers c ON s.customer_id = c.customer_id
JOIN employees e ON s.employee_id = e.employee_id
JOIN dealerships d ON s.dealership_id = d.dealership_id;


--Get a list of all the dealerships and the employees, if any, working at each one.
SELECT 
	d.business_name,
	e.first_name,
	e.last_name 
FROM dealerships d 
LEFT JOIN dealershipemployees de ON d.dealership_id =de.dealership_id 
LEFT JOIN employees e ON de.employee_id = e.employee_id;

--Get a list of vehicles with the names of the body type, make, model and color.
SELECT
	vt.body_type,
	vt.make,
	vt.model,
	v.exterior_color AS color
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id ;
