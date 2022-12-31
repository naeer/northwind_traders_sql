SELECT ship_country AS shipping_country,
round(avg(shipped_date  - order_date + 1),2) AS average_days_between_order_shipping,
count(DISTINCT(order_id)) AS total_volume_orders
FROM (
	SELECT * 
	FROM orders o 
	WHERE EXTRACT (YEAR FROM order_date) = 1997
) orders_1997
GROUP BY shipping_country
HAVING avg(shipped_date  - order_date + 1) >= 3 AND avg(shipped_date  - order_date + 1) < 20
AND count(DISTINCT(order_id)) > 5
ORDER BY average_days_between_order_shipping DESC 