
CREATE VIEW product_sales AS 
SELECT c.sku, c.order_no, c.qty, (c.qty * c.price) AS total_price,
	EXTRACT(YEAR FROM date) AS year, EXTRACT(MONTH FROM date) AS month,
	EXTRACT(DAY FROM date) AS day_of_month, EXTRACT(DOW FROM date) AS day_of_week,
	SUBSTRING(c.address FROM '([0-9]{4}-[0-9]{3} )(.*)') AS city

FROM contains c
JOIN product pro ON c.SKU = pro.SKU
JOIN orders ON c.order_no = order.no
JOIN customer cu ON o.cust_no = cu.cust_no
JOIN pay p ON orders.order_no = p.order_no;
