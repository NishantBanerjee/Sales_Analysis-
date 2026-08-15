--Determine the distribution of orders by hour of the day.

SELECT
    EXTRACT(HOUR FROM time) AS order_hour,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;