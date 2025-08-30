-- 1. Find Book Titles

SELECT 
	title
FROM books
WHERE LEFT(title, 3) = 'The'
ORDER BY id
;

SELECT 
	title
FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id
;

-- 2. Replace Titles 

SELECT 
	REPLACE(title, 'The', '***') AS "Title"
FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id
;


-- 3. Triangles on Bookshelves 

SELECT
	id,
	side * height /2 AS "area"
FROM triangles
ORDER BY id
;

SELECT 10+3;
SELECT 10-6;
SELECT 4*5;
SELECT 10 / 4; -- INT
SELECT 10 / 4.0; -- Float
SELECT DIV(10, 3); --INT
SELECT 10 % 3;
SELECT MOD(10, 3);

SELECT 4 ^ 4;
SELECT POW(3, 4);

SELECT |/16;
SELECT SQRT(64);

SELECT @ -44;
SELECT ABS(-99);

SELECT PI();

SELECT FLOOR(4.52148);
SELECT CEIL(4.52148);
SELECT CEILING(5.52148);

SELECT ROUND(5.3333);
SELECT ROUND(5.6);
SELECT ROUND(5.5);

SELECT ROUND(5.235489, 2);
SELECT ROUND(505.5488455, -2);
SELECT ROUND(555.5488455, -2);
SELECT ROUND(3505.5488455, -3);

SELECT ROUND(3505.5488455, 0);

SELECT TRUNC(5.3333);
SELECT TRUNC(5.9999, 2);



-- 4. Format Costs 

SELECT
	title,
	TRUNC(cost, 3) AS "modified_cost"
FROM books
ORDER BY id
;

SELECT
	title,
	ROUND(cost, 3) AS "modified_cost"
FROM books
ORDER BY id
;


-- DATE FUNCTIONS
SELECT NOW();
SELECT EXTRACT(MONTH FROM NOW());

SELECT EXTRACT(HOUR FROM NOW());

SELECT CURRENT_DATE; -- date
SELECT CURRENT_TIME; -- time

SELECT TO_CHAR(NOW(), 'DD Month YYYY') AS "Date";
SELECT TO_CHAR(NOW(), 'DD month YY') AS "Date";
SELECT TO_CHAR(NOW(), 'DDD') AS "Day of year";
SELECT TO_CHAR(NOW(), 'DD') AS "Day of month";
SELECT TO_CHAR(NOW(), 'MONTH') AS "Month";
SELECT TO_CHAR(NOW(), 'Mon') AS "Month";
SELECT TO_CHAR(NOW(), 'Dy') AS "Day of week";


SELECT 
	EXTRACT(YEAR FROM NOW()) AS year,
	EXTRACT(MONTH FROM NOW()) AS month,
	EXTRACT(WEEK FROM NOW()) AS week,
	EXTRACT(DAY FROM NOW()) AS day,
	EXTRACT(HOUR FROM NOW()) AS hour,
	EXTRACT(MINUTE FROM NOW()) AS minute,
	EXTRACT(SECOND FROM NOW()) AS second,
	EXTRACT(TIMEZONE FROM NOW()) AS timezone
;


SELECT AGE(NOW(), '2013-06-12'); --difference bwetween two dates

SELECT EXTRACT(YEAR FROM AGE(NOW(), '2013-06-12')); 

SELECT 
	CONCAT(first_name, ' ', last_name) AS "Full Name",
	AGE(died, born) AS "Life Span"
FROM authors
;

SELECT NOW() + INTERVAL '2 hours 20 minutes';

SELECT EXTRACT(EPOCH FROM NOW());
SELECT EXTRACT(EPOCH FROM NOW() - NOW() + INTERVAL '2 hours'); -- in seconds
SELECT EXTRACT(EPOCH FROM NOW() - NOW() + INTERVAL '2 hours') / 60; -- in minutes



SELECT 
	*
FROM authors
WHERE died IS NULL -- all live authors
;



-- 5. Year of Birth 

SELECT 
	first_name,
	last_name,
	EXTRACT(YEAR from born) AS "year"
FROM authors
;


SELECT 
	first_name,
	last_name,
	DATE_PART('year', born) AS "year"
FROM authors
;


-- 6. Format Date of Birth

SELECT
	last_name AS "Last name",
	TO_CHAR(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM authors
;


-- WILDCARDS

SELECT
	*
FROM authors
WHERE first_name LIKE '%e%'
;

SELECT
	*
FROM authors
WHERE first_name LIKE '__e%'  -- the third letter is 'e' and the following letters do not matter
;


SELECT
	*
FROM authors
WHERE first_name LIKE 'S%'  -- starts with 'S'
;

SELECT
	*
FROM authors
WHERE first_name LIKE 'A%a' -- starts with 'A' and ends with 'a'
;

SELECT 
	id, 
	last_name
FROM authors
WHERE last_name LIKE '%l!_%' ESCAPE '!'
;


SELECT
	title
FROM books
WHERE LOWER(title) LIKE '%a%' -- lowercase and uppercase 'a' 
ORDER BY title;


-- 7. Harry Potter Books

SELECT
	title
FROM books
WHERE title LIKE '%Harry Potter%'
ORDER BY id





