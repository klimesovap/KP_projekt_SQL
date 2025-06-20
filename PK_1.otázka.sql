--1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
CREATE TEMP TABLE tt_pk_wage_growth AS
	SELECT 
		"year", 
		industry_name, 
		avg_wages,
		LAG(avg_wages)OVER(PARTITION BY industry_name ORDER BY "year") AS previous_avg_wages,
		ROUND(((avg_wages/LAG(avg_wages) OVER (PARTITION BY industry_name ORDER BY "year"))::NUMERIC)*100, 2) AS year_wages_comparison
	FROM 
		t_petra_klimesova_project_SQL_primary_final
	GROUP BY 
		"year",
		industry_name,
		avg_wages 
	ORDER BY 
		industry_name,
		"year";

SELECT *
FROM tt_pk_wage_growth;

SELECT 
	"year",
	industry_name,
	year_wages_comparison,
	CASE
			WHEN year_wages_comparison > 100 THEN 'mzdy rostou'
			WHEN year_wages_comparison = 100 THEN 'mzdy zůstaly stejné'
			WHEN year_wages_comparison IS NULL THEN 'není srovnání s předchozím rokem'
			--WHEN year_wages_comparison < 100 THEN 'mzdy klesají'
			ELSE 'mzdy klesají'
		END AS wage_growth
FROM tt_pk_wage_growth
WHERE 
	year_wages_comparison IS NOT NULL
GROUP BY
	"year",
	industry_name,
	year_wages_comparison
ORDER BY 
	wage_growth, 
	"year",
	industry_name;