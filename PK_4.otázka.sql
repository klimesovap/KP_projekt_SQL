-- otazka č. 4) 4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
CREATE TEMP TABLE  temp_PK_avg_food_price_avg_wages AS
	SELECT 
		ROUND(AVG(food_price)::NUMERIC,2) AS avg_food_price,
		"year",
		ROUND(AVG(avg_wages)::NUMERIC,0) AS avg_wages
	FROM t_petra_klimesova_project_SQL_primary_final
	WHERE 
		industry_name IS NULL
		OR region_code IS NULL 
	GROUP BY 
		"year"
	ORDER BY
		"year";

--vyjet TEMP TABLE temp_PK_avg_food_price_avg_wages
SELECT *
FROM temp_PK_avg_food_price_avg_wages;

--výpočet růstu cen/mezd
CREATE TEMP TABLE temp_PK_food_wages_growth AS
	SELECT 
		avg_food_price,
		ROUND(avg_food_price/LAG(avg_food_price)OVER (ORDER BY "year")::NUMERIC *100, 2) AS food_price_growth,
		"year",
		avg_wages,
		ROUND(avg_wages/LAG(avg_wages)OVER (ORDER BY "year"):: NUMERIC*100, 2) AS wages_growth
		FROM temp_PK_avg_food_price_avg_wages;

--vyjet TEMP TABLE temp_PK_food_wages_growth
SELECT *
FROM temp_PK_food_wages_growth;

SELECT 
	"year",
	food_price_growth,
	wages_growth,
	food_price_growth - wages_growth AS growth_difference,
	CASE
		WHEN food_price_growth - wages_growth<-9 THEN 'výrazný pokles cen potravin vs mzdy'
		WHEN food_price_growth - wages_growth<0 THEN 'mírný pokles cen potravin vs mzdy'
		WHEN food_price_growth - wages_growth<10 THEN 'mírný nárůst cen potravin vs mzdy'
		ELSE 'význaný nárůst cen potravin vs mzdy'
	END AS growth_comparison
FROM temp_PK_food_wages_growth
WHERE
	"year" IN ('2007','2008','2009','2010','2011','2012','2013','2014','2015','2016');


