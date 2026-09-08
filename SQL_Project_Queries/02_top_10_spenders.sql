SELECT customers.customer_unique_id, SUM(order_payments.payment_value) AS total_spent
FROM order_payments
JOIN orders ON order_payments.order_id= orders.order_id
JOIN customers ON orders.customer_id= customers.customer_id
GROUP BY customers.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;