SELECT payment_type, COUNT(*) AS payment_count, SUM(payment_value) AS total_value
FROM order_payments
GROUP BY payment_type
ORDER BY payment_count DESC;