--book 2 ch 2, WHERE clauses and Filtering Data 
SELECT * FROM sales s;
SELECT * FROM salestypes st;

--Get a list of sales records where the sale was a lease.
--Lease is id 2
SELECT * FROM sales s 
JOIN salestypes st 
ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_name = 'Lease';


--Get a list of sales where the purchase date is within the last five years.
SELECT * FROM sales s 
WHERE purchase_date > '2018-01-01'
ORDER BY purchase_date DESC;

--Get a list of sales where the deposit was above 5000 or the customer payed with American Express.
SELECT * FROM sales s 
WHERE deposit > 5000 OR payment_method = 'americanexpress';

--Get a list of employees whose first names start with "M" or ends with "d".
SELECT * FROM employees e
WHERE first_name LIKE 'M%' OR first_name LIKE '%d';

--Get a list of employees whose phone numbers have the 604 area code.
SELECT * FROM employees e
WHERE phone LIKE '604%';