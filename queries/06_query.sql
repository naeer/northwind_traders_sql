SELECT category_name, price_range, 
round(sum(amount_after_discount),2) AS total_amount,
count(DISTINCT order_id) AS total_number_orders
FROM (
	SELECT c.category_id, c.category_name, od.unit_price, od.order_id, 
	CASE 
		WHEN od.unit_price < 10 THEN '1. Below $10'
		WHEN od.unit_price BETWEEN 10 AND 20 THEN '2. $10 - $20'
		WHEN od.unit_price BETWEEN 20 AND 50 THEN '3. $20 - $50'
		WHEN od.unit_price > 50 THEN '4. Over $50'
	END price_range,
	round(CAST((od.unit_price * od.quantity)  - (od.unit_price * od.quantity * od.discount) AS numeric), 2) 
	AS amount_after_discount
	FROM categories c 
	INNER JOIN products p ON c.category_id = p.category_id 
	INNER JOIN order_details od ON od.product_id = p.product_id
) category_price_ranges
GROUP BY category_name, price_range
ORDER BY category_name, price_range