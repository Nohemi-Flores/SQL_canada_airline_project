-- What impact did the campaign have on loyalty program memberships (gross / net)?

-- Cohort comparison: Pre-Promo, Promo, Post-Promo

WITH cohort_numbers AS
(
SELECT 
    'Jan2012-Jan2018' AS Cohort,
    'Gross' AS Metric,
    COUNT(*) AS Total
FROM customer_loyalty_history
WHERE (enrollment_year BETWEEN 2012 AND 2017)
   OR (enrollment_year = 2018 AND enrollment_month = 1)

UNION ALL

SELECT 
    'Jan2012-Jan2018' AS Cohort,
    'Cancellations' AS Metric,
    COUNT(*) AS Total
FROM customer_loyalty_history
WHERE ((enrollment_year BETWEEN 2012 AND 2017)
   OR (enrollment_year = 2018 AND enrollment_month = 1))
  AND cancellation_year <= 2018

UNION ALL

SELECT 
    'Jan2012-Jan2018' AS Cohort,
    'Net_Impact' AS Metric,
    ( (SELECT COUNT(*) 
       FROM customer_loyalty_history
       WHERE (enrollment_year BETWEEN 2012 AND 2017)
          OR (enrollment_year = 2018 AND enrollment_month = 1))
    - (SELECT COUNT(*) 
       FROM customer_loyalty_history
       WHERE (enrollment_year BETWEEN 2012 AND 2017)
          OR (enrollment_year = 2018 AND enrollment_month = 1)
          AND cancellation_year <= 2018) ) AS Value

UNION ALL

SELECT 
    '2018_Promotion' AS Cohort,
    'Gross' AS Metric,
    COUNT(*) AS Total
FROM customer_loyalty_history
WHERE enrollment_year = 2018
  AND enrollment_month BETWEEN 2 AND 4

UNION ALL

SELECT 
    '2018_Promotion' AS Cohort,
    'Cancellations' AS Metric,
    COUNT(*) AS Total
FROM customer_loyalty_history
WHERE enrollment_year = 2018
  AND enrollment_month BETWEEN 2 AND 4
  AND cancellation_year <= 2018

UNION ALL

SELECT 
    '2018_Promotion' AS Cohort,
    'Net_Impact' AS Metric,
    ( (SELECT COUNT(*) 
       FROM customer_loyalty_history
       WHERE enrollment_year = 2018
         AND enrollment_month BETWEEN 2 AND 4)
    - (SELECT COUNT(*) 
       FROM customer_loyalty_history
       WHERE enrollment_year = 2018
         AND enrollment_month BETWEEN 2 AND 4
         AND cancellation_year <= 2018) ) AS Value

UNION ALL

SELECT 
    '2018_PostPromo' AS Cohort,
    'Gross' AS Metric,
    COUNT(*) AS Total
FROM customer_loyalty_history
WHERE enrollment_year = 2018
  AND enrollment_month BETWEEN 5 AND 12

UNION ALL

SELECT 
    '2018_PostPromo' AS Cohort,
    'Cancellations' AS Metric,
    COUNT(*) AS Total
FROM customer_loyalty_history
WHERE enrollment_year = 2018
  AND enrollment_month BETWEEN 5 AND 12
  AND cancellation_year <= 2018

UNION ALL

SELECT 
    '2018_PostPromo' AS Cohort,
    'Net_Impact' AS Metric,
    ( (SELECT COUNT(*) 
       FROM customer_loyalty_history
       WHERE enrollment_year = 2018
         AND enrollment_month BETWEEN 5 AND 12)
    - (SELECT COUNT(*) 
       FROM customer_loyalty_history
       WHERE enrollment_year = 2018
         AND enrollment_month BETWEEN 5 AND 12
         AND cancellation_year <= 2018) ) AS Value
)

SELECT cohort, Metric, Total
FROM cohort_numbers
GROUP BY cohort, Metric, Total;

-- Was the campaign adoption more successful for certain demographics of loyalty members? 

    -- Did men or women join at higher rates, and did gender affect flight bookings later in 2018?

SELECT 
    cl.gender,
    COUNT(cl.loyalty_number) AS joined_during_promo,
    SUM(cf.total_flights) AS booked_after
FROM customer_loyalty_history cl
LEFT JOIN customer_flight_activity cf
    ON cl.loyalty_number = cf.loyalty_number
   AND cf.month BETWEEN 5 AND 12
WHERE cl.enrollment_year = 2018
  AND cl.enrollment_month BETWEEN 2 AND 4
GROUP BY cl.gender;

    -- Which education level group showed the highest participation in booking flights to earn 1.5x points?

SELECT
    cl.education,
    SUM(cf.total_flights) as booked_after_promo
FROM
    customer_loyalty_history cl
JOIN 
    customer_flight_activity cf 
    ON cl.loyalty_number = cf.loyalty_number
WHERE
    enrollment_year = 2018 
    AND enrollment_month BETWEEN 2 AND 4
    AND cf.month BETWEEN 5 AND 12
GROUP BY
    education
ORDER BY
    booked_after_promo DESC;

    -- Did marital status affect benefit utilization (book flights)?

SELECT
    cl.Marital_Status,
    SUM(cf.total_flights) AS booked_after_promo
FROM
    customer_loyalty_history cl
LEFT JOIN customer_flight_activity cf
    ON cl.loyalty_number = cf.loyalty_number
    AND cf.month BETWEEN 5 AND 12
WHERE cl.enrollment_year = 2018
  AND cl.enrollment_month BETWEEN 2 AND 4
GROUP BY
    Marital_Status
ORDER BY
    booked_after_promo DESC;
    
    -- Did salary level influence whether new members actually used the benefit (book flights)?

SELECT 
    CASE 
        WHEN cl.salary IS NULL OR cl.salary < 0 THEN 'Unknown'
        WHEN cl.salary < 50000 THEN '<50k'
        WHEN cl.salary BETWEEN 50000 AND 99999 THEN '50k-99k'
        WHEN cl.salary BETWEEN 100000 AND 149999 THEN '100k-149k'
        ELSE '150k+' 
    END AS salary_bucket,
SUM(cf.total_flights) AS booked_after_promo
FROM customer_loyalty_history cl
LEFT JOIN customer_flight_activity cf
    ON cl.loyalty_number = cf.loyalty_number
   AND cf.month BETWEEN 5 AND 12
WHERE cl.enrollment_year = 2018
  AND cl.enrollment_month BETWEEN 2 AND 4
GROUP BY salary_bucket
ORDER BY booked_after_promo DESC;

