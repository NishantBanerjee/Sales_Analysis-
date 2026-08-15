--List the top 5 most ordered pizza types along with their quantities.

SELECT pt.name,COUNT(od.quantity) AS pizzas_ordered
FROM order_details AS od
JOIN pizzas AS p 
ON p.pizza_id = od.pizza_id
JOIN pizza_types AS pt
ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY pizzas_ordered desc
LIMIT 5;
