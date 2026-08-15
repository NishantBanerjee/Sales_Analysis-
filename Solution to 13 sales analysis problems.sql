--Retrieve the total number of orders placed.

SELECT COUNT(order_id) AS total_orders
FROM orders;

--Calculate the total revenue generated from pizza sales.

SELECT
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id;

--Identify the highest-priced pizza.

SELECT pizza_types.name,pizzas.price 
FROM pizza_types 
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price desc
LIMIT 1;


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


--Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT
    pt.category,
    SUM(od.quantity) AS total_quantity
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;


--Determine the distribution of orders by hour of the day.

SELECT
    EXTRACT(HOUR FROM time) AS order_hour,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;


--Join relevant tables to find the category-wise distribution of pizzas.

SELECT
    pt.category,
    COUNT(pt.name) AS total_pizzas
FROM pizza_types AS pt
GROUP BY pt.category
ORDER BY total_pizzas DESC;


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


--Determine the top 3 most ordered pizza types based on revenue.

SELECT
    pt.name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;


--Calculate the percentage contribution of each pizza type to total revenue.

SELECT
    pt.name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    ROUND(
        SUM(od.quantity * p.price) * 100 /
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2
         JOIN pizzas p2
             ON od2.pizza_id = p2.pizza_id),
        2
    ) AS revenue_percentage
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC;


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


   --Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT *
FROM (
    SELECT
        pt.category,
        pt.name,
        ROUND(SUM(od.quantity * p.price), 2) AS revenue,
        RANK() OVER (
            PARTITION BY pt.category
            ORDER BY SUM(od.quantity * p.price) DESC
        ) AS rank
    FROM order_details AS od
    JOIN pizzas AS p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types AS pt
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
) ranked_pizzas
WHERE rank <= 3;

