--book 2 ch 8: Window Functions

--a list of total sales per employee
select
	sales.employee_id,
	sum(sales.price) total_employee_sales
from
	employees
join
	sales
on
	sales.employee_id = employees.employee_id
group by
	sales.employee_id
	

-- The default for OVER() is the entire rowset. 
--It will apply the function--SUM()--to the entire dataset, in this case total sales. 
--If we want to break the data into parts, we partition it by the data we want to group it by. 
--In this query, we are partitioning by the employee id so get total sales per employee.
select distinct
	e.last_name || ', ' || e.first_name AS employee_name,
	s.employee_id,
	sum(s.price) over() total_sales,
	sum(s.price) over(partition by e.employee_id) total_employee_sales
from
	employees e
join
	sales s
on
	s.employee_id = e.employee_id
order by employee_name

--