CREATE TABLE departments (
	id serial PRIMARY KEY,
	name VARCHAR(50)
);

INSERT INTO departments(name) 
VALUES
('Front Office'), ('Support'), ('Kitchen'), ('Other');

CREATE TABLE employees (
	id serial PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	job_title VARCHAR(50) NOT NULL,
	department_id INT NOT NULL,
	salary double precision NOT NULL
	
);

INSERT INTO employees (first_name, last_name, job_title, department_id, salary) 
VALUES
	('John', 'Smith', 'Manager',1, 900.00),
	('John', 'Johnson', 'Customer Service',2, 880.00),
	('Smith', 'Johnson', 'Porter', 4, 1100.00),
	('Peter', 'Petrov', 'Front Desk Clerk', 1, 1100.00),
	('Peter', 'Ivanov', 'Sales', 2, 1500.23),
	('Ivan' ,'Petrov', 'Waiter', 3, 990.00),
	('Jack', 'Jackson', 'Executive Chef', 3, 1800.00),
	('Pedro', 'Petrov', 'Front Desk Supervisor', 1, 2100.00),
	('Nikolay', 'Ivanov', 'Housekeeping', 4, 1600.00);
	

	
CREATE TABLE rooms (
	id serial PRIMARY KEY,
	"type" VARCHAR(30)
);

INSERT INTO rooms("type") VALUES('apartment'), ('single room');

CREATE TABLE clients (
	id serial PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	room_id INT NOT NULL
);
INSERT INTO clients(first_name, last_name, room_id) 
VALUES
('Pesho','Petrov', 1),
('Gosho','Georgiev', 2),
('Mariya','Marieva', 28), 
('Katya','Katerinova', 12), 
('Nikolay','Nikolaev', 29),
('Kate',NULL, 21),
('Steven',NULL, 15),
('Christo',NULL, 17);

CREATE TABLE projects (
	id serial PRIMARY KEY,
	name VARCHAR(50),
	start_date DATE	
);

CREATE TABLE towns (
	id serial PRIMARY KEY,
	name VARCHAR(50)	
);

-- 1. Select and Display Employee Information by Concatenating Columns

SELECT 
	id, 
	concat(first_name, ' ', last_name) AS "Full Name", 
	job_title AS "Job Title"
FROM employees
;

-- 2. Select Employees by Filtering


SELECT 
	id, 
	concat(first_name, ' ', last_name) AS "Full Name", 
	job_title AS "Job Title",
	salary
FROM employees
WHERE salary > 1000
ORDER BY id
;

-- 3. Select Employees by Multiple Filters 

SELECT * FROM employees
WHERE department_id = 4 AND salary >= 1000
ORDER BY id
;

-- 4. Insert Data into Employees Table

INSERT INTO employees (first_name, last_name, job_title, department_id, salary)
VALUES
	('Samantha', 'Young', 'Housekeeping', 4, 900),
	('Roger', 'Palmer', 'Waiter', 3, 928.33)
;

SELECT * FROM employees
;

-- 5. Update Employees Salary

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager'
;

SELECT * FROM employees
WHERE job_title = 'Manager'
;

-- 6. Delete from Table

DELETE FROM employees
WHERE department_id in (1, 2)
;

SELECT * FROM employees
ORDER BY id
;


-- 7. Create a View for Top Paid Employee

CREATE VIEW top_paid_employees AS
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1
;

SELECT * FROM top_paid_employees
;


