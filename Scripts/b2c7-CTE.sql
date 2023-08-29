--Book 2 Ch. 7
-- Common Table Expressions (CTE)

SELECT * FROM oilchangelogs;

-- syntax
WITH
   name_for_summary_data AS (SELECT Statement)
   SELECT columns
   FROM name_for_summary_data
   WHERE conditions <=> (
      SELECT column
      FROM name_for_summary_data)
   [ORDER BY columns]


-- setup
insert into oilchangelogs
	(date_occured, vehicle_id)
values
	('2020-01-09', 1),
	('2021-10-30', 2),
	('2019-02-20', 3),
	('2022-03-17', 4)
;

--1st SOLULU -- partially correct
with vehicles_needing_service as
(
	select
		v.vehicle_id,
		v.year_of_car,
		v.miles_count,
		--the to_char takes away the seconds
		TO_CHAR(o.date_occured, 'YYYY-MM-DD') date_of_last_change
	from vehicles v

	join oilchangelogs o
		on v.vehicle_id = o.vehicle_id
	where o.date_occured < '2022-01-01'
)

-- query that set of results as part of a larger query
select
	vs.vehicle_id,
	vs.miles_count,
	s.purchase_date,
	e.first_name || ' ' || e.last_name seller,
	c.first_name || ' ' || c.last_name purchaser,
	c.email
from vehicles_needing_service vs -- Use the CTE
join sales s
	on s.vehicle_id  = vs.vehicle_id
join employees e
	on s.employee_id = e.employee_id
join customers c
	on s.customer_id = c.customer_id
order by
	vs.vehicle_id,
	s.purchase_date desc
;


-- 2nd SOLULU -- CORRECT
--Since multiple people can purchase the same car over time, 
--the service manager only wants the last purchaser. 
--You can break this part of the SQL out into another CTE. 
--You can use multiple CTEs as part of the query. You separate them with a comma.
with vehicles_needing_service as
(
	select
		v.vehicle_id,
		v.year_of_car,
		v.miles_count,
		TO_CHAR(o.date_occured, 'YYYY-MM-DD') date_of_last_change
	from vehicles v

	join oilchangelogs o
		on v.vehicle_id = o.vehicle_id
	where o.date_occured < '2022-01-01'
),
last_purchase as (
	select
		s.vehicle_id,
		max(s.purchase_date) purchased
	from sales s
	group by s.vehicle_id
)

-- filter
select
	vs.vehicle_id,       -- Get vehicle id from first CTE
	vs.miles_count,      -- Get miles from first CTE
	lp.purchased,        -- Get purchase date from second CTE
	e.first_name || ' ' || e.last_name seller,
	c.first_name || ' ' || c.last_name purchaser,
	c.email
from vehicles_needing_service vs
join last_purchase lp   -- Join the second CTE
	on lp.vehicle_id  = vs.vehicle_id
join sales s
	on lp.vehicle_id = s.vehicle_id
	and lp.purchased = s.purchase_date
join employees e
	on s.employee_id = e.employee_id
join customers c
	on s.customer_id = c.customer_id
;

-- Exercises:
--Top 5 Dealerships Qs:
--For the top 5 dealerships: 
		--1. for top 5 dealership, which employees made the most sales? 
			--*Note: to get a list of the top 5 employees with the associated dealership, 
			-- you will need to use a Windows function (next chapter). 
			-- There are other ways you can interpret this query to not return that strict of data.
SELECT * FROM  sales s
ORDER BY s.price DESC  
LIMIT 5; -- still NOT the RIGHT place TO START because we need TO sum the sales per employee

WITH top_dealerships AS (
    SELECT s.dealership_id,
    	   d.business_name,
           SUM(s.price) AS sum_of_sales
    FROM sales s
    JOIN dealerships d ON s.dealership_id = d.dealership_id
    GROUP BY s.dealership_id, d.business_name
    ORDER BY sum_of_sales DESC
    LIMIT 5
),
top_employees AS (
    SELECT td.dealership_id, 
           FIRST_VALUE(s.employee_id) OVER (
           		PARTITION BY td.dealership_id ORDER BY COUNT(*) DESC
           ) AS top_employee_id
    FROM sales s
    JOIN top_dealerships td ON s.dealership_id = td.dealership_id
    GROUP BY td.dealership_id, s.employee_id
)
SELECT 
	td.business_name AS dealership, 
	e.first_name || ' ' || e.last_name AS employee
FROM top_dealerships td
JOIN top_employees te ON td.dealership_id = te.dealership_id
JOIN employees e ON te.top_employee_id = e.employee_id
GROUP BY td.business_name, e.first_name, e.last_name;


		--2. for top 5 dealership, which vehicle models were the most popular in sales?

WITH top_dealerships AS (
    SELECT s.dealership_id,
    	   d.business_name,
           SUM(s.price) AS sum_of_sales
    FROM sales s
    JOIN dealerships d ON s.dealership_id = d.dealership_id
    GROUP BY s.dealership_id, d.business_name
    ORDER BY sum_of_sales DESC
    LIMIT 5
),
top_models AS (
    SELECT td.dealership_id, vt.model,
           RANK() OVER (
           		PARTITION BY td.dealership_id ORDER BY COUNT(*) DESC
           ) AS next_top_model,
           COUNT(*) AS ntmodels_sold
    FROM sales s
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
    JOIN top_dealerships td ON s.dealership_id = td.dealership_id
    GROUP BY td.dealership_id, vt.model 
)
SELECT 
	td.business_name AS dealership, 
	tm.model,
	tm.ntmodels_sold AS total_sold
FROM top_dealerships td
JOIN top_models tm ON td.dealership_id = tm.dealership_id AND tm.next_top_model = 1
ORDER BY td.sum_of_sales DESC;


		--3. for top 5 dealership, were there more sales or leases?

SELECT * FROM salestypes s 

WITH top_dealerships AS (
    SELECT s.dealership_id,
    	   d.business_name,
           SUM(s.price) AS sum_of_sales,
           COUNT(*) AS total_transactions
    FROM sales s
    JOIN dealerships d ON s.dealership_id = d.dealership_id
    GROUP BY s.dealership_id, d.business_name
    ORDER BY sum_of_sales DESC
    LIMIT 5
),
transaction_counts AS (
    SELECT td.dealership_id,
           SUM(CASE WHEN s.sales_type_id = 2 THEN 1 ELSE 0 END) AS leased,
           SUM(CASE WHEN s.sales_type_id = 1 THEN 1 ELSE 0 END) AS purchased
    FROM sales s
    JOIN top_dealerships td ON s.dealership_id = td.dealership_id
    GROUP BY td.dealership_id
)
SELECT td.business_name AS dealership,
       CASE WHEN tc.leased > tc.purchased THEN 'Leases'
            WHEN tc.leased < tc.purchased THEN 'Purchases'
            ELSE 'Equal' END AS leases_vs_purchases,
       tc.leased, 
       tc.purchased, 
       td.total_transactions AS lease_plus_purchase
FROM top_dealerships td
JOIN transaction_counts tc ON td.dealership_id = tc.dealership_id;

--Used Cars:
--For all used cars, which states sold the most? The least?

WITH used_car_by_state AS (
    SELECT d.state,
           COUNT(*) AS used_cars_sold,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS most_sold,
           RANK() OVER (ORDER BY COUNT(*) ASC) AS least_sold
    FROM sales s
    JOIN dealerships d ON s.dealership_id = d.dealership_id
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    WHERE v.is_new = FALSE 
    GROUP BY d.state
)
SELECT state, used_cars_sold
FROM used_car_by_state
WHERE most_sold = 1 OR least_sold = 1;

--For all used cars, which model is greatest in the inventory? Which make is greatest inventory?
SELECT
    vt.model AS most_common_model,
    COUNT(*) AS inventory_count
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_new = FALSE
GROUP BY vt.model
ORDER BY inventory_count DESC
LIMIT 1;
--Model: TItan

SELECT
    vt.make AS most_common_make,
    COUNT(*) AS inventory_count
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_new = FALSE
GROUP BY vt.make
ORDER BY inventory_count DESC
LIMIT 1;
--Make: Nissan 

--1 SOLUTION
-- (Using Subqueries within CTE):
--Also uses a single CTE (UsedCarInventory) but employs subqueries within the CTE to calculate the maximum counts for both model and make.
--Selects the model and make in the CTE itself.
--In the main query, filters the results to include only rows where the inventory count is equal to the maximum model count or the maximum make count. 
--This approach avoids a second subquery in the main query.
WITH UsedCarInventory AS (
    SELECT
        vt.model AS most_common_model,
        vt.make AS most_common_make
    FROM sales s
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
    WHERE v.is_new = FALSE
    GROUP BY vt.model, vt.make
    HAVING COUNT(*) = (
        SELECT MAX(model_count)
        FROM (
            SELECT COUNT(*) AS model_count
            FROM sales s
            JOIN vehicles v ON s.vehicle_id = v.vehicle_id
            JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
            WHERE v.is_new = FALSE
            GROUP BY vt.model
        ) AS model_counts
    ) OR COUNT(*) = (
        SELECT MAX(make_count)
        FROM (
            SELECT COUNT(*) AS make_count
            FROM sales s
            JOIN vehicles v ON s.vehicle_id = v.vehicle_id
            JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
            WHERE v.is_new = FALSE
            GROUP BY vt.make
        ) AS make_counts
    )
)
SELECT * FROM UsedCarInventory;


--ANOTHER SOLUTION 
--(Using UNION and RANK):
--Creates a CTE (InventoryRank) that calculates counts separately for models and makes, then combines them using UNION ALL.
--Assigns a category ('Model' or 'Make') to each row in the CTE to distinguish between them.
--In the main query, uses the RANK() window function to rank rows within each category by inventory count.
--Filters the results to include only rows with a rank of 1, which represents the highest inventory count in each category.
WITH InventoryRank AS (
    SELECT
        vt.model AS model_or_make,
        COUNT(*) AS inventory_count,
        'Model' AS category
    FROM sales s
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
    WHERE v.is_new = FALSE
    GROUP BY vt.model
    UNION ALL
    SELECT
        vt.make AS model_or_make,
        COUNT(*) AS inventory_count,
        'Make' AS category
    FROM sales s
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
    WHERE v.is_new = FALSE
    GROUP BY vt.make
)
SELECT
    model_or_make,
    category
FROM (
    SELECT
        model_or_make,
        category,
        RANK() OVER (PARTITION BY category ORDER BY inventory_count DESC) AS rank
    FROM InventoryRank
) RankedInventory
WHERE rank = 1;

--ANOTHER SOLUTION
WITH used_car_inventory AS (
    SELECT
        vt.model AS most_common_model,
        vt.make AS most_common_make,
        COUNT(*) AS inventory_count
    FROM sales s
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
    WHERE v.is_new = FALSE
    GROUP BY vt.model, vt.make
)
SELECT
    most_common_model,
    most_common_make,
    inventory_count
FROM used_car_inventory
WHERE inventory_count = (
    SELECT MAX(inventory_count) FROM used_car_inventory
);
--Uses a single CTE (used_car_inventory) to calculate the counts of both model and make.
--Selects the model, make, and inventory count in a straightforward manner.
--Filters the results to include only rows where the inventory count is equal to the maximum inventory count.



--Practice
--Talk with your teammates
-- and think of another scenario where you can use a CTE 
--to answer multiple business questions about employees, inventory, sales, deealerships or customers.