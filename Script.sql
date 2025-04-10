CREATE VIEW  cohort_analysis AS 
WITH costumer_revenue AS (	
	SELECT s.customerkey,s.orderdate,
	SUM(s.quantity * s.netprice * s.exchangerate)AS total_net_revenue,
	COUNT(s.orderkey) ,
	c.countryfull ,
	c.age,
	c.givenname,
	c.surname
	
	
FROM sales 
LEFT JOIN customer c  ON c.customerkey = s.customerkey
GROUP BY
	
	s.custumerkey,
	s.orderdate,
	c.countryfull ,
	c.age,
	c.givenname,
	c.surname
)
SELECT 
	cr.*,
	MIN(cr.orderdate)OVER (PARTITION BY cr.customerkey  ) AS first_purchase_date,
	EXTRACT (YEAR FROM MIN(cr.orderdate)OVER (PARTITION BY cr.customerkey  ) )AS cohort_year
FROM costumer_revenue cr




