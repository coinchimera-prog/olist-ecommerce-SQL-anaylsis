# Project Introduction
Data analysis of Olist e-commerce data using PostgreSQL. 
The Olist-Ecommcerce data contains about 100,000 real orders from Olist, an E-commerce marketplace located in Brazil. The data contains information on customers, orders, products, payments, and reviews across nine different tables (CSV files).

Link to dataset: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Link to licence: https://creativecommons.org/licenses/by-nc-sa/4.0/


To conduct the analysis, PostgreSQL was used to find relevant business insights pertaining to the data. 

NOTE: Generative AI was used to assist in writing SQL queries and brainstorm business questions.


# SQL Queries and Findings for Data
Below are 7 business insights found during the analysis, as well as the SQL queries used to find them:


1. Revenue by Product Category (Top 10) In English

```sql
SELECT product_category_name_translation.product_category_name_english, SUM(order_items.price) AS total_revenue
FROM order_items
JOIN products ON order_items.product_id=products.product_id
JOIN product_category_name_translation ON products.product_category_name=product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;
```
Findings:
Health/beauty and watches/gifts had the highest total revenue at $1.26 million and $1.2 million respectively. 


2. Top Spending Customers (Top 10, and displays customer ids instead of names for anonimity)

```sql
SELECT customers.customer_unique_id, SUM(order_payments.payment_value) AS total_spent
FROM order_payments
JOIN orders ON order_payments.order_id= orders.order_id
JOIN customers ON orders.customer_id= customers.customer_id
GROUP BY customers.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;
```
Findings:
Customer_ID of top 10 spenders.


3. Order Status

```sql
SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
```
Findings:
About 97% of all orders were delivered successfully. Order cancellation sat at 0.60% and 'unavailable' (out of stock) sat at 0.61%.


4. Payment Methods

```sql
SELECT payment_type, COUNT(*) AS payment_count, SUM(payment_value) AS total_value
FROM order_payments
GROUP BY payment_type
ORDER BY payment_count DESC;
```
Finding:
Credit card was the most significant payment method, accounting for ~ 74% of all payments (76,795). Boleto, a Brazilian bank slip payment was the second most common payment method accounting for ~19% of payments.


5.Monthly Order Volume

```sql
SELECT DATE_TRUNC('month', order_purchase_timestamp) AS order_month, COUNT(*) AS order_count
FROM orders
GROUP BY order_month
ORDER BY order_month;
```
Findings:
Volume of orders increases significantly in late 2016 to a steady 6,000-7,000 orders per month by 2018. Order peak was on November, 2017 at 7,544 orders.


6. Above Average Spenders
```sql
WITH customer_spend AS(
SELECT customers.customer_unique_id, SUM(order_payments.payment_value) AS total_spent
FROM order_payments
JOIN orders ON order_payments.order_id= orders.order_id
JOIN customers ON orders.customer_id= customers.customer_id
GROUP BY customers.customer_unique_id
)
SELECT COUNT(*) AS total_customers,
ROUND(AVG(total_spent), 2) AS overall_avg_spend,
COUNT(*) FILTER (WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spend)) AS above _average_customers
FROM customer_spend;
```
Findings:





7. Month to Month Revenue Growth

```sql
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
```




