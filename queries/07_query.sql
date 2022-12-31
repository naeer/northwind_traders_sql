SELECT c.category_name, 
CASE 
	WHEN s.country IN ('USA', 'Brazil', 'Canada') THEN 'America'
	WHEN s.country IN ('UK', 'Spain', 'Sweden', 'Germany', 'Italy', 'Norway', 
					'France', 'Denmark', 'Netherlands', 'Finland') THEN 'Europe'
	WHEN s.country IN ('Japan', 'Singapore') THEN 'Asia'
	WHEN s.country IN ('Australia') THEN 'Oceania'
END supplier_region,
sum(p.unit_in_stock) AS units_in_stock, 
sum(p.unit_on_order) AS units_on_order, 
sum(p.reorder_level) AS reorder_level
FROM suppliers s
INNER JOIN products p ON s.supplier_id = p.supplier_id 
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name, supplier_region
ORDER BY supplier_region, category_name, reorder_level