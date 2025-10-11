-- Database Programmability

-- Full name FUNCTION

CREATE OR REPLACE FUNCTION fn_get_full_name(first_name varchar, last_name varchar)
RETURNS VARCHAR AS
$$
	DECLARE
		full_name VARCHAR;
	BEGIN
		IF first_name IS NULL AND last_name IS NULL THEN
			full_name := 'No name';
		ELSEIF first_name IS NULL THEN
			full_name := last_name;
		ELSEIF last_name IS NULL THEN
			full_name := first_name;
		ELSE 
			full_name := CONCAT(first_name, ' ', last_name);
		END IF;

		RETURN full_name;
	END
$$
LANGUAGE plpgsql;

SELECT fn_get_full_name(NULL, NULL);


-- country_id FUNCTION
CREATE OR REPLACE FUNCTION fn_get_country_id(c varchar)
RETURNS INT AS
$$
	DECLARE
		country_id INT;
	BEGIN
		SELECT id FROM countries WHERE country_name = c INTO country_id;
		RETURN country_id;
	END
$$
LANGUAGE plpgsql;

SELECT fn_get_country_id('Bulgaria');

-- 1. Count Employees by Town

CREATE OR REPLACE FUNCTION fn_count_employees_by_town(town_name varchar(20))
RETURNS INT AS
$$
	DECLARE
		count_number INT;
	BEGIN
		SELECT
			COUNT(*)
			FROM employees as e
			JOIN addresses as a
			USING (address_id)
			JOIN towns as t
			USING (town_id)
			WHERE t.name = town_name INTO count_number;
		RETURN count_number;
	END
$$
LANGUAGE plpgsql;

SELECT fn_count_employees_by_town('Sofia');


-- Add values into a table 
CREATE OR REPLACE FUNCTION fn_add_country(country_name varchar(20), country_id INT)
RETURNS BOOLEAN AS
$$
	BEGIN
		INSERT INTO countries(id, country)
		VALUES (country_id, country_name);
		RETURN TRUE;
		EXCEPTION
			WHEN UNIQUE_VIOLATION THEN RETURN FALSE;
	END
$$
LANGUAGE plpgsql;

SELECT fn_add_country('Canada', 88);


-- Returns TABLE
CREATE OR REPLACE FUNCTION fn_get_persons()
RETURNS TABLE(id INT, full_name VARCHAR, country VARCHAR) AS
$$
	BEGIN
		RETURN QUERY (
			SELECT
				p.id,
				CONCAT(p.first_name, ' ', p.last_name)::varchar AS full_name,
				c.country
			FROM persons AS p
			JOIN countries AS c
			ON p.country_id = c.id
		);
	END
$$
LANGUAGE plpgsql;

-- Returns TABLE with FILTER
CREATE OR REPLACE FUNCTION fn_get_persons(c_id INT)
RETURNS TABLE(id INT, full_name VARCHAR, country VARCHAR) AS
$$
	BEGIN
		RETURN QUERY (
			SELECT
				p.id,
				CONCAT(p.first_name, ' ', p.last_name)::varchar AS full_name,
				c.country
			FROM persons AS p
			JOIN countries AS c
			ON p.country_id = c.id
			WHERE c.id = c_id
		);
	END
$$
LANGUAGE plpgsql;


-- 2. Employees Promotion 

CREATE OR REPLACE PROCEDURE sp_increase_salaries(department_name varchar)
AS
$$
	BEGIN
		UPDATE employees
		SET salary = salary * 1.05
		WHERE department_id = (
			SELECT
				department_id
			FROM departments 
			WHERE departments.name = department_name
		);
	END
$$
LANGUAGE plpgsql;

CALL sp_increase_salaries('Finance');


-- DEBUGGING --> NOTICE

CREATE OR REPLACE FUNCTION fn_get_info(msg varchar)
RETURNS BOOLEAN AS
$$
	BEGIN
		RAISE NOTICE 'WARNING: %', msg;
		RETURN TRUE;
	END
$$
LANGUAGE plpgsql;

SELECT fn_get_info('Wrong data');


-- 3. Employees Promotion By ID 


CREATE OR REPLACE PROCEDURE sp_increase_salary_by_id(id INT)
AS
$$
	BEGIN
		IF (
			SELECT salary
			FROM employees
			WHERE employee_id = id
		) IS NULL THEN 
		RETURN;
		END IF;
		UPDATE employees
		SET salary = salary * 1.05
		WHERE employee_id = id;
		COMMIT;
	END
$$
LANGUAGE plpgsql;

CALL sp_increase_salary_by_id(17);


-- 4. Triggered 
CREATE TABLE deleted_employees(
	employee_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	first_name VARCHAR(20), 
	last_name VARCHAR(20), 
	middle_name VARCHAR(20), 
	job_title VARCHAR(50), 
	department_id INT, 
	salary DECIMAL(19, 4)
);


CREATE OR REPLACE FUNCTION delete_employees()
RETURNS TRIGGER AS
$$
	BEGIN
		INSERT INTO deleted_employees(
			first_name, last_name, middle_name, job_title, department_id, salary
		)
		VALUES (
			old.first_name, old.last_name, old.middle_name, old.job_title, old.department_id, old.salary
		);
		RETURN old;
	END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_deleted_employees
BEFORE DELETE ON employees
FOR EACH ROW EXECUTE PROCEDURE delete_employees()
;










