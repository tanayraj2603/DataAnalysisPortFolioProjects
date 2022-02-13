USE sql_store;
USE sql_hr;
USE sql_invoicing;

SELECT  orders.*, CONCAT(customers.first_name,' ',customers.last_name) AS full_name, customers.city 
	FROM orders
    JOIN customers 
		ON orders.customer_id = customers.customer_id
    WHERE shipper_id 
		IS NOT NULL AND order_date BETWEEN '2017-01-01' AND '2017-12-31';

SELECT p.product_id, p.quantity_in_stock, p.unit_price, o.order_id, o.quantity, o.unit_price
	FROM products p
    JOIN order_items o
		ON o.product_id = p.product_id;
        
        
-- INNER JOIN Three Table
SELECT o.order_id, o.order_date, c.first_name, c.last_name, s.name
	FROM ((orders o
		INNER JOIN shippers s ON o.shipper_id = s.shipper_id)
        INNER JOIN customers c ON o.customer_id = c.customer_id);
        
-- SELF JOIN
SELECT *
	FROM employees;
    
SELECT e.employee_id AS 'employee_id', 
	   e.first_name AS 'emplyoyee_first_name', 
       e.last_name AS 'employee_last_name', 
       m.first_name AS 'manager_first_name', 
       m.last_name AS 'manager_last_name',
       m.employee_id AS 'manager_id'
	FROM employees e
    JOIN employees m ON m.employee_id = e.reports_to;
    
SELECT c.name AS 'client_name', c.address, p.amount, pm.name AS 'payment_method_name'
	FROM ((clients c
    JOIN payments p ON c.client_id = p.client_id)
    JOIN payment_methods pm ON p.payment_method = pm.payment_method_id);
    
SELECT c.customer_id, c.first_name, o.order_id
	FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id;

-- RIGHT JOIN
USE sql_invoicing;
SELECT p.payment_id, pm.name, pm.payment_method_id
	FROM payments p
    RIGHT JOIN payment_methods pm ON p.payment_method = pm.payment_method_id;
    
-- LEFT JOIN
USE sql_store;
SELECT c.customer_id, c.first_name, o.order_id
	FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id;

-- UNION
SELECT c.first_name, c.address, c.points, 'bronze' AS level_type
	FROM customers c
    WHERE c.points < 1500
UNION
SELECT c.first_name, c.address, c.points, 'sliver' AS level_type
	FROM customers c
    WHERE c.points > 1500 AND c.points < 2500
UNION
SELECT c.first_name, c.address, c.points, 'gold' AS level_type
	FROM customers c
    WHERE c.points > 2500;
    
    
    
    

