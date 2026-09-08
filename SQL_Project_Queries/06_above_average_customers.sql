WITH customer_spend AS(
SELECT customers.customer_unique_id, SUM(order_payments.payment_value) AS total_spent
FROM order_payments
JOIN orders ON order_payments.order_id= orders.order_id
JOIN customers ON orders.customer_id= customers.customer_id
GROUP BY customers.customer_unique_id
)
SELECT COUNT(*) AS total_customers,
ROUND(AVG(total_spent), 2) AS overall_avg_spend,
COUNT(*) FILTER (WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spend)) AS above_average_customers
FROM customer_spend;