WITH monthly_revenue AS (
SELECT DATE_TRUNC('month', orders.order_purchase_timestamp) AS order_month,
SUM(order_payments.payment_value) AS revenue
FROM orders
JOIN order_payments ON orders.order_id=order_payments.order_id
GROUP BY order_month
),
with_previous AS (
SELECT order_month, revenue,
LAG(revenue) OVER  (ORDER BY order_month) AS prev_month_revenue
FROM monthly_revenue
)
SELECT order_month,
revenue,
prev_month_revenue,
ROUND(100.0*(revenue- prev_month_revenue) / prev_month_revenue, 2) AS pct_growth
FROM with_previous
ORDER BY order_month;
