--Book 3 ch 1 UPDATE 

UPDATE table_name
SET column1 = value1, column2 = value2...., columnN = valueN
WHERE [condition];


--BEFORE: select to double check
SELECT 
	c.email,
	c.customer_id
FROM customers c 
WHERE customer_id = 67;
-- email was eelsworth1u@scribd.com

-- UPDATE statement to change a customer
UPDATE  public.customers
SET email = 'juliasmith@gmail.com'
WHERE customer_id = 67;
--AFTER: now email has been updated! 



--Practice: Employees
--Kristopher Blumfield an employee of Carnival has asked to be transferred to a different dealership location. 
--She is currently at dealership 9. She would like to work at dealership 20. Update her record to reflect her transfer.
SELECT * 
FROM employees e
JOIN dealershipemployees de ON e.employee_id = de.employee_id 
JOIN dealerships d ON de.dealership_id = d.dealership_id  
WHERE e.first_name = 'Kristopher';

SELECT 
	dealership_id,
	employee_id
FROM dealershipemployees d 
WHERE employee_id = 9;

UPDATE  public.dealershipemployees 
SET dealership_id = 20
WHERE employee_id = 9;

--Practice: Sales
--A Sales associate needs to update a sales record because her customer want to pay with a Mastercard instead of JCB. 
--Update Customer, Ernestus Abeau Sales record which has an invoice number of 9086714242.

SELECT * FROM customers c 
JOIN sales s ON c.customer_id = s.customer_id 
WHERE c.last_name ILIKE 'Abeau' AND s.invoice_number = '9086714242';

SELECT * FROM sales s
WHERE s.invoice_number = '9086714242';

UPDATE public.sales 
SET payment_method = 'Mastercard'
WHERE invoice_number = '9086714242';