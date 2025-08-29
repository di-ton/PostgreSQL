-- 1. Select Cities
SELECT * FROM cities
ORDER BY id
;

-- 2. Concatenate
SELECT 
	concat(name, ' ', state) AS "cities_information",
	area AS "area_km2"
FROM cities
;

-- 3. Remove Duplicate Rows
SELECT 
	DISTINCT (name) name,
	area AS "area_km2"
FROM cities
ORDER BY name DESC
;

-- 4. Limit Records
SELECT 
	id, 
	concat(first_name, ' ', last_name) AS "full_name",
	job_title
FROM employees
ORDER BY first_name ASC
LIMIT 50
;

-- 5. Skip Rows
SELECT 
	id AS "id", 
	concat(first_name, ' ', middle_name, ' ', last_name) AS "full_name",
	hire_date
FROM employees
ORDER BY hire_date ASC
OFFSET 9 ROWS
;

-- 6. Find the Addresses

SELECT 
	id, 
	concat(number, ' ', street) AS "address",
	city_id
FROM addresses
WHERE id >= 20
;


-- 7. Positive Even Number

SELECT
	concat(number, ' ', street) AS "address",
	city_id
FROM addresses
WHERE city_id > 0 AND city_id % 2 = 0
ORDER BY city_id ASC
;

-- 8. Projects within a Date Range

SELECT 
	name, 
	start_date,
	end_date
FROM projects
WHERE start_date >= '2016-06-01 07:00:00' AND end_date < '2023-06-04 00:00:00'
ORDER BY start_date ASC
;


-- 9. Multiple Conditions

SELECT
	number,
	street
FROM addresses
WHERE id BETWEEN 50 AND 100 OR number < 1000
; 

-- 10. Set of Values

SELECT
	employee_id,
	project_id
FROM employees_projects
WHERE employee_id IN (200, 250) AND project_id NOT IN (50, 100)
;


-- 11. Compare Character Values

SELECT 
	name, 
	start_date
FROM projects
WHERE name IN ('Mountain', 'Road', 'Touring')
LIMIT 20
;


-- 12. Salary 

SELECT 
	concat(first_name, ' ', last_name) AS "full_name",
	job_title,
	salary
FROM employees
WHERE salary IN (12500, 14000, 23600, 25000)
ORDER BY salary DESC
;

-- 13. Missing Value

SELECT 
	id,
	first_name,
	last_name
FROM employees
WHERE middle_name IS NULL
LIMIT 3
;


-- 14. INSERT Departments

INSERT INTO departments(department, manager_id)
VALUES
	('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109);

SELECT * FROM departments
;


-- 15. New Table

CREATE VIEW company_chart AS
SELECT 
	concat(first_name, ' ', last_name) AS "full_name",
	job_title,
	department_id,
	manager_id
FROM employees
;


-- 16. Update the Project End Date

UPDATE projects
SET end_date = start_date + INTERVAL '5 MONTHS'
WHERE end_date IS NULL


-- 17. Award Employees with Experience

UPDATE employees
SET salary = salary + 1500,
	job_title = concat('Senior', ' ', job_title)
WHERE hire_date BETWEEN '1998*01-01' AND '2000-01-05'  
;

SELECT * FROM employees;


-- 18. Delete Addresses

DELETE FROM addresses
WHERE city_id in (5, 17, 20, 30)
;


-- 19. Create a View 

CREATE VIEW view_company_chart AS
SELECT 
	full_name,
	job_title
FROM company_chart
WHERE manager_id = 184
;


-- 20. Create a View with Multiple Tables

CREATE VIEW view_addresses AS
SELECT
	concat(e.first_name, ' ', e.last_name) AS full_name,
	e.department_id,
	concat(a.number, ' ', a.street) AS address
FROM
	employees AS e
JOIN
	addresses AS a
ON
	e.address_id = a.id
ORDER BY address
;

-- 21. ALTER VIEW

ALTER VIEW view_addresses
RENAME TO view_employee_addresses_info
;

-- 22. DROP VIEW

DROP VIEW view_company_chart
;

-- 23. *UPPER

UPDATE projects
SET name = UPPER(name)
;

SELECT * FROM projects;

-- SELECT UPPER(name) FROM projects;


-- 24. *SUBSTRING
CREATE VIEW view_initials AS
SELECT
	SUBSTRING(first_name, 1, 2) AS initial,
	-- LEFT(first_name, 2) AS initials,
	last_name
FROM
	employees
ORDER BY last_name
;


SELECT * FROM view_initials;


-- 25. *LIKE

SELECT
	name,
	start_date
FROM projects
WHERE name LIKE 'MOUNT%' 
ORDER BY id

-- SELECT
-- 	name,
-- 	start_date
-- FROM projects
-- WHERE LEFT(name, 5) = 'MOUNT' 
-- ORDER BY id
-- ;


