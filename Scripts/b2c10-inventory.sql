--book2 ch10
--Carnival Inventory

--Available Models
--1. Which model of vehicle has the lowest current inventory? 
--This will help dealerships know which models the purchase from manufacturers.
SELECT
    vt.model,
    COUNT(*) AS inventory_count
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
--WHERE v.is_sold = FALSE
GROUP BY vt.model
ORDER BY inventory_count ASC
LIMIT 1;
--Model: Atlas: 390 ... or 203 of not sold 

--2. Which model of vehicle has the highest current inventory? 
--This will help dealerships know which models are, perhaps, not selling.
SELECT
    vt.model,
    COUNT(*) AS inventory_count
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = FALSE
GROUP BY vt.model
ORDER BY inventory_count DESC
LIMIT 1;
--Model: Maxima: 1,226 or not sold is 606

--Diverse Dealerships
--1. Which dealerships are currently selling the least number of vehicle models? 
--This will let dealerships market vehicle models more effectively per region.
SELECT
	d.dealership_id,
    d.business_name,
    COUNT(DISTINCT vt.model) AS distinct_model_count
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = TRUE
GROUP BY d.business_name, d.dealership_id 
ORDER BY distinct_model_count ASC;

SELECT
    d.dealership_id,
    d.business_name,
    d.state,
    COUNT(DISTINCT vt.model) AS model_count
FROM sales s
LEFT JOIN vehicles v ON s.vehicle_id = v.vehicle_id
LEFT JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id
WHERE is_sold IS TRUE
GROUP BY d.dealership_id, d.state
ORDER BY model_count ASC;

SELECT * FROM dealerships;

--2. Which dealerships are currently selling the highest number of vehicle models? 
--This will let dealerships know which regions have either a high population, or less brand loyalty.
SELECT
	d.dealership_id,
    d.business_name,
    COUNT(DISTINCT vt.model) AS distinct_model_count
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = TRUE
GROUP BY d.business_name, d.dealership_id 
ORDER BY distinct_model_count DESC;

SELECT
    d.dealership_id,
    d.business_name,
    d.state,
    COUNT(DISTINCT vt.model) AS model_count
FROM sales s
LEFT JOIN vehicles v ON s.vehicle_id = v.vehicle_id
LEFT JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id
WHERE is_sold IS TRUE
GROUP BY d.dealership_id, d.state
ORDER BY model_count DESC;

