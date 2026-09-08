SELECT DATE_TRUNC('month', order_purchase_timestamp) AS order_month, COUNT(*) AS order_count
FROM orders
GROUP BY order_month
ORDER BY order_month;