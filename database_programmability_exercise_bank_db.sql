
-- 7.Retrieving Account Holders **

CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(
	 searched_balance numeric(19, 4)
)
AS
$$
	DECLARE
		holder_info RECORD;
	BEGIN
		FOR holder_info IN
			SELECT
				CONCAT(ah.first_name, ' ', ah.last_name) AS full_name,
				SUM(a.balance) AS "total_balance"
			FROM account_holders AS ah
			JOIN accounts AS a
			ON ah.id = a.account_holder_id
			GROUP BY full_name
			HAVING SUM(a.balance) > searched_balance
			ORDER BY full_name
		LOOP
			RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
		END LOOP;
	END
$$
LANGUAGE plpgsql;

CALL sp_retrieving_holders_with_balance_higher_than(200000);


-- 8. Deposit Money

CREATE OR REPLACE PROCEDURE sp_deposit_money(
	 account_id INT,
	 money_amount DECIMAL(10, 4)
)
AS
$$
	BEGIN
		UPDATE accounts
		SET balance = balance + money_amount
		WHERE id = account_id;

	END
$$
LANGUAGE plpgsql;


SELECT * FROM accounts WHERE id = 5;
CALL sp_deposit_money(5, 200);
SELECT * FROM accounts WHERE id = 5;

SELECT * FROM accounts;

-- 9. Withdraw Money 

CREATE OR REPLACE PROCEDURE sp_withdraw_money(
	 account_id INT,
	 money_amount DECIMAL(10, 4)
)
AS
$$
	DECLARE
		current_balance DECIMAL;
	BEGIN
		current_balance := (
			SELECT balance 
			FROM accounts
			WHERE id = account_id
		);

		IF current_balance - money_amount < 0 THEN 
			RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
		ELSE
			UPDATE accounts
			SET balance = balance - money_amount
			WHERE id = account_id;
		END IF;
	END
$$
LANGUAGE plpgsql;


SELECT * FROM accounts WHERE id = 5;
CALL sp_withdraw_money(5, 200);
SELECT * FROM accounts WHERE id = 5;


-- 10. Money Transfer 
CREATE OR REPLACE PROCEDURE sp_transfer_money(
	 sender_id INT,
	 receiver_id INT,
	 amount DECIMAL(10, 4)
)
AS
$$
	DECLARE
		current_balance DECIMAL;
	BEGIN
		CALL sp_withdraw_money(sender_id, amount);
		CALL sp_deposit_money(receiver_id, amount);

		SELECT balance INTO current_balance FROM accounts WHERE id = sender_id;
		IF current_balance < amount THEN 
			ROLLBACK;
		END IF;
	END
$$
LANGUAGE plpgsql;


CALL sp_transfer_money(5, 1, 5000.0000);

SELECT * FROM accounts WHERE id = 5;
SELECT * FROM accounts WHERE id = 1;


-- 11. Delete Procedure 

DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;


-- 12. Log Accounts Trigger 

CREATE TABLE IF NOT EXISTS logs(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	account_id INT,
	old_sum NUMERIC,
	new_sum NUMERIC
);


CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS
$$
	BEGIN
		INSERT INTO 
			logs(account_id, old_sum, new_sum)
		VALUES 
			(old.id, old.balance, new.balance);
		RETURN new;
	END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_account_balance_change
AFTER UPDATE OF balance ON accounts
FOR EACH ROW 
WHEN (new.balance <> old.balance)
EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs()
;


-- 13. Notification Email on Balance Change

CREATE TABLE IF NOT EXISTS notification_emails(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	recipient_id INT,
	subject VARCHAR,
	body VARCHAR
);

CREATE OR REPLACE FUNCTION trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER AS
$$
	BEGIN
		INSERT INTO 
			notification_emails(recipient_id, subject, body)
		VALUES 
			(
			new.account_id, 
			CONCAT('Balance change for account: ', new.account_id), 
			CONCAT('On ', DATE(NOW()), ' your balance was changed from ', new.old_sum, ' to ',  new.new_sum, '.')
			);
		RETURN new;
	END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_send_email_on_balance_change
AFTER UPDATE ON logs
FOR EACH ROW 
EXECUTE FUNCTION trigger_fn_send_email_on_balance_change()
;







