--Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT
    ROUND(AVG(total_pizzas), 2) AS average_pizzas_per_day
FROM (
    SELECT
        o.date,
        SUM(od.quantity) AS total_pizzas
    FROM orders AS o
    JOIN order_details AS od
        ON o.order_id = od.order_id
    GROUP BY o.date
) AS daily_orders;