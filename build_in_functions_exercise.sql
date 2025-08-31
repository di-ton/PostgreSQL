-- 1. River Info

CREATE VIEW view_river_info
AS SELECT
	CONCAT('The river', ' ', river_name, ' ', 'flows into the', ' ', outflow, ' ', 'and is', ' ', length, ' ', 'kilometers long.') AS "River Information"
FROM rivers
ORDER BY river_name ASC
;

SELECT * FROM view_river_info;

-- 2. Concatenate Geography Data

CREATE VIEW view_continents_countries_currencies_details
AS SELECT
	CONCAT(con.continent_name, ': ', con.continent_code) AS "continent_details",
	CONCAT_WS(' - ', c.country_name, c.capital, c.area_in_sq_km, 'km2') AS "country_information",
	CONCAT(cur.description, ' (', cur.currency_code, ')') AS "currencies"
FROM
	continents AS con,
	countries AS c,
	currencies AS cur
WHERE
	con.continent_code = c.continent_code AND c.currency_code = cur.currency_code	
ORDER BY 
	country_information ASC,
	currencies ASC
;

SELECT * FROM view_continents_countries_currencies_details;

-- 3. Capital Code

ALTER TABLE countries
ADD COLUMN
	capital_code CHAR(2)
;
	
UPDATE 
	countries
SET capital_code = LEFT(capital, 2) 
;

SELECT * FROM countries;

-- 4. (Descr)iption 

SELECT
	SUBSTRING(description FROM 5)
FROM currencies
;

SELECT
	RIGHT(description, -4)
FROM currencies
;


-- 5. Substring River Length

SELECT
	(REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1]
FROM view_river_info


-- 6. Replace A 
SELECT 
	REPLACE(mountain_range, 'a', '@') AS "replace_a",
	REPLACE(mountain_range, 'A', '$') AS "replace_A"
FROM mountains
;
	
-- 7. Translate 
SELECT
	capital,
	TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS "translated_name"
FROM countries
;


-- 8. LEADING
SELECT
	continent_name,
	TRIM(LEADING FROM continent_name) as "trim"
FROM continents
;

-- 9. TRAILING 

SELECT
	continent_name,
	TRIM(TRAILING FROM continent_name) as "trim"
FROM continents
;

-- 10. LTRIM & RTRIM

SELECT
	LTRIM(peak_name, 'M') as "left_trim",
	RTRIM(peak_name, 'm') as "right_trim"
FROM peaks
;

-- 11. Character Length and Bits 

SELECT
	CONCAT(m.mountain_range, ' ', p.peak_name) AS "mountain_information",
	CHAR_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "characters_length",
	BIT_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "bits_of_a_tring"
FROM 
	mountains AS m,
	peaks AS p
WHERE
	m.id = p.mountain_id
;

-- 12. Length of a Number

SELECT
	population,
	LENGTH(CAST(population AS VARCHAR)) AS "length"
FROM countries
;


-- 13. Positive and Negative LEFT

SELECT
	peak_name,
	SUBSTRING(peak_name, 1, 4) AS "positive_left",
	LEFT(peak_name, -4) AS "negative_left"
FROM peaks
;


-- 14. Positive and Negative RIGHT 
SELECT
	peak_name,
	RIGHT(peak_name, 4) AS "positive_right",
	RIGHT(peak_name, -4) AS "negative_right"
FROM peaks
;

-- 15. Update iso_code

UPDATE 
	countries
SET
	iso_code = UPPER(LEFT(country_name, 3))
WHERE iso_code IS NULL
;

-- 16. REVERSE country_code

UPDATE 
	countries
SET
	country_code = LOWER(REVERSE(country_code))
;

SELECT * FROM countries



-- 17. Elevation --->> Peak Name 

SELECT
	CONCAT(elevation, ' ', REPEAT('-', 3), REPEAT('>', 2), ' ', peak_name) AS "Elevation --->> Peak Name"
FROM peaks
WHERE elevation >= 4884
;




