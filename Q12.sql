--Analyze the cumulative revenue generated over time.

SELECT
    order_date,
    revenue,
    SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT
        o.date AS order_date,
        ROUND(SUM(od.quantity * p.price), 2) AS revenue
    FROM orders AS o
    JOIN order_details AS od
        ON o.order_id = od.order_id
    JOIN pizzas AS p
        ON od.pizza_id = p.pizza_id
    GROUP BY o.date
) AS daily_revenue;