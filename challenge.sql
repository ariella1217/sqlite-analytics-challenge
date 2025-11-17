-- ============================================================
-- SQLite Analytics Coding Challenge
-- Tool Used: VS Code with SQLTools extension (SQLite driver)
-- Validation: Ran each query individually and verified results
--             against expected data patterns and totals
-- ============================================================

-- TASK 1: Top 5 Customers by Total Spend
-- Goal: Identify the five customers with highest lifetime spend
-- Logic: Calculate line totals (quantity × unit_price) at item level,
--        roll up to orders, then aggregate by customer
-- ============================================================

SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spend
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spend DESC
LIMIT 5;


-- TASK 2: Total Revenue by Product Category
-- Goal: Determine total revenue for each product category
-- Logic: Sum item line totals grouped by product category
-- ============================================================

-- Version A: All Orders (regardless of status)
SELECT 
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Version B: Delivered Orders Only (for comparison)
SELECT 
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_delivered
FROM products p
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'Delivered'
GROUP BY p.category
ORDER BY revenue_delivered DESC;


-- TASK 3: Employees Earning Above Their Department Average
-- Goal: List employees earning more than their department's average
-- Logic: Use subquery to calculate department averages, then compare
--        individual salaries to their respective department average
-- ============================================================

SELECT 
    e.first_name,
    e.last_name,
    d.name AS department_name,
    e.s