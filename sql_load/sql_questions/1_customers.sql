-- How many customers does Northern Light Air have (as of 2018)?

SELECT 
    COUNT(loyalty_number) as total_customers
FROM
    customer_loyalty_history;

-- Who are our customers?

-- Totals by Gender

SELECT 
    'Gender' AS Attribute,
    'Gender' AS Category,
    COUNT(*) AS customers_count
FROM customer_loyalty_history
GROUP BY Gender

UNION ALL

-- Totals by Education

SELECT 
    'Education' AS Attribute,
    'Education' AS Category,
    COUNT(*) AS customers_count
FROM customer_loyalty_history
GROUP BY Education

UNION ALL

-- Totals by Marital Status

SELECT 
    'Marital_Status' AS Attribute,
    'Marital_Status' AS Category,
    COUNT(*) AS customers_count
FROM customer_loyalty_history
GROUP BY Marital_Status
ORDER BY Attribute, Category;

-- When did they enroll?

SELECT Enrollment_Year AS Cohort_Year,
        COUNT(loyalty_number) AS total_enrolled
FROM customer_loyalty_history
GROUP BY enrollment_year
ORDER BY
    total_enrolled DESC;

    -- Enrollment Type

SELECT
    Enrollment_Type,
    COUNT(*)
FROM
    customer_loyalty_history
GROUP BY
    enrollment_type

-- What is the Loyalty Card of "2018 promotion" customers?

SELECT
    Loyalty_Card,
    COUNT(Loyalty_Card)
FROM
    customer_loyalty_history 
WHERE
    enrollment_year= 2018 AND enrollment_month BETWEEN 2 AND 4
GROUP BY
    loyalty_card;

-- How many flights were booked after the promotion by customers that joined during promotion?

SELECT 
    SUM(total_flights) AS Flights_Booked_After_Promo
FROM customer_flight_activity cf
JOIN customer_loyalty_history cl
    ON cf.loyalty_number = cl.loyalty_number
WHERE cl.enrollment_year = 2018
  AND cl.enrollment_month BETWEEN 2 AND 4  
  AND cf.Month BETWEEN 5 AND 12;     

-- How many card points did they earn?

SELECT
    SUM(cf.Points_Accumulated) AS total_points_accumulated
FROM
    customer_flight_activity cf
JOIN customer_loyalty_history cl
ON cf.loyalty_number = cl. loyalty_number
WHERE cl.enrollment_year = 2018
  AND cl.enrollment_month BETWEEN 2 AND 4  
  AND cf.Month BETWEEN 5 AND 12;     

