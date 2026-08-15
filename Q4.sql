--Identify the most common pizza size ordered.

SELECT
    p.size,
    SUM(od.quantity) AS total_orders
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_orders DESC
LIMIT 1;