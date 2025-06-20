/* 5. otázka:
 * Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

-- vyjet 2. tabulku
SELECT *
FROM t_petra_klimesova_project_SQL_secondary_final;
 
CREATE TEMP table tt_petra_klimesova_project_SQL_secondary AS
	SELECT 
		pks.year,
		pks.gdp_mld,
		LAG(gdp_mld)OVER (ORDER BY "year")AS gdp_preV_year,
		ROUND((gdp_mld / LAG(gdp_mld) OVER (ORDER BY "year"))::NUMERIC*100, 2) AS gdp_comparison,
		pks.avg_wages,
		LAG(avg_wages)OVER (ORDER BY "year")AS wage_prev_year,
		ROUND(avg_wages/LAG(avg_wages)OVER (ORDER BY "year")::NUMERIC*100,2) AS wage_comparison,
		pks.avg_food_prices,
		LAG(avg_food_prices)OVER (ORDER BY "year")AS f_prices_prev_year,
		ROUND(avg_food_prices/LAG(avg_food_prices)OVER (ORDER BY "year")::NUMERIC*100,2) AS f_prices_comparison
	FROM t_petra_klimesova_project_SQL_secondary_final pks
	WHERE
		country = 'Czech Republic';

SELECT
	year,
	gdp_mld,
	gdp_comparison,
	wage_comparison,
	f_prices_comparison	
FROM tt_petra_klimesova_project_SQL_secondary;