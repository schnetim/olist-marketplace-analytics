-- Base models for cleaning and standardizing core tables
-- Includes filtering, basic transformations and dimension enrichment





-- Orders filtered to analysis period (Jan 2017 - Aug 2018) and valid transactions

CREATE OR REPLACE VIEW vw_orders AS

SELECT DISTINCT o.*
FROM orders o
JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'





-- Customer data with full state names

  CREATE OR REPLACE VIEW vw_customers AS

SELECT
	*,
	CASE customer_state
		WHEN 'AC' THEN 'Acre'
		WHEN 'AL' THEN 'Alagoas'
		WHEN 'AM' THEN 'Amazonas'
		WHEN 'AP' THEN 'Amapa'
		WHEN 'BA' THEN 'Bahia'
		WHEN 'CE' THEN 'Ceara'
		WHEN 'DF' THEN 'Distrito Federal'
		WHEN 'ES' THEN 'Espirito Santo'
		WHEN 'GO' THEN 'Goias'
		WHEN 'MA' THEN 'Maranhao'
		WHEN 'MG' THEN 'Minas Gerais'
		WHEN 'MS' THEN 'Mato Grosso do Sul'
		WHEN 'MT' THEN 'Mato Grosso'
		WHEN 'PA' THEN 'Para'
		WHEN 'PB' THEN 'Paraiba'
		WHEN 'PE' THEN 'Pernambuco'
		WHEN 'PI' THEN 'Piaui'
		WHEN 'PR' THEN 'Parana'
		WHEN 'RJ' THEN 'Rio de Janeiro'
		WHEN 'RN' THEN 'Rio Grande do Norte'
		WHEN 'RO' THEN 'Rondonia'
		WHEN 'RR' THEN 'Roraima'
		WHEN 'RS' THEN 'Rio Grande do Sul'
		WHEN 'SC' THEN 'Santa Catarina'
		WHEN 'SE' THEN 'Sergipe'
		WHEN 'SP' THEN 'Sao Paulo'
		WHEN 'TO' THEN 'Tocantins'
	END AS region
FROM customers





-- Seller data with full state names

CREATE OR REPLACE VIEW vw_sellers AS

SELECT
	*,
	CASE seller_state
		WHEN 'AC' THEN 'Acre'
		WHEN 'AL' THEN 'Alagoas'
		WHEN 'AM' THEN 'Amazonas'
		WHEN 'AP' THEN 'Amapa'
		WHEN 'BA' THEN 'Bahia'
		WHEN 'CE' THEN 'Ceara'
		WHEN 'DF' THEN 'Distrito Federal'
		WHEN 'ES' THEN 'Espirito Santo'
		WHEN 'GO' THEN 'Goias'
		WHEN 'MA' THEN 'Maranhao'
		WHEN 'MG' THEN 'Minas Gerais'
		WHEN 'MS' THEN 'Mato Grosso do Sul'
		WHEN 'MT' THEN 'Mato Grosso'
		WHEN 'PA' THEN 'Para'
		WHEN 'PB' THEN 'Paraiba'
		WHEN 'PE' THEN 'Pernambuco'
		WHEN 'PI' THEN 'Piaui'
		WHEN 'PR' THEN 'Parana'
		WHEN 'RJ' THEN 'Rio de Janeiro'
		WHEN 'RN' THEN 'Rio Grande do Norte'
		WHEN 'RO' THEN 'Rondonia'
		WHEN 'RR' THEN 'Roraima'
		WHEN 'RS' THEN 'Rio Grande do Sul'
		WHEN 'SC' THEN 'Santa Catarina'
		WHEN 'SE' THEN 'Sergipe'
		WHEN 'SP' THEN 'Sao Paulo'
		WHEN 'TO' THEN 'Tocantins'
	END AS region
FROM sellers





-- Product categories cleaned and standardized

CREATE OR REPLACE VIEW vw_products AS

SELECT
	p.*,
	COALESCE(
		CASE
			WHEN pcn.product_category_name_english = 'fashio_female_clothing'
			THEN 'Fashion Female Clothing'
			WHEN pcn.product_category_name_english = 'home_comfort_2'
			THEN 'Home Comfort'
			WHEN pcn.product_category_name_english = 'home_appliances_2'
			THEN 'Home Appliances'
			WHEN pcn.product_category_name_english = 'la_cuisine'
			THEN 'Kitchen'
			ELSE INITCAP(REPLACE(pcn.product_category_name_english, '_', ' '))
		END,
		'Unknown'
		) AS product_category_name_english
FROM products p 
LEFT JOIN product_category_name pcn
  ON pcn.product_category_name = p.product_category_name;





