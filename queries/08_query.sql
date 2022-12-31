SELECT *,
CASE 
	WHEN unit_price < average_unit_price THEN 'Below Average'
	WHEN unit_price = average_unit_price THEN 'Average'
	WHEN unit_price > average_unit_price THEN 'Over Average'
END average_unit_price_position,
CASE 
	WHEN unit_price < median_unit_price THEN 'Below Median'
	WHEN unit_price = median_unit_price THEN 'Median'
	WHEN unit_price > median_unit_price THEN 'Over Median'
END median_unit_price_position
FROM (
	SELECT category_avg_unit_prices.category_name, 
	product_unit_prices.product_name, 
	product_unit_prices.unit_price, 
	category_avg_unit_prices.average_unit_price, 
	category_median_unit_prices.median_unit_price
	FROM (
		SELECT c.category_id, c.category_name, 
		round(CAST(avg(p.unit_price) AS numeric),2) AS average_unit_price 
		FROM categories c 
		INNER JOIN (
			SELECT * FROM products p5 WHERE p5.discontinued = 0 
		) p ON c.category_id = p.category_id
		GROUP BY c.category_id, c.category_name
	) category_avg_unit_prices 
	INNER JOIN (
		SELECT c2.category_id, c2.category_name,
		round(CAST(percentile_cont(0.5) WITHIN GROUP (ORDER BY p2.unit_price) AS numeric),2) AS median_unit_price 
		FROM categories c2 
		INNER JOIN (
			SELECT * FROM products p4 WHERE p4.discontinued = 0 
		) p2 ON c2.category_id = p2.category_id 
		GROUP BY c2.category_id, c2.category_name
	) category_median_unit_prices 
	ON category_avg_unit_prices.category_id = category_median_unit_prices.category_id
	INNER JOIN (
		SELECT c3.category_id, c3.category_name, p3.product_name, p3.unit_price 
		FROM categories c3 
		INNER JOIN products p3 ON c3.category_id = p3.category_id
		WHERE p3.discontinued = 0
	) product_unit_prices 
	ON category_avg_unit_prices.category_id = product_unit_prices.category_id
) category_avg_median_unit_prices
ORDER BY category_name, product_name

