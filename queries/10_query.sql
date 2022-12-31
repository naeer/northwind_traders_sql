SELECT category_name, employee_full_name, total_sale_amount,
round(CAST(total_sale_amount/total_sales_per_employee AS numeric),5) AS percent_of_employee_sales,
round(CAST(total_sale_amount/total_sales_per_category AS numeric),5) AS percent_of_category_sales
FROM (
	SELECT category_name, employee_full_name, total_sale_amount, total_sales_per_employee, total_sales_per_category
	FROM (
		SELECT c.category_id, c.category_name, e.employee_id,
		e.first_name || ' ' || e.last_name AS employee_full_name,
		round(CAST(sum((od.unit_price * od.quantity)  - (od.unit_price * od.quantity * od.discount)) 
		AS numeric),2) AS total_sale_amount
		FROM employees e 
		INNER JOIN orders o ON e.employee_id = o.employee_id  
		INNER JOIN order_details od ON o.order_id = od.order_id 
		INNER JOIN products p ON od.product_id = p.product_id 
		INNER JOIN categories c ON p.category_id = c.category_id
		GROUP BY c.category_name, e.employee_id, employee_full_name, c.category_id
	) employee_category_sales
	INNER JOIN (
		SELECT e2.employee_id,
		round(CAST(sum((od2.unit_price * od2.quantity)- (od2.unit_price * od2.quantity * od2.discount)) AS numeric),2)
		AS total_sales_per_employee
		FROM employees e2 
		INNER JOIN orders o2 ON e2.employee_id = o2.employee_id 
		INNER JOIN order_details od2 ON o2.order_id = od2.order_id 
		INNER JOIN products p2 ON od2.product_id = p2.product_id 
		INNER JOIN categories c2 ON p2.category_id = c2.category_id
		GROUP BY e2.employee_id 
	) sales_per_employee
	ON employee_category_sales.employee_id = sales_per_employee.employee_id
	INNER JOIN (
		SELECT c3.category_id, 
		round(CAST(sum((od3.unit_price * od3.quantity)- (od3.unit_price * od3.quantity * od3.discount)) AS numeric),2)
		AS total_sales_per_category
		FROM employees e3 
		INNER JOIN orders o3 ON e3.employee_id = o3.employee_id 
		INNER JOIN order_details od3 ON o3.order_id = od3.order_id 
		INNER JOIN products p3 ON od3.product_id = p3.product_id 
		INNER JOIN categories c3 ON p3.category_id = c3.category_id
		GROUP BY c3.category_id
	) sales_per_category
	ON sales_per_category.category_id = employee_category_sales.category_id
) sales_per_employee_per_category
ORDER BY category_name ASC, total_sale_amount DESC