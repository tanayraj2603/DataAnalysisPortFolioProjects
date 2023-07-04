-- Copy Table
CREATE TABLE customers_copy
SELECT * 
    FROM customers
    WHERE points > 2000;
    
USE sql_hr;
-- CREATE VIEW
CREATE VIEW employee_under_manager AS
SELECT e.employee_id, e.first_name, m.first_name AS manager_name, m.employee_id AS manager_id
FROM employees e
JOIN employees m ON e.reports_to = m.employee_id;

-- UPDATE VIEW
UPDATE employee_under_manager
	SET employee_id = 35000 
    WHERE first_name = 'sayer';
    
-- CASE operator
SELECT order_id, order_date,
	CASE status
		WHEN 1 THEN 'shipped'
        WHEN 2 THEN 'delieverd'
	END AS order_status
    FROM orders;

SELECT order_id, order_date,
	CASE status
		WHEN 1 THEN 'shipped'
        ELSE concat(order_id, ' will be shipped soon')
	END AS order_status
    FROM orders;

-- IF and NULL IF Operator
SELECT customer_id, state,
	IF(first_name LIKE '%a%', first_name, NULL) as name
	FROM customers;

SELECT order_id, order_date,
	NULLIF(status, 2) as order_status
	FROM orders;

-- TRIGGERS
-- TRIGGER on insert value
CREATE TRIGGER ins_name
	BEFORE INSERT ON customers
		FOR EACH ROW
			SET NEW.first_name = UPPER(NEW.first_name);

INSERT INTO customers(first_name, last_name, address, city, state, points)
	VALUES ('Tony', 'Stark', 'rajpipla', 'Newyork', 'NY', '1234');
  
  
-- TRIGGER on update value
CREATE TRIGGER up_name
	BEFORE UPDATE ON customers
		FOR EACH ROW
			SET NEW.first_name = LOWER(NEW.first_name);

UPDATE customers
	SET first_name = 'ALEX', last_name = 'stone', address = 'chavta bajar', city = 'las vegas', state = 'LA', points = '3456'
    WHERE customer_id = 10;

    
-- CROSS JOIN
USE sql_invoicing;
SELECT cl.*, iv.*
FROM clients cl CROSS JOIN invoices iv;

-- UNION
SELECT client_id
FROM clients
WHERE state in ("NY", "CA", "TX")
UNION
SELECT client_id
FROM invoices
WHERE payment_date IS NULL