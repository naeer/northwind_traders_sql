SELECT product_name, 
round(CAST(current_unit_price AS numeric),2) AS current_unit_price,
round(CAST(previous_unit_price AS numeric),2) AS previous_unit_price,
round(CAST(((current_unit_price/previous_unit_price) - 1)*100 AS numeric),4) AS percentage_increase
FROM (
	SELECT p.product_name, p.unit_price AS current_unit_price, 
	od.unit_price AS previous_unit_price, o.order_date,
	RANK() OVER (PARTITION BY p.product_id ORDER BY o.order_date ASC) AS rk
	FROM orders o 
	INNER JOIN order_details od ON o.order_id = od.order_id 
	INNER JOIN products p ON od.product_id = p.product_id
) product_unit_prices
WHERE rk = 1
AND ((current_unit_price/previous_unit_price) - 1)*100 NOT BETWEEN 10 AND 30
ORDER BY percentage_increase