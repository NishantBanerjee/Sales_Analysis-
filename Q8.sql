--Join relevant tables to find the category-wise distribution of pizzas.

SELECT
    pt.category,
    COUNT(pt.name) AS total_pizzas
FROM pizza_types AS pt
GROUP BY pt.category
ORDER BY total_pizzas DESC;