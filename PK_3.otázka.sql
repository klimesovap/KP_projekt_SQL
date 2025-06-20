-- -- 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
SELECT 
    food_category,
    ROUND(AVG((avg_price / prev_year_price - 1) * 100), 2) AS avg_annual_increase_percent
FROM (
    SELECT 
        food_category,
        "year",
        ROUND(AVG(food_price)::NUMERIC, 2) AS avg_price,
        LAG(ROUND(AVG(food_price)::NUMERIC, 2)) OVER (PARTITION BY food_category ORDER BY "year") AS prev_year_price
    FROM t_petra_klimesova_project_SQL_primary_final
    GROUP BY 
    	food_category, 
    	"year"
	) AS yearly_changes
WHERE 
	prev_year_price IS NOT NULL
GROUP BY 
	food_category
ORDER BY 
	avg_annual_increase_percent;
