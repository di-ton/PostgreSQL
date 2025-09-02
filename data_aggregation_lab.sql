-- DATA AGGREGATION

-- 1. Departments Info (by id)
SELECT 
	department_id,
	COUNT(*) AS "employee_count"
FROM employees
GROUP BY department_id
ORDER BY department_id
;

-- 2. Departments Info by Salary

SELECT 
	department_id,
	COUNT(salary) AS "employee_count" -- <null> accounts for 0
FROM employees
GROUP BY department_id
ORDER BY department_id
;

-- 3. Sum Salaries per Department 

SELECT 
	department_id,
	SUM(salary) AS "total_salaries" 
FROM employees
GROUP BY department_id
ORDER BY department_id
;


-- 4. Maximum Salary 
SELECT 
	department_id,
	MAX(salary) AS "max_salary" 
FROM employees
GROUP BY department_id
ORDER BY department_id
;

-- 5. Minimum Salary 
SELECT 
	department_id,
	MIN(salary) AS "min_salary" 
FROM employees
GROUP BY department_id
ORDER BY department_id
; 

-- 6. Average Salary 

SELECT 
	department_id,
	AVG(salary) AS "avg_salary" 
FROM employees
GROUP BY department_id
ORDER BY department_id
; 


-- 7. Filter Total Salaries

SELECT 
	department_id,
	SUM(salary) AS "Total Salary" 
FROM employees
GROUP BY department_id
HAVING SUM(salary) < 4200
ORDER BY department_id
;


-- 8. Department Names
SELECT
	id,
	first_name,
	last_name,
	TRUNC(salary, 2),
	department_id,
	CASE
		WHEN department_id = 1 THEN 'Management'
        WHEN department_id = 2 THEN 'Kitchen Staff'
        WHEN department_id = 3 THEN 'Service Staff'
		ELSE 'Other'
	END AS "department_name"
FROM employees
ORDER BY id
;



-- CASE in WHERE
SELECT
	id,
	name,
	category_id,
	price,
	CASE
		WHEN ROUND(price) = 13 THEN 'YES'
	END AS "Valid price"
FROM products
WHERE
	CASE
		WHEN price > 10 THEN TRUE
        WHEN category_id = 2 THEN TRUE
		ELSE FALSE
	END
ORDER BY id
;



SELECT
	*
FROM products









