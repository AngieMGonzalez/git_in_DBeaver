--Book2 ch.4
--Aggregation + Grouping
--EXAMPLES

-- MAX statement to find the Highest GPA in the class:
SELECT MAX(gpa) FROM Students;

-- MIN statement to find the lowest GPA in the class:
SELECT MIN(gpa) FROM Students;

-- COUNT statement to find the total number of Students in a class:
SELECT COUNT(*) FROM Students;

-- COUNT statement to find how many students have a gpa greater than 2.5:
SELECT COUNT(gpa) FROM Students where gpa > 2.5;

-- AVG statement to find the average grade for students in a class:
SELECT AVG(gpa) FROM Students;

-- AVG statement to find the average grade for students in a class:
SELECT AVG(gpa) FROM Students;

-- SUM statement to find the total cost of all teacher salaries:
SELECT SUM(salaries) FROM Teachers;

-- Here we want to query a list of students grouped by their gpa
SELECT student_name, gpa
FROM Students GROUP BY gpa

 -- Here we want to query a list of students gpas and find how many times a particular gpa occurs.
SELECT gpa, count(gpa)
FROM Students GROUP BY gpa;