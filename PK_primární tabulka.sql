-- tvorba 1. tabulky
CREATE TABLE t_petra_klimesova_project_SQL_primary_final AS
	SELECT
		cpc."name" AS food_category,
		ROUND(AVG(cp.value)::numeric,2) AS food_price,
		AVG(cpc.price_value) AS price_value,
		cpc.price_unit AS price_unit,
		cp.region_code,
		cr.name,		
		EXTRACT(YEAR FROM cp.date_from) AS "year",
		cpib.name AS industry_name,
		ROUND(AVG(cpay.value)::NUMERIC,0) AS avg_wages		
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc
		ON cpc.code = cp.category_code
	LEFT JOIN czechia_payroll cpay
		ON EXTRACT(YEAR FROM cp.date_from) = cpay.payroll_year
	LEFT JOIN czechia_payroll_industry_branch cpib
		ON cpib.code = cpay.industry_branch_code
	LEFT JOIN czechia_region cr
		ON cr.code=cp.region_code
	WHERE 
		cpay.value_type_code = 5958
		AND EXTRACT(YEAR FROM cp.date_from) > 2005
		AND EXTRACT(YEAR FROM cp.date_from) < 2017
	GROUP BY 
		cpc."name",
		cpc.price_unit,
		EXTRACT(YEAR FROM cp.date_from),
		cpib.name,
		cp.region_code,
		cr.name
	ORDER BY 
		"year" ASC;

-- vyjet 1. tabulku
SELECT *
FROM t_petra_klimesova_project_SQL_primary_final;

--smazat 1. tabulku
DROP TABLE t_petra_klimesova_project_SQL_primary_final;