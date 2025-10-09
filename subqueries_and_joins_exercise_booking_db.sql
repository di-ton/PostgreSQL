-- 1. Booked for Nights
SELECT 
	CONCAT(a.address, ' ', a.address_2) AS "apartment_address",
	b.booked_for AS "nights"
FROM bookings AS b
JOIN apartments as a
USING (booking_id) 
ORDER BY a.apartment_id ASC;


-- 2. First 10 Apartments Booked At 
SELECT
	a.name AS "name",
	a.country AS "country",
	DATE(b.booked_at) AS "booked_at"
FROM bookings AS b
RIGHT JOIN apartments AS a
USING (booking_id) 
LIMIT 10
;

SELECT
	a.name AS "name",
	a.country AS "country",
	DATE(b.booked_at) AS "booked_at"
FROM apartments AS a
LEFT JOIN bookings AS b
USING (booking_id) 
LIMIT 10
;


-- 3. First 10 Customers with Bookings

SELECT 
	b.booking_id AS "booking_at",
	DATE(b.starts_at) AS "starts_at",
	b.apartment_id AS "apartment_id",
	CONCAT(c.first_name,' ', c.last_name) AS "Customer Name"
FROM bookings AS b
RIGHT JOIN customers AS c
ON c.customer_id = b.customer_id
ORDER BY "Customer Name"
LIMIT 10
;


-- 4. Booking Information

SELECT
	b.booking_id AS "booking",
	a.name AS "apartment_owner",
	a.apartment_id AS "apartment_id",
	CONCAT(c.first_name, ' ', c.last_name) AS "customer_name"
FROM customers AS c
FULL JOIN bookings AS b
	USING (customer_id)
		FULL JOIN apartments AS a
			USING (booking_id)

ORDER BY "booking_id" ASC, "apartment_owner" ASC, "customer_name" ASC
;

-- 5. Multiplication of Information**


SELECT 
	b.booking_id AS "booking_id",
	c.first_name AS "customer_name"
FROM bookings AS b
	CROSS JOIN customers AS c
ORDER BY "customer_name" ASC
;


-- 6. Unassigned Apartments

SELECT
	b.booking_id AS "booking_id",
	b.apartment_id AS "apartment_id",
	c.companion_full_name AS "companion_full_name"
FROM bookings AS b
	JOIN customers AS c
		USING (customer_id)
WHERE b.apartment_id IS NULL
;


-- 7. Bookings Made by Lead

SELECT
	b.apartment_id AS "apartment_id",
	b.booked_for AS "booked_for",
	c.first_name AS "first_name",
	c.country AS "country"
FROM bookings AS b
	INNER JOIN customers AS c
		USING (customer_id)
WHERE job_type = 'Lead'
;


-- 8. Hahn`s Bookings 

SELECT
	count(b.booking_id) AS "count"
FROM bookings AS b
	JOIN customers AS c
		USING (customer_id)
WHERE c.last_name = 'Hahn'
;

-- 9. Total Sum of Nights 

SELECT
	a.name AS "name",
	SUM(b.booked_for) AS "sum"
FROM apartments AS a
JOIN bookings AS b
-- USING (booking_id)
USING (apartment_id)
GROUP BY a.name
ORDER BY a.name ASC
;


-- 10. Popular Vacation Destination

SELECT
	a.country AS "country",
	COUNT(b.booking_id) AS "booking_count"
FROM apartments AS a
JOIN bookings AS b
-- USING (booking_id)
USING (apartment_id)
WHERE b.booked_at > '2021-05-18 07:52:09.904+03' AND b.booked_at < '2021-09-17 19:48:02.147+03' 
GROUP BY a.country
ORDER BY "booking_count" DESC
;














