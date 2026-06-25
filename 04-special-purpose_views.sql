-- Views created for specific Power BI visuals (Pareto, buckets, distributions)





-- Top Regions by Revenue Share Pareto
CREATE OR REPLACE VIEW vw_pareto_revenue_region AS

WITH base AS (
	SELECT
		c.region,
		SUM(oi.price) AS revenue
	FROM vw_orders o
	JOIN order_items oi
	  ON oi.order_id = o.order_id
	JOIN vw_customers c
	  ON c.customer_id = o.customer_id
	GROUP BY 1
)

SELECT
	region,
	revenue,

	SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue,
	SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () AS cumulative_share,

	0.8 AS pareto_line
FROM base
ORDER BY 2 DESC;





-- Review Score by Delivery Bucket
CREATE OR REPLACE VIEW vw_delivery_bucket AS

SELECT
	CASE
		WHEN delivery_days <= 3 THEN '0-3 Days'
		WHEN delivery_days <= 7 THEN '4-7 Days'
		WHEN delivery_days <= 11 THEN '8-11 Days'
		WHEN delivery_days <= 15 THEN '12-15 Days'
		WHEN delivery_days <= 21 THEN '16-21 Days'
		WHEN delivery_days <= 30 THEN '22-30 Days'
		WHEN delivery_days <= 45 THEN '31-45 Days'
		WHEN delivery_days <= 60 THEN '46-60 Days'
		WHEN delivery_days <= 90 THEN '61-90 Days'
		ELSE '90+ Days'
	END AS delivery_bucket,	
	CASE
		WHEN delivery_days <= 3 THEN 1
		WHEN delivery_days <= 7 THEN 2
		WHEN delivery_days <= 11 THEN 3
		WHEN delivery_days <= 15 THEN 4
		WHEN delivery_days <= 21 THEN 5
		WHEN delivery_days <= 30 THEN 6
		WHEN delivery_days <= 45 THEN 7
		WHEN delivery_days <= 60 THEN 8
		WHEN delivery_days <= 90 THEN 9
		ELSE 10
	END AS delivery_bucket_sort,	
	COUNT(order_id) AS orders,
	ROUND(AVG(review_score), 2) AS avg_review_score
FROM vw_order_experience
WHERE delivery_days IS NOT NULL
GROUP BY 1, 2
ORDER BY 2





-- Review Score by Delay Bucket
CREATE OR REPLACE VIEW vw_delay_bucket AS

SELECT
	CASE
		WHEN delay_days = 0 THEN 'On Time'
		WHEN delay_days <= 3 THEN '1-3 Days'
		WHEN delay_days <= 7 THEN '4-7 Days'
		WHEN delay_days <= 14 THEN '8-14 Days'
		ELSE '15+ Days'
	END AS delay_bucket,
	ROUND(AVG(review_score), 2) AS avg_review,
	COUNT(*) AS orders
FROM vw_order_experience
WHERE is_late IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC;