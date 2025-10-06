-- 11. Delete Cascade 

ALTER TABLE countries
ADD CONSTRAINT
	fk_countries_continents
FOREIGN KEY (continent_code) 
REFERENCES continents(continent_code) 
ON DELETE CASCADE;

ALTER TABLE countries
ADD CONSTRAINT
	fk_countries_currencies
FOREIGN KEY (currency_code) 
REFERENCES currencies(currency_code) 
ON DELETE CASCADE;


-- 12. Update Cascade 


ALTER TABLE countries_rivers
ADD CONSTRAINT
	fk_countries_rivers_countries
FOREIGN KEY (country_code) 
REFERENCES countries(country_code) 
ON UPDATE CASCADE;

ALTER TABLE countries_rivers
ADD CONSTRAINT
	fk_countries_rivers_rivers
FOREIGN KEY (river_id) 
REFERENCES rivers(id) 
ON UPDATE CASCADE;


-- 13. SET NULL

CREATE TABLE customers(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	customer_name VARCHAR(50)
);


CREATE TABLE contacts(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	contact_name VARCHAR(50),
	phone VARCHAR(50),
	email VARCHAR(50),
	customer_id INT,

	FOREIGN KEY (customer_id)
	REFERENCES customers(id)
	ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO customers(customer_name)
VALUES
	('BlueBird Inc'),
	('Dolphin LLC')
;

INSERT INTO contacts(contact_name, phone, email, customer_id)
VALUES
	('John Doe', '(408)-111-1234', 'john.doe@bluebird.dev', 1),
	('Jane Doe', '(408)-111-1235', 'jane.doe@bluebird.dev', 1),
	('David Wright', '(408)-222-1234', 'david.wright@dolphin.dev', 2)
;


DELETE FROM customers
WHERE id = 1
;

SELECT * FROM contacts;

-- 14. *Peaks in Rila

SELECT
	m.mountain_range, 
	p.peak_name, 
	p.elevation
FROM 
	mountains as m	
JOIN
	peaks as p
	ON m.id = p.mountain_id
WHERE m.mountain_range = 'Rila'
ORDER BY p.elevation DESC;


SELECT * FROM mountains;
SELECT * FROM peaks;


-- 15. *Countries Without Any Rivers

SELECT 
	COUNT(*) AS countries_without_rivers
FROM countries
LEFT JOIN
	countries_rivers
	-- USING (country_code) --> because this column name is common for both tables
	ON countries.country_code = countries_rivers.country_code
WHERE 
	river_id is NULL
;


