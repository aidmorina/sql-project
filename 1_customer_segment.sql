WITH customer_ltv AS (
	SELECT 
		customerkey,
		cleaned_name,
		sum(total_net_revenue) AS total_ltv
	FROM cohort_analysis
	GROUP BY
		customerkey,
		cleaned_name
),customer_segments AS (
	SELECT 
		PERCENTILE_CONT(0.25) within group (order by total_ltv)as ltv_25th_percentile,
		PERCENTILE_CONT(0.75) within group (order by total_ltv)as ltv_75th_percentile
	FROM customer_ltv
),segment_value as (
	SELECT
		c.*,
		CASE
			WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - low value '
			WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2 - MID value '
			ELSE '3-HIGH PERCENTILE'
		end as customer_segment
	FROM 
		customer_ltv c
	JOIN 
	    customer_segments cs ON true
)
SELECT
	customer_segment,
	SUM(total_ltv )as tototal_ltv ,
	COUNT(customerkey) as customer_count,
	SUM(total_ltv)/ COUNT(customerkey) as avg_ltv
FROM segment_value 
group by 
	customer_segment 
