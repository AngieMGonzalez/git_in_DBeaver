--checking duplicate vehicle sales
SELECT vehicle_id, COUNT(*) AS duplicate_count
FROM sales
GROUP BY vehicle_id
HAVING COUNT(*) > 1;


--Book 2 Ch.1 - Basic Query Review - Fundamentals
--Practice: Dealers
--Write a query that returns the business name, city, state, and website 
--for each dealership. Use an alias for the Dealerships table.
--dealers
SELECT
	business_name,
	city,
	state,
	website 
FROM dealerships d;

--vehicles
SELECT * FROM Vehicles;

SELECT
    v.engine_type,
    v.floor_price,
    v.msr_price
FROM Vehicles v