# Olist Marketplace Analytics: Growth, Revenue Drivers & Customer Experience (SQL + Power BI)

End-to-end business intelligence analysis of a multi-category e-commerce marketplace (Olist).

The project explores how **growth, revenue, and customer experience** are driven by customer demand, geographic concentration, product mix, and operational performance.

---

## Key Insights (TL;DR)

- Growth is driven by customer acquisition, not increased order value per customer
- Revenue is highly concentrated in a small number of regions and product categories
- Delivery performance is the strongest driver of customer satisfaction
- Operational inefficiencies exist in the long tail of delivery performance

---

## Dashboard Overview

The dashboard is structured into three analytical layers that progressively move from high-level business performance to operational deep dives:

### Page 1: Marketplace Health

<img width="2382" height="1340" alt="page1_marketplace_health" src="https://github.com/user-attachments/assets/7bc8182e-b95a-4251-a3f9-7e254d4b1fb4" />


Analysis of overall marketplace growth, including revenue, customer base and seller activity over time.

---

### Page 2: Revenue Drivers

<img width="2382" height="1340" alt="page2_revenue_drivers" src="https://github.com/user-attachments/assets/a993d7db-2f02-4bfc-9fad-5775e375f9b1" />


Analysis of geographic concentration and product category performance, identifying the primary drivers of revenue generation.

---

### Page 3: Customer Experience & Operations

<img width="2382" height="1340" alt="page3_customer_experience" src="https://github.com/user-attachments/assets/a1ee8472-58ce-4b27-ab98-95fea848cc9c" />


Analysis of delivery performance, order fulfillment and its direct impact on customer satisfaction and review behavior.

---

## Business Questions

- How does the marketplace grow over time?
- What drives revenue across regions and product categories?
- How does delivery performance impact customer satisfaction?
- Which operational bottlenecks exist in the order lifecycle?

---

## Dataset Context

The analysis is based on the Olist e-commerce marketplace dataset, a real-world Brazilian marketplace connecting customers, sellers and logistics providers.

It includes full order lifecycle data such as purchases, deliveries, customer reviews, and seller information, enabling end-to-end marketplace analysis from transaction to customer experience.

---

## Analytical Approach

The analysis was conducted using a layered SQL modeling approach:

- Data cleaning and preparation via SQL views
- Aggregation of business KPIs across customers, sellers, products and orders
- Construction of analytical datasets for Power BI reporting
- Focus on business-ready metrics rather than raw transactional data

---

## Detailed Insights

### Marketplace Growth

- Growth is primarily driven by customer acquisition rather than increases in order value per customer
- Revenue and active customers scale in parallel, while AOV and revenue per customer remain structurally stable over time
- Demand growth is steady but not linear, influenced by seasonality, campaigns, and product cycles
- Supply-side (active sellers) grows consistently, showing a stable and less volatile expansion pattern compared to demand

---

### Revenue Drivers

- Revenue is highly concentrated in a small number of geographic regions
- Market expansion is driven by customer volume rather than differences in customer spending behavior
- The business is strongly dependent on a limited number of high-population states, enabling focused marketing but increasing regional dependency
- High-volume product categories dominate total revenue, while premium categories contribute less due to low transaction frequency despite higher order values

---

### Customer Experience & Operations

- Delivery time is a key driver of customer satisfaction, with strong and non-linear degradation in ratings as delays increase
- However, delivery delays explain only part of negative customer reviews, indicating additional factors such as product quality, expectations, or service experience
- Approximately ~97% of orders are successfully delivered, ensuring overall rating stability despite operational frictions
- Order fulfillment status is a structural determinant of customer experience, with non-delivered states (e.g., shipped, processing, canceled) showing significantly lower review scores than completed deliveries

---

## Tech Stack

- SQL (PostgreSQL)
- Power BI
