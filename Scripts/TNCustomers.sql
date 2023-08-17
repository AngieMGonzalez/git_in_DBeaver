SELECT * FROM customers c 
WHERE state = 'TN';

--Book 2 Ch.1 - Basic Query Review - Fundamentals
--Practice: Customers
--Write a query that returns the first name, last name, and email address 
--of every customer. Use an alias for the Customers table.
SELECT
	first_name,
	last_name,
	email 
FROM customers c;

SELECT
	last_name, first_name, city, state
FROM
	customers
WHERE
	state = 'TX';
	
SELECT
	c.last_name, c.first_name, c.city, c.state
FROM
	customers c
WHERE
	c.city = 'Houston' AND state = 'TX';
	
SELECT
	c.last_name, c.first_name, c.city, c.state
FROM
	customers c
WHERE
	c.state = 'TX' OR c.state = 'TN';
	
SELECT
	c.last_name, c.first_name, c.city, c.state
FROM
	customers c
WHERE
	c.state IN ('TX', 'TN', 'CA');
	

SELECT
	c.last_name, c.first_name, c.city, c.state
FROM
	customers c
WHERE
	c.state LIKE 'C%';
	

--Customers whose last name is greater than 5 characters and first name is less than or equal to 7 characters:
SELECT
	c.last_name, c.first_name
FROM
	customers c
WHERE
	LENGTH(c.last_name) > 5 AND LENGTH(c.first_name) <= 7;
	
--Customers whose company name has between 10 and 20 characters (greater than or equal to 10 and less than or equal to 20):
SELECT
	c.last_name, c.first_name, c.company_name
FROM
	customers c
WHERE
	LENGTH(c.company_name) BETWEEN 10 AND 20;
	
--Has to be IS NULL Because =NULL is not equal to any value (even itself), this will not work.
SELECT
	c.last_name, c.first_name, c.company_name
FROM
	customers c
WHERE
	c.company_name IS NULL;