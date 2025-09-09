-- 13. SUM the Employees
SELECT * FROM employees;

SELECT
	COUNT(CASE WHEN department_id = 1 THEN 1 END) AS "Engineering",
	COUNT(CASE WHEN department_id = 2 THEN 1 END) AS "Tool Design",
	COUNT(CASE WHEN department_id = 3 THEN 1 END) AS "Sales",
	COUNT(CASE WHEN department_id = 4 THEN 1 END) AS "Marketing",
	COUNT(CASE WHEN department_id = 5 THEN 1 END) AS "Purchasing",
	COUNT(CASE WHEN department_id = 6 THEN 1 END) AS "Research and Development",
	COUNT(CASE WHEN department_id = 7 THEN 1 END) AS "Production"
FROM employees
;


-- 14. Update Employees’ Data

UPDATE employees 
SET
	salary = CASE
		WHEN hire_date < '2015-01-16' THEN salary + 2500
		WHEN hire_date < '2020-03-04' THEN salary + 1500
		ELSE salary
	END,
	job_title = CASE
		WHEN hire_date < '2015-01-16' THEN CONCAT('Senior', ' ', job_title)
		WHEN hire_date < '2020-03-04' THEN CONCAT('Mid-', job_title)
		ELSE job_title
	END
;	

SELECT
	first_name,
	 job_title,
	 salary
FROM employees
;

-- 15. Categorizes Salary 
SELECT
	job_title,
	CASE
		WHEN AVG(salary) > 45800 THEN 'Good' 
		WHEN AVG(salary) BETWEEN 27500 AND 45800 THEN 'Medium' 
		WHEN AVG(salary) < 27500 THEN 'Need Improvement' 
	END AS "category"
FROM employees
GROUP BY job_title
ORDER BY "category" ASC, job_title
;


-- 16. WHERE Project Status

SELECT
	project_name,
	CASE
		WHEN start_date IS NULL AND end_date IS NULL THEN 'Ready for development'
		WHEN start_date IS NOT NULL AND end_date IS NULL THEN 'In Progress'
		ELSE 'Done'
	END "project_status"
FROM projects
WHERE project_name LIKE '%Mountain%'
;


SELECT * FROM projects;

-- 17. HAVING Salary Level 
SELECT
	department_id,
	COUNT(department_id) AS num_employees,
	CASE
		WHEN AVG(salary) > 50000 THEN 'Above average' 
		WHEN AVG(salary) <= 50000 THEN 'Below average' 
	END AS "salary_level"
FROM employees
GROUP BY department_id 
HAVING AVG(salary) > 30000
ORDER BY department_id
;


-- 18. *Nested CASE Conditions
CREATE VIEW view_performance_rating
AS SELECT
	first_name, 
	last_name,
	job_title,
	salary,
	department_id,
	CASE
		WHEN salary >= 25000 AND job_title LIKE 'Senior%' THEN 'High-performing Senior'
		WHEN salary >= 25000 AND job_title NOT LIKE 'Senior%' THEN 'High-performing Employee'
		ELSE 'Average-performing'
	END AS "performance_rating"
FROM employees
;

SELECT * FROM view_performance_rating;

CREATE VIEW view_performance_rating
AS SELECT
	first_name, 
	last_name,
	job_title,
	salary,
	department_id,
	CASE
		WHEN salary >= 25000 THEN
			CASE
				WHEN job_title LIKE 'Senior%' THEN 'High-performing Senior'
				ELSE 'High-performing Employee'
			END
		ELSE 'Average-performing'
	END AS "performance_rating"
FROM employees
;


-- 19. * Foreign Key

CREATE TABLE employees_projects(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	employee_id INT,
	project_id INT,

	FOREIGN KEY (employee_id)
	REFERENCES employees(id),

	FOREIGN KEY (project_id)
	REFERENCES projects(id)
)
;

-- 20. *JOIN Tables

SELECT
	*
FROM
	departments
JOIN
	employees
ON
	employees.department_id = departments.id
;

