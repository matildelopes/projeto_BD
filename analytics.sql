--1
SELECT year, SUM(qty) AS sum_qty, total_price, city, month, day_of_month, day_of_week
FROM  product_sales
WHERE year = '2022'
GROUP BY 
	CUBE(city, month, day_of_month, day_of_week);


--2
SELECT month, day_of_week, AVG(total_price) AS avg_daily_sales 
FROM product_sales
WHERE year = '2022'
GROUP BY GROUPING SETS ((), (month), (day_of_week)) 
ORDER BY month, day_of_week;
	