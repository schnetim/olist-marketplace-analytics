-- KPI layer for executive-level metrics and dashboard summary cards





CREATE OR REPLACE VIEW vw_kpi_summary AS

WITH order_value AS (
	SELECT
		oi.order_id,
		SUM(oi.price) AS order_value
	FROM order_items oi
	JOIN vw_orders o
	  ON o.order_id = oi.order_id
	GROUP BY 1
),

late_deliveries AS (
	SELECT
		CASE
			WHEN DATE_TRUNC('day', order_delivered_customer_date)
			   > DATE_TRUNC('day', order_estimated_delivery_date)
			THEN 1 ELSE 0
		END AS is_late
	FROM vw_orders
	WHERE order_status = 'delivered'
),

customer_orders AS (
	SELECT
		c.customer_unique_id,
		COUNT(*) AS purchases
	FROM vw_orders o
	JOIN customers c
	  ON c.customer_id = o.customer_id
	GROUP BY 1
)

SELECT
	(SELECT COUNT(DISTINCT oi.order_id) FROM order_items oi
	 JOIN vw_orders o ON o.order_id = oi.order_id) AS total_orders,

	(SELECT SUM(oi.price) FROM order_items oi
	 JOIN vw_orders o ON o.order_id = oi.order_id) AS total_revenue,

	(SELECT ROUND(AVG(order_value), 2) FROM order_value) AS average_order_value,

	(SELECT ROUND(AVG(review_score), 2) FROM order_reviews r
	 JOIN vw_orders o ON o.order_id = r.order_id) AS avg_review_score,

	(SELECT DATE_TRUNC('day', AVG(order_delivered_customer_date - order_purchase_timestamp))
	 FROM vw_orders WHERE order_status = 'delivered') AS avg_delivery_time,

	(SELECT ROUND(COUNT(*)::numeric / COUNT(DISTINCT oi.order_id), 2) FROM order_items oi
	 JOIN vw_orders o ON o.order_id = oi.order_id) AS avg_items_per_order,

	(SELECT ROUND(SUM(is_late)::numeric / COUNT(*) * 100, 2) FROM late_deliveries) AS late_delivery_rate,
	
	(SELECT ROUND(AVG(delay_days), 2) FROM vw_order_experience WHERE delay_days <> 0) AS avg_delay_days_late_orders,

	(SELECT ROUND(COUNT(*) FILTER (WHERE purchases > 1)::numeric / COUNT(*) * 100, 2)
	 FROM customer_orders) AS repeat_purchase_rate,

	(SELECT COUNT(DISTINCT c.customer_unique_id) FROM customers c
	 JOIN vw_orders o ON o.customer_id = c.customer_id) AS total_customers,

	(SELECT COUNT(DISTINCT s.seller_id) FROM sellers s
	 JOIN order_items oi ON oi.seller_id = s.seller_id
	 JOIN vw_orders o ON o.order_id = oi.order_id) AS total_sellers;