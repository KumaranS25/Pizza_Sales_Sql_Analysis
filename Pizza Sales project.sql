use pizza;

-- Retrieve the total number of orders placed.
select COUNT(*) as total_orders
from orders;

-- Calculate the total revenue generated from pizza sales.
select 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
from order_details od
join pizzas p on od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
select 
    pt.name, 
    p.size, 
    p.price
from pizzas p
join pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
order by p.price DESC
limit 1;

-- Identify the most common pizza size ordered.
select
    p.size, SUM(od.quantity) AS total_ordered
from
    order_details od
        join
    pizzas p on od.pizza_id = p.pizza_id
group by size
order by total_ordered DESC
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select 
    pt.name as pizza_name, 
    SUM(od.quantity) as total_quantity_ordered
from order_details od
join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_quantity_ordered DESC
limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered
select 
    pt.category, 
    SUM(od.quantity) AS total_quantity_ordered
from order_details od
join pizzas p ON od.pizza_id = p.pizza_id
join pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
group by pt.category
order by total_quantity_ordered DESC;

-- Determine the distribution of orders by hour of the day.
select 
    EXTRACT(HOUR FROM date) AS order_hour,
    COUNT(*) AS total_orders
from orders
group by order_hour
order by order_hour;

-- Join relevant tables to find the category-wise distribution of pizzas.
select
    pt.category, 
    COUNT(DISTINCT p.pizza_id) as total_pizza_types
from pizzas p
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category
order by total_pizza_types DESC;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
with daily_pizza_counts AS (
    select 
        date(o.date) as order_date,
        SUM(od.quantity) as pizzas_ordered
    from orders o
    join order_details od ON o.order_id = od.order_id
    group by date (o.date)
)
select
    ROUND(avg(pizzas_ordered), 2) as avg_pizzas_per_day
from daily_pizza_counts;


-- Determine the top 3 most ordered pizza types based on revenue
select
    pt.name as pizza_name,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
from order_details od
join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_revenue DESC
limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
with pizza_revenue as (
    select 
        pt.name as pizza_name,
        SUM(od.quantity * p.price) as revenue
    from order_details od
    join pizzas p on od.pizza_id = p.pizza_id
    join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
    group by pt.name
),
total as (
    select SUM(revenue) as total_revenue from pizza_revenue
)
select 
    pr.pizza_name,
    ROUND(pr.revenue, 2) as revenue,
    ROUND((pr.revenue / t.total_revenue) * 100, 2) as revenue_percentage
from pizza_revenue pr, total t
order by revenue_percentage desc;










