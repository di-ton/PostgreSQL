-- 11. Bulgaria's Peaks Higher than 2835 Meters

SELECT 
	mc.country_code,
	m.mountain_range,
	p.peak_name,
	p.elevation
FROM mountains_countries AS mc
JOIN mountains AS m ON m.id = mc.mountain_id
JOIN peaks AS p ON m.id = p.mountain_id
	
WHERE mc.country_code = 'BG' AND p.elevation > 2835
ORDER by p.elevation DESC
;


-- 12. Count Mountain Ranges 

SELECT 
	mc.country_code,
	COUNT(m.mountain_range) AS "mountain_range_count"
FROM mountains_countries AS mc
JOIN mountains AS m 
ON m.id = mc.mountain_id
WHERE mc.country_code in ('US', 'RU', 'BG')
GROUP BY mc.country_code
ORDER by "mountain_range_count" DESC
;

-- 13. Rivers in Africa
SELECT
	c.country_name,
	r.river_name
FROM countries AS c
LEFT JOIN countries_rivers AS cr
	USING (country_code) 
LEFT JOIN rivers AS r
	ON r.id = cr.river_id
WHERE c.continent_code = (SELECT continent_code FROM continents WHERE continent_name = 'Africa')
ORDER BY c.country_name ASC
LIMIT 5
;



-- 14. Minimum Average Area Across Continents 

SELECT
	MIN(avg_area) AS min_average_area
FROM (
	SELECT 
		continent_code,
		AVG(area_in_sq_km) AS avg_area
	FROM countries
	GROUP BY continent_code
) AS avg_area_table
;

-- 18. Retrieving Information about Indexes

SELECT
	tablename,
	indexname, 
	indexdef
FROM pg_indexes
WHERE pg_indexes.schemaname = 'public'
ORDER BY tablename,indexname


-- 15. Countries Without Any Mountains


SELECT
	COUNT(*) AS countries_without_mountains
FROM countries AS c
LEFT JOIN mountains_countries AS ms
USING (country_code)
WHERE ms.mountain_id IS NULL
;


-- 16. Monasteries by Country **

CREATE TABLE monasteries(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	monastery_name VARCHAR(255),
	country_code CHAR(2)
);

INSERT INTO monasteries(monastery_name, country_code)
VALUES
	('Rila Monastery "St. Ivan of Rila"', 'BG'),
  ('Bachkovo Monastery "Virgin Mary"', 'BG'),
  ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
  ('Kopan Monastery', 'NP'),
  ('Thrangu Tashi Yangtse Monastery', 'NP'),
  ('Shechen Tennyi Dargyeling Monastery', 'NP'),
  ('Benchen Monastery', 'NP'),
  ('Southern Shaolin Monastery', 'CN'),
  ('Dabei Monastery', 'CN'),
  ('Wa Sau Toi', 'CN'),
  ('Lhunshigyia Monastery', 'CN'),
  ('Rakya Monastery', 'CN'),
  ('Monasteries of Meteora', 'GR'),
  ('The Holy Monastery of Stavronikita', 'GR'),
  ('Taung Kalat Monastery', 'MM'),
  ('Pa-Auk Forest Monastery', 'MM'),
  ('Taktsang Palphug Monastery', 'BT'),
  ('Sümela Monastery', 'TR')
  ;

ALTER TABLE countries
ADD COLUMN three_rivers BOOLEAN DEFAULT FALSE;

-- UPDATE countries
-- SET three_rivers = (
-- 	SELECT 
-- 		country_code,
-- 		COUNT(river_id) >= 3
-- 	FROM countries_rivers
-- 	GROUP BY country_code 
-- )
 
UPDATE countries
SET three_rivers = (
	SELECT 
		COUNT(*) >= 3
	FROM countries_rivers AS cr
	WHERE cr.country_code = countries.country_code 
);


SELECT
	m.monastery_name AS "monastery",
	c.country_name AS "country"
FROM monasteries AS m
JOIN countries as c
USING (country_code)
WHERE NOT c.three_rivers
ORDER BY m.monastery_name
;


--17. Monasteries by Continents and Countries **

UPDATE countries
SET country_name = 'Burma'
WHERE country_name = 'Myanmar'
;

INSERT INTO monasteries(monastery_name, country_code)
VALUES
	('Hanga Abbey', (SELECT country_code from countries WHERE country_name = 'Tanzania')),
	('Myin-Tin-Daik', (SELECT country_code from countries WHERE country_name = 'Myanmar'))
;

SELECT
	con.continent_name,
	c.country_name,
	COUNT(m.country_code) as monasteries_count
FROM continents as con
JOIN countries as c
USING (continent_code)
LEFT JOIN monasteries as m
USING (country_code)

WHERE NOT c.three_rivers
GROUP BY c.country_name, con.continent_name
ORDER BY monasteries_count DESC, c.country_name ASC 
;


-- 19. Continents and Currencies **


CREATE VIEW 
	continent_currency_usage
AS SELECT 
	cc_first.continent_code,
	cc_first.currency_code,
	cc_first.currency_usage
FROM (
	SELECT
		cc.continent_code,
		cc.currency_code,
		cc.currency_usage,
		DENSE_RANK() OVER (PARTITION BY cc.continent_code ORDER BY cc.currency_usage DESC) AS "ranked_by_usage"
	FROM (
		SELECT
			continent_code,
			currency_code,
			COUNT(currency_code) as "currency_usage"
		FROM countries
		GROUP BY 
			continent_code,
			currency_code
		HAVING COUNT(currency_code) > 1
	) AS cc
) as cc_first
WHERE 
	cc_first.ranked_by_usage = 1
ORDER BY cc_first.currency_usage DESC
;


SELECT * FROM continent_currency_usage;

-- 20. The Highest Peak in Each Country **

WITH 
	"row_number"
AS (SELECT
		c.country_name,
		COALESCE(p.peak_name, '(no highest peak)') AS "highest_peak_name",
		COALESCE(p.elevation, 0) AS "highest_peak_elevation",
		COALESCE(m.mountain_range, '(no mountain)') AS "mountain",
		ROW_NUMBER() OVER(PARTITION BY c.country_name ORDER BY p.elevation DESC) AS "row_num"
	FROM countries as c
	LEFT JOIN mountains_countries as mc
	USING (country_code)
	LEFT JOIN peaks as p
	USING (mountain_id)
	LEFT JOIN mountains as m
	ON m.id = p.mountain_id
)

SELECT
	country_name,
	highest_peak_name,
	highest_peak_elevation,
	mountain
FROM "row_number"
WHERE row_num = 1
ORDER BY country_name ASC, highest_peak_elevation DESC
;













