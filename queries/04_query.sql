SELECT 
EXTRACT (YEAR FROM order_date) || '-' || to_char(order_date, 'MM') || '-01' AS year_month, 
count(DISTINCT order_id) AS total_number_orders,
round(sum(freight)) AS total_freight
FROM (
	SELECT *
	FROM orders o 
	WHERE EXTRACT (YEAR FROM order_date) BETWEEN 1996 AND 1997
) orders_1996_1997
GROUP BY year_month 
HAVING count(DISTINCT order_id) > 20 AND round(sum(freight)) > 2500
ORDER BY total_freight DESC