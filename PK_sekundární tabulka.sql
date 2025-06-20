-- vytvořit 2. tabulku
CREATE TABLE t_petra_klimesova_project_SQL_secondary_final AS
	SELECT
		e.year,
		ROUND(e.gdp) AS gdp_mld,
		ROUND(AVG(cpay.value)) AS avg_wages,
		ROUND(AVG(cp.value)::NUMERIC, 2) AS avg_food_prices,
		c.country,
		e.gini AS gini_coefficient,
		c.population
	FROM economies e
	LEFT JOIN czechia_payroll cpay 
		ON cpay.payroll_year = e.year
	LEFT JOIN (
		SELECT 
			value,
			EXTRACT(YEAR FROM date_from) AS year
			FROM czechia_price
			) cp ON cp.year = e.year
	LEFT JOIN countries c
		ON c.country = e.country
	WHERE 
		c.continent = 'Europe'
		AND e.year > 2005
		AND e.year < 2017
	GROUP BY 
		e.year,
		e.gdp,
		c.country,
		e.gini,
		c.population
	ORDER BY
		c.country,
		e.year ASC;

-- vyjet 2. tabulku
SELECT *
FROM t_petra_klimesova_project_SQL_secondary_final;

-- smazat 2. tabulku
DROP TABLE IF EXISTS t_petra_klimesova_project_SQL_secondary_final;
