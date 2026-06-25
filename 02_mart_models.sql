-- Analytical mart models for reporting in Power BI
-- Aggregations at region, category and experience level





-- Monthly growth metrics for trend analysis

CREATE OR REPLACE VIEW vw_growth_metrics AS

WITH monthly_metrics AS (
	SELECT
		DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
		COUNT(DISTINCT s.seller_id) AS sellers,
		COUNT(DISTINCT p.product_id) AS products,
		COUNT(DISTINCT c.customer_unique_id) AS customers,
		COUNT(DISTINCT oi.order_id) AS orders,
		SUM(oi.price) AS revenue,
		ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id), 2) AS average_order_value
	FROM vw_orders o
	LEFT JOIN order_items oi
	 ON oi.order_id = o.order_id
	LEFT JOIN sellers s
	  ON s.seller_id = oi.seller_id
	LEFT JOIN vw_products p
	  ON p.product_id = oi.product_id
	LEFT JOIN customers c
		  ON c.customer_id = o.customer_id
	GROUP BY 1
)

SELECT

	month,
	sellers,
	products,
	customers,
	orders,
	revenue,
	average_order_value,

	-- efficiency metrics
	ROUND(revenue / customers, 2) AS revenue_per_customer,
	ROUND(revenue / sellers, 2) AS revenue_per_seller,
	ROUND(revenue / products, 2) AS revenue_per_product,

	ROUND(orders::numeric / customers, 2) AS orders_per_customer,
	ROUND(orders::numeric / sellers, 2) AS orders_per_seller,
	ROUND(orders::numeric / products, 2) AS orders_per_product,

	ROUND(customers / sellers, 2) AS customers_per_seller,
	ROUND(sellers::numeric / customers, 2) AS sellers_per_customer,

	-- growth
	ROUND((sellers - LAG(sellers) OVER (ORDER BY month)) / LAG(sellers) OVER (ORDER BY month)::numeric, 2) AS sellers_growth_rate,
	ROUND((products - LAG(products) OVER (ORDER BY month)) / LAG(products) OVER (ORDER BY month)::numeric, 2) AS products_growth_rate,
	ROUND((customers - LAG(customers) OVER (ORDER BY month)) / LAG(customers) OVER (ORDER BY month)::numeric, 2) AS customers_growth_rate,
	ROUND((orders - LAG(orders) OVER (ORDER BY month)) / LAG(orders) OVER (ORDER BY month)::numeric, 2) AS orders_growth_rate,
	ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month)::numeric, 2) AS revenue_growth_rate
	
FROM monthly_metrics






-- Customer region performance metrics

CREATE OR REPLACE VIEW vw_customer_region AS

WITH regional_metrics AS (
	SELECT
		c.region,
		COUNT(DISTINCT s.seller_id) AS sellers,
		COUNT(DISTINCT p.product_id) AS products,
		COUNT(DISTINCT c.customer_unique_id) AS customers,
		COUNT(DISTINCT oi.order_id) AS orders,
		SUM(oi.price) AS revenue,
		ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id), 2) AS average_order_value
	FROM vw_orders o
	LEFT JOIN order_items oi
	 ON oi.order_id = o.order_id
	LEFT JOIN sellers s
	  ON s.seller_id = oi.seller_id
	LEFT JOIN vw_products p
	  ON p.product_id = oi.product_id
	LEFT JOIN vw_customers c
		  ON c.customer_id = o.customer_id
	GROUP BY 1
)

SELECT

	region,
	sellers,
	products,
	customers,
	orders,
	revenue,
	average_order_value,

	-- efficiency metrics
	ROUND(revenue / customers, 2) AS revenue_per_customer,
	ROUND(revenue / sellers, 2) AS revenue_per_seller,
	ROUND(revenue / products, 2) AS revenue_per_product,

	ROUND(orders::numeric / customers, 2) AS orders_per_customer,
	ROUND(orders::numeric / sellers, 2) AS orders_per_seller,
	ROUND(orders::numeric / products, 2) AS orders_per_product,

	ROUND(customers::numeric / sellers, 2) AS customers_per_seller,
	ROUND(sellers::numeric / customers, 2) AS sellers_per_customer,

	ROUND(revenue / SUM(revenue) OVER(), 2) AS revenue_share,
	ROUND(customers / SUM(customers) OVER(), 2) AS customer_share

FROM regional_metrics;





-- Product category performance metrics

CREATE OR REPLACE VIEW vw_product_category AS

WITH category_metrics AS (
	SELECT
		p.product_category_name_english AS category,
		COUNT(DISTINCT s.seller_id) AS sellers,
		COUNT(DISTINCT p.product_id) AS products,
		COUNT(DISTINCT c.customer_unique_id) AS customers,
		COUNT(DISTINCT oi.order_id) AS orders,
		SUM(oi.price) AS revenue,
		ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id), 2) AS average_order_value
	FROM vw_orders o
	LEFT JOIN order_items oi
	 ON oi.order_id = o.order_id
	LEFT JOIN sellers s
	  ON s.seller_id = oi.seller_id
	LEFT JOIN vw_products p
	  ON p.product_id = oi.product_id
	LEFT JOIN vw_customers c
		  ON c.customer_id = o.customer_id
	GROUP BY 1
)

SELECT

	category,
	sellers,
	products,
	customers,
	orders,
	revenue,
	average_order_value,

	-- efficiency metrics
	ROUND(revenue / customers, 2) AS revenue_per_customer,
	ROUND(revenue / sellers, 2) AS revenue_per_seller,
	ROUND(revenue / products, 2) AS revenue_per_product,

	ROUND(orders::numeric / customers, 2) AS orders_per_customer,
	ROUND(orders::numeric / sellers, 2) AS orders_per_seller,
	ROUND(orders::numeric / products, 2) AS orders_per_product,

	ROUND(customers::numeric / sellers, 2) AS customers_per_seller,
	ROUND(sellers::numeric / customers, 2) AS sellers_per_customer,

	ROUND(revenue / SUM(revenue) OVER(), 2) AS revenue_share,
	ROUND(customers / SUM(customers) OVER(), 2) AS customer_share

FROM category_metrics;





-- Delivery experience and review linkage at order level

CREATE OR REPLACE VIEW vw_order_experience AS

WITH reviews AS (
	SELECT
		o.order_id,
		AVG(review_score) AS review_score
	FROM order_reviews r
	JOIN vw_orders o 
	  ON o.order_id = r.order_id
	GROUP BY 1
),

order_items_agg AS (
	SELECT
		oi.order_id,
		SUM(price) AS revenue
	FROM order_items oi
	JOIN vw_orders o
	  ON o.order_id = oi.order_id
	GROUP BY 1
)

SELECT
	o.order_id,
	o.order_purchase_timestamp,
	o.order_delivered_customer_date,
	o.order_status,
	oi.revenue,
	r.review_score,
	
	CASE 
		WHEN r.review_score >= 4 THEN 'Positive' 
		WHEN r.review_score = 3 THEN 'Neutral' 
		ELSE 'Negative' 
	END AS review_sentiment,
	
	CASE 
		WHEN oi.order_id IS NOT NULL THEN TRUE 
		ELSE FALSE 
	END AS has_items,
	
	EXTRACT(day FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) AS delivery_days,
	
	CASE 
		WHEN o.order_status <> 'delivered' THEN NULL
		WHEN DATE_TRUNC('day', o.order_delivered_customer_date) 
	       > DATE_TRUNC('day', o.order_estimated_delivery_date) THEN 1 
		ELSE 0 
	END AS is_late,
	
	GREATEST(EXTRACT(day FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date)), 0) AS delay_days,
	GREATEST(EXTRACT(day FROM (o.order_estimated_delivery_date - o.order_delivered_customer_date)), 0) AS early_days

FROM vw_orders o
JOIN order_items_agg oi
  ON oi.order_id = o.order_id
LEFT JOIN reviews r
  ON r.order_id = o.order_id;
  
  







