USE sql_store;

SELECT 
	first_name, 
	last_name, 
    address, 
    points,
    CONCAT(first_name,' ',last_name) AS full_name,
    state
    FROM customers
    WHERE
		state IN ('GA', 'IL', 'TN')
        OR 
		points BETWEEN 1000 AND 2000; 
        
SELECT * 
	FROM customers
    WHERE
    -- birth_date BETWEEN '1980-01-01' AND '1990-12-31'
    -- AND
    -- last_name LIKE 'B____y'
    phone LIKE '___________9'; 
    
    SELECT *
		FROM customers
        WHERE last_name REGEXP 'o[ary]|e[ari]' OR phone IS NULL;
        
SELECT * 
	FROM customers;
    -- WHERE phone IS NULL;
    
UPDATE customers
	SET phone = 888666777
    WHERE customer_id = 3 AND phone IS NOT NULL;








