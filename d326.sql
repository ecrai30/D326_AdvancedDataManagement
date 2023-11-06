--Part B: Transformations 
CREATE OR REPLACE FUNCTION rentalMonth(rental_date TIMESTAMP)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE rentalMonth INT; 

BEGIN
    SELECT EXTRACT(MONTH FROM rental_date) INTO rentalMonth;
    RETURN rentalMonth;
END; 
$$

--Part C: Creates Detailed and Summary table—
DROP TABLE IF EXISTS Detailed;
CREATE TABLE Detailed(
rental_id INT ,
customer_id INT,
film_id INT ,
category_id INT, 
title VARCHAR(255),
film_category VARCHAR(25),
payment_id INT,
rental_month TIMESTAMP
); 

DROP TABLE IF EXISTS Summary;
CREATE TABLE Summary(
    genre VARCHAR(100),
    totalRentals INT
);

--Part D: Extracts raw data for detailed table-- 
INSERT INTO Detailed(
rental_id,
customer_id,
film_id,
category_id,
title,
film_category,
payment_id,
rental_month
)

SELECT
r.rental_id,
r.customer_id,
f.film_id,
cg.category_id,
f.title,
cg.name,
p.payment_id,
r.rental_date

FROM rental AS r 
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS cg ON fc.category_id = cg.category_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id;

--Part E: Procedure--  
--Creates trigger function-- 
CREATE OR REPLACE FUNCTION summary_trigger_function()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
DELETE FROM summary;
INSERT INTO summary
SELECT film_category, COUNT(rental_id)
FROM detailed
GROUP BY film_category;
RETURN NEW;
END;
$$;  

-- Part E: Creates Trigger-- 
CREATE TRIGGER update_summary
AFTER INSERT
ON
Detailed
FOR EACH STATEMENT
EXECUTE PROCEDURE summary_trigger_function();

--Part F: Stored Procedures--
CREATE OR REPLACE PROCEDURE refresh_tables()
LANGUAGE plpgsql
AS $$ 
BEGIN
DELETE FROM Detailed;
DELETE FROM Summary;
INSERT INTO Detailed(
rental_id,
customer_id,
film_id,
category_id,
title,
film_category,
payment_id,
rental_month
)

SELECT
r.rental_id,
r.customer_id,
f.film_id,
cg.category_id,
f.title,
cg.name,
p.payment_id,
r.rental_date

FROM rental AS r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS cg ON fc.category_id = cg.category_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id;

INSERT INTO summary
SELECT
    film_category,
    COUNT(rental_id)
FROM detailed
GROUP BY film_category;
END; $$;
CALL refresh_tables();

--PART F TEST CALL refresh_tables();--
SELECT COUNT(*) FROM detailed;
DELETE FROM detailed WHERE film_category = 'New';
SELECT COUNT(*) FROM detailed;
CALL refresh_tables();
SELECT COUNT(*) FROM detailed;