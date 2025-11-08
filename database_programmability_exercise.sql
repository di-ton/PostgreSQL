-- 1. User-defined Function Full Name

CREATE OR REPLACE FUNCTION fn_full_name(first_name varchar, last_name varchar)
RETURNS varchar AS
$$
	DECLARE 
		full_name VARCHAR;
	BEGIN
		IF first_name IS NULL AND last_name IS NULL THEN
			full_name := NULL;
		ELSEIF first_name IS NULL THEN
			full_name := UPPER(last_name);
		ELSEIF last_name IS NULL THEN
			full_name := UPPER(first_name);
		ELSE 
			full_name := CONCAT(INITCAP(first_name), ' ', INITCAP(last_name));
		END IF;
		RETURN full_name;
	END
$$
LANGUAGE plpgsql;

SELECT fn_full_name('fred', NULL);


-- 2. User-defined Function Future Value 
DROP FUNCTION fn_calculate_future_value;


CREATE OR REPLACE FUNCTION fn_calculate_future_value(
	IN initial_sum DECIMAL, 
	IN yearly_interest_rate decimal,
	IN number_of_years INT 
	)
RETURNS DECIMAL AS
$$
	DECLARE 
		future_value DECIMAL;
	BEGIN
		future_value := initial_sum * POWER(1 + yearly_interest_rate, number_of_years);
		RETURN TRUNC(future_value, 4);
	END
$$
LANGUAGE plpgsql;

SELECT fn_calculate_future_value (2500, 0.30, 2);


-- 3. User-defined Function Is Word Comprised

CREATE OR REPLACE FUNCTION fn_is_word_comprised(
	IN set_of_letters VARCHAR(50), 
	IN word VARCHAR(50)
	)
RETURNS BOOLEAN AS
$$
	DECLARE 
		ind int;
		letter CHAR(1);
	BEGIN
		FOR ind IN 1..LENGTH(word) LOOP
			letter := SUBSTRING(LOWER(word), ind, 1);
			IF POSITION(letter IN LOWER(set_of_letters)) = 0 THEN
				RETURN FALSE;
			END IF;
		END LOOP;
		RETURN TRUE;
	END
$$
LANGUAGE plpgsql;


SELECT fn_is_word_comprised('ois tmiah%f', 'halves');
SELECT fn_is_word_comprised('ois tmiah%f', 'Sofia');


CREATE OR REPLACE FUNCTION fn_is_word_comprised_trim(
	IN set_of_letters VARCHAR(50), 
	IN word VARCHAR(50)
	)
RETURNS BOOLEAN AS
$$
	BEGIN
		RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';
	END
$$
LANGUAGE plpgsql;


SELECT fn_is_word_comprised_trim('ois tmiah%f', 'Sofia');

-- 4. Game Over 


CREATE OR REPLACE FUNCTION fn_is_game_over(
	IN is_game_over BOOLEAN
	)
RETURNS TABLE (
	name VARCHAR(50),
	game_type_id INT,
	is_finished BOOL
) 
AS
$$
	BEGIN
		RETURN query 
		SELECT
			g.name,
			g.game_type_id,
			g.is_finished
		FROM games AS g
		WHERE g.is_finished = is_game_over;
	END
$$
LANGUAGE plpgsql;


SELECT fn_is_game_over(TRUE);


-- 5. Difficulty Level 

CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT)
RETURNS VARCHAR
AS
$$
	DECLARE
		difficulty_level VARCHAR;
	BEGIN
		IF level <= 40 THEN difficulty_level := 'Normal Difficulty';
		ELSEIF level BETWEEN 41 and 60 THEN difficulty_level := 'Nightmare Difficulty';
		ELSE difficulty_level := 'Hell Difficulty';
		END IF;
		RETURN difficulty_level;
	END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_users()
RETURNS TABLE (
	user_id INT,
	level INT,
	cash DECIMAL(19, 4),
	difficulty_level VARCHAR
) 
AS
$$
	BEGIN
		RETURN query 
		SELECT
			ug.user_id,
			ug.level,
			ug.cash,
			fn_difficulty_level(ug.level)
		FROM users_games AS ug
		ORDER BY ug.user_id;	
	END
$$
LANGUAGE plpgsql;


SELECT fn_users();

-- 6. Cash in User Games Odd Rows **

CREATE OR REPLACE FUNCTION fn_cash_in_users_games(game_name VARCHAR(50))
RETURNS TABLE (
	total_cash NUMERIC
) 
AS
$$
	BEGIN
		RETURN query 
		SELECT
			SUM(game_cash.cash)
		FROM (
			SELECT
				g.name AS "name",
				ug.cash AS "cash"
			FROM users_games AS ug
			JOIN games as g ON g.id = ug.game_id
			WHERE cash % 2 = 1
			-- GROUP BY g.name
			ORDER BY ug.cash DESC
			) AS game_cash
		WHERE game_cash.name = game_name;
	END
$$
LANGUAGE plpgsql; -- Works, but not in Judge



CREATE OR REPLACE FUNCTION fn_cash_in_users_games(game_name VARCHAR(50))
RETURNS TABLE (
	total_cash NUMERIC
) 
AS
$$
	BEGIN
		RETURN query 
		SELECT
			ROUND(SUM(game_cash.cash), 2) AS total_cash
		FROM
		(
		SELECT
			g.name,
			ug.cash AS "cash",
			ROW_NUMBER() OVER (ORDER BY ug.cash DESC) AS row_num
		FROM games as g
		JOIN users_games AS ug 
		ON g.id = ug.game_id
		WHERE g.name = game_name
		) AS game_cash
		WHERE game_cash.row_num % 2 = 1;
	END
$$
LANGUAGE plpgsql;


SELECT fn_cash_in_users_games('Love in a mist');
SELECT fn_cash_in_users_games('Delphinium Pacific Giant');











