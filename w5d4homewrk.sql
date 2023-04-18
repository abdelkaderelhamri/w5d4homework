-- QUESTION 1:
--Create a procedure that adds a late fee to any customer who returned their rental after 7 days.
-- Use the payment and rental tables.

CREATE or replace PROCEDURE SevenDayslateFee(late_fee_amount DECIMAL(5,2))	
LANGUAGE plpgsql 
AS $$ 
BEGIN
		UPDATE payment
		SET amount = amount + late_fee_amount
		WHERE rental_id IN(
			SELECT rental_id
			FROM rental
			WHERE  return_date - rental_date > INTERVAL '7'DAY );  
		
		
		  COMMIT;
END;
$$;

CALL sevendayslateFee(2)	

SELECT*FROM payment
			
--QUESTION 2:
--Add a new column in the customer table for Platinum Member. This can be a boolean.
-- Platinum Members are any customers who have spent over $200. 
-- Create a procedure that updates the Platinum Member column to True for any customer who has spent over $200 and False for any customer who has spent less than $200.
-- Use the payment and customer table.

ALTER TABLE customer
ADD COLUMN platinum_members boolean;

SELECT* FROM customer
			
CREATE or replace PROCEDURE Update_Platinum_Members(_customer_id INTEGER)
LANGUAGE plpgsql 
AS $$ 
BEGIN
		UPDATE customer SET platinum_members = True
		Where customer_id = _customer_id;
				
		  COMMIT;
END;
$$;

 SELECT* FROM customer where  customer_id=148 --and customer_id=144 and customer_id=459 and customer_id=178 and customer_id=526
 
 CALL Update_Platinum_Members(137)
 CALL Update_Platinum_Members(144)
 CALL Update_Platinum_Members(148)
 CALL Update_Platinum_Members(178)
 CALL Update_Platinum_Members(459)
 CALL Update_Platinum_Members(526)

 
SELECT first_name, last_name,customer_id
FROM customer
WHERE customer_id IN(
        SELECT customer_id
		from payment
		GROUP BY customer_id
		Having SUM(amount)>200)

		