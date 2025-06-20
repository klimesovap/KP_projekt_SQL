--2) Kolik je možné koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- zaokrouhlí striktně dolů, protože nemůžu koupit cca více litrů, ale jen na co mám

SELECT 
	food_category,
	"year",
	ROUND(AVG(food_price),2) AS avg_price,
	avg_wages,
	FLOOR(avg_wages/AVG(food_price)) AS quantity_affordable
FROM 
	t_petra_klimesova_project_SQL_primary_final
WHERE 
	(food_category = 'Mléko polotučné pasterované' 
 	OR food_category = 'Chléb konzumní kmínový')
	AND ("year" = 2006 OR "year" = 2016)
	AND industry_name IS NULL
GROUP BY 
	food_category,
	"year",
	avg_wages 
ORDER BY 
	food_category,
	"year";

