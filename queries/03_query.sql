SELECT e.first_name || ' ' || e.last_name AS employee_full_name, 
e.title AS employee_title, 
EXTRACT (YEAR FROM age(e.hire_date, e.birth_date)) AS employee_age, 
EXTRACT (YEAR FROM age(CURRENT_DATE, e.hire_date)) AS employee_tenure,
m.first_name || ' ' || m.last_name AS manager_full_name,
m.title AS manager_title
FROM employees e 
LEFT JOIN employees m ON e.reports_to = m.employee_id
ORDER BY employee_age, employee_full_name