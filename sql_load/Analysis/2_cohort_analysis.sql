-- cohort years (2012-2018)
SELECT Enrollment_Year AS Cohort_Year,
        COUNT(loyalty_number) AS total_enrolled
FROM customer_loyalty_history
GROUP BY enrollment_year
ORDER BY
    total_enrolled DESC;

-- how much CLV (Customer lifetime value) did each cohort generate?

SELECT 
    enrollment_year,
    SUM(CLV) AS total_clv
FROM
    customer_loyalty_history
GROUP BY
    enrollment_year
ORDER BY
    total_clv DESC;

-- What percentage of 2018's CLV belongs to the customers who joined during the promotion?

-- Total CLV for all 2018 enrollments

SELECT 
    Total_2018_CLV AS Cohort,
    SUM(CLV) AS CLV_Value
FROM customer_loyalty_history
WHERE enrollment_year = 2018

UNION ALL

-- CLV for Feb–Apr 2018 promo cohort

SELECT 
    Promo_CLV AS Cohort,
    SUM(CLV) AS CLV_Value
FROM customer_loyalty_history
WHERE enrollment_year = 2018
  AND enrollment_month BETWEEN 2 AND 4

UNION ALL

-- Percentage contribution of promo cohort to 2018 total

SELECT 
    Promo_Percentage AS Metric,
    ROUND((SUM
    (CASE 
     WHEN enrollment_month BETWEEN 2 AND 4 
     THEN CLV 
     ELSE 0 
     END) * 100.0) 
     / SUM(CLV), 2) AS Value
FROM customer_loyalty_history
WHERE enrollment_year = 2018;
