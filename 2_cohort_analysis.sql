SELECT
	cohort_year,
	sum(total_net_revenue) AS total_revenue,
	count(DISTINCT customerkey) AS total_customers,
	sum(total_net_revenue) / count(DISTINCT customerkey) AS customer_revenue
FROM
	cohort_analysis
GROUP BY
	cohort_year
