SELECT e.first_name || ' ' || e.last_name AS employee_full_name,
e.title AS employee_title, 
round(CAST(sum(od.unit_price * od.quantity) AS numeric),2) AS total_sale_amount_excluding_discount,
count(DISTINCT od.order_id) AS number_unique_orders,
count(od.order_id) AS number_orders,
round(CAST(sum(od.unit_price * od.quantity)/count(od.order_id) AS numeric),2) AS average_product_amount,
round(CAST(sum(od.unit_price * od.quantity)/count(DISTINCT od.order_id) AS numeric),2) AS average_order_amount,
round(CAST(sum(od.unit_price * od.quantity * od.discount) AS numeric),2) AS total_discount_amount,
round(CAST(sum((od.unit_price * od.quantity)  - (od.unit_price * od.quantity * od.discount)) 
AS numeric),2) AS total_sale_amount_including_discount,
round(CAST((sum(od.unit_price * od.quantity * od.discount)/sum(od.unit_price * od.quantity))*100 AS numeric),2) 
AS total_discount_percentage
FROM employees e 
INNER JOIN orders o ON e.employee_id = o.employee_id 
INNER JOIN order_details od ON o.order_id = od.order_id 
GROUP BY employee_full_name, e.title
ORDER BY total_sale_amount_including_discount DESC