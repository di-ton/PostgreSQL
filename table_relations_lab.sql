-- TABLE RELATIONS

-- Steps in database design
-- -- 1. Identification of the entities
-- -- 2. Defining table columns
-- -- 3. Defining primary keys
-- -- 4. Modeling relationships
-- -- 5. Defining constraints
-- -- 6. Filling test DATA

-- 1. Mountains and Peaks 

CREATE TABLE mountains (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50)
);


CREATE TABLE peaks (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	mountain_id INT,
	CONSTRAINT fk_peaks_mountains
		FOREIGN KEY (mountain_id)
			REFERENCES mountains(id)
);


-- Many-to-many

CREATE TABLE men (
	id SERIAL PRIMARY KEY,
	name VARCHAR(20)
);

CREATE TABLE women (
	id SERIAL PRIMARY KEY,
	name VARCHAR(20)
);

CREATE TABLE men_women (
	man_id INT REFERENCES men(id),
	woman_id INT REFERENCES women(id),
	CONSTRAINT fk_men_women PRIMARY KEY (man_id, woman_id)
);


INSERT INTO men (name)
VALUES
	('Ivo'),
	('Milko'),
	('Sasho'),
	('Drago'),
	('Zajo')
;

SELECT * FROM men;

INSERT INTO women (name)
VALUES
	('Katya'),
	('Maya'),
	('Olya'),
	('Ani'),
	('Tea')
;

INSERT INTO men_women
VALUES
	(1, 2),
	(2, 4),
	(3, 5),
	(4, 2),
	(5, 3),
	(1, 3),
	(2, 5)
;


SELECT * FROM men_women;

SELECT *
FROM men as m
	JOIN men_women as mw
		ON m.id = mw.man_id
	JOIN women as w ON w.id = mw.woman_id
;

SELECT 
	m.name,
	w.name
FROM men as m
	JOIN men_women as mw
		ON m.id = mw.man_id
	JOIN women as w ON w.id = mw.woman_id
;


-- One-to-one
CREATE TABLE capitals(
	capital_id SERIAL PRIMARY KEY,
	capital_name VARCHAR(50)
);

CREATE TABLE countries(
	country_id SERIAL PRIMARY KEY,
	capital_id INT UNIQUE, -- IMPORTANT --> ALWAYS UNIQUE
	CONSTRAINT fk_countries_capitals 
		FOREIGN KEY (capital_id) REFERENCES capitals(capital_id)
);


-- JOINs

SELECT 
	* 
FROM 
	table_a
JOIN 
	table_b 
ON
	table_b.common_column = table_a.common_column


-- 2. Trip Organization 
SELECT
	v.driver_id,
	v.vehicle_type,
	CONCAT(c.first_name, ' ', c.last_name) AS driver_name
FROM vehicles AS v
	JOIN campers AS c ON c.id = v.driver_id
;


-- 3. SoftUni Hiking
SELECT
	r.start_point,
	r.end_point,
	r.leader_id,
	CONCAT(c.first_name, ' ', c.last_name)
FROM routes as r
JOIN campers as c
	ON r.leader_id = c.id
;


-- 4. Delete Mountains

DROP TABLE mountains, peaks;

CREATE TABLE mountains(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE peaks(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(50),
	mountain_id INT,
	CONSTRAINT fk_mountain_id
		FOREIGN KEY (mountain_id)
			REFERENCES mountains(id)
				ON DELETE CASCADE
);




