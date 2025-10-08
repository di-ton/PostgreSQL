-- Subqueries and JOINs

-- 1. Towns Addresses
SELECT 
	t.town_id,
	t.name,
	a.address_text
FROM towns AS t
JOIN addresses AS a
	USING (town_id)
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY t.town_id, a.address_id
;


-- 2. Managers

SELECT 
	e.employee_id,
	CONCAT(e.first_name, ' ', e.last_name),
	d.department_id,
	d.name
FROM employees AS e
JOIN departments AS d
	ON e.employee_id = d.manager_id

ORDER BY e.employee_id
LIMIT 5
;


-- 3. Employees Projects

SELECT 
	e.employee_id,
	CONCAT(e.first_name, ' ', e.last_name),
	p.project_id,
	p.name
FROM employees AS e
	JOIN employees_projects AS ep
		ON e.employee_id = ep.employee_id
		JOIN projects AS p
			ON ep. project_id = p.project_id
WHERE p.project_id = 1
;


-- 4. Higher Salary
SELECT
	COUNT(*) AS "count"
FROM employees
WHERE employees.salary > (SELECT AVG(salary) FROM employees)
;






















