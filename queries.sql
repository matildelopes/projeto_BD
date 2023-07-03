--3.SQL

--1:Qual o número e nome do(s) cliente(s) com maior valor total de encomendas pagas?  

SELECT  customer.cust_no AS NumeroCliente,  customer.name AS NomeClientes FROM orders
JOIN contains ON orders.order_no = contains.order_no
JOIN product ON contains.SKU = product.SKU
JOIN pay ON pay.order_no = orders.order_no
JOIN customer ON pay.cust_no = customer.cust_no
GROUP BY  customer.cust_no, customer.name
HAVING SUM(price *qty) >= ALL (
	SELECT SUM(price *qty) FROM orders
	JOIN contains ON orders.order_no = contains.order_no
	JOIN product ON contains.SKU = product.SKU
	JOIN pay ON pay.order_no = orders.order_no
	GROUP BY orders.cust_no
)

--2:Qual o nome dos empregados que processaram encomendas em todos os dias de 2022 em que houve encomendas?

SELECT employee.name AS NomeEmpregados FROM employee
JOIN process ON employee.ssn = process.ssn
JOIN orders ON process.order_no = orders.order_no
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY employee.name, employee.ssn
HAVING COUNT(DISTINCT orders.date) = (                --verificação se o número de dias distintos em que o empregado processou (TODOS OS DIAS DE 2022-função COUNT)
    SELECT COUNT(DISTINCT orders.date) FROM orders    --encomendas é igual ao número de dias distintos em que houve encomendas em 2022
    WHERE EXTRACT(YEAR FROM date) = 2022)


--3:Quantas encomendas foram realizadas mas não pagas em cada mês de 2022?

SELECT MONTH(date) AS Mes , COUNT(order_no) AS "Ordens nao pagas"  FROM orders
WHERE orders.order_no NOT IN (SELECT order_no FROM pay)
AND EXTRACT(YEAR FROM date) = 2022
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)