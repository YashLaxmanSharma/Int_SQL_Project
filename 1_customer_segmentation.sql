WITH customer_ltv AS (
	SELECT
		customerkey,
		full_name,
		sum(total_net_revenue) AS total_ltv
	FROM
		cohort_analysis
	GROUP BY
		customerkey,
		full_name
),
customer_segments AS (
	SELECT
		percentile_cont(0.25) WITHIN GROUP (
		ORDER BY
			total_ltv
		) AS ltv_25th_percentile,
		percentile_cont(0.75) WITHIN GROUP (
		ORDER BY
			total_ltv
		) AS ltv_75th_percentile
	FROM
		customer_ltv
),
segment_values AS (
	SELECT
		customer_ltv.*,
		CASE
			WHEN customer_ltv.total_ltv < customer_segments.ltv_25th_percentile THEN 'LOW value'
			WHEN customer_ltv.total_ltv > customer_segments.ltv_75th_percentile THEN 'HIGH value'
			ELSE 'MID value'
		END AS customer_segment
	FROM
		customer_ltv,
		customer_segments
) 
SELECT
	customer_segment,
	sum(total_ltv) AS total_ltv,
	count(customerkey) AS cusotmer_count,
	sum(total_ltv) / count(customerkey) AS avg_ltv
FROM
	segment_values
GROUP BY
	customer_segment