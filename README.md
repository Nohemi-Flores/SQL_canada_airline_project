# Introduction

I was hired as the Lead Marketing Analyst for Northern Air Lights (NLA), a fictitious Canadian airline. The airline ran a promotion between Feb - Apr 2018 in an effort to improve program enrollment. The benefit of enrolling is that new customers that joined during the promotion received 1.5x  loyalty card points for flights booked after the promo (5/2018 - 12?2018). 

I analyzed loyalty program signups, enrollment and cancellation details, and additional customer information.

**Note: Data ranges from 2012-2018**

**SQL Queries?** **Inside Sql_load/Analysis**

# Background
The datafor this project comes from [Maven Analytics](https://mavenanalytics.io/data-playground/airline-loyalty-program). 

### Questions Answered in Analysis

1. Who are our customers?
2. What are our cohorts?
3. How did the campaign do?


# Tools I Used 
I used various key tools for the analysis:

- **SQL**: Queries

- **PostgreSQL**: Database 

- **Visual Studio Code**: Execute queries & database management

- **Git & GitHub**: Version control & share projects

# Analysis
Different topics related to the 2018 promotion, and overall customer base, were investigated.

### 1. Customers
Filtered data to find out more about NLA's customers. 
``` sql
-- How many customers does Northern Lights Air have (as of 2018)?

SELECT 
    COUNT(loyalty_number) as total_customers
FROM
    customer_loyalty_history;

-- Who are our customers?
        
        -- Totals by Gender

SELECT 
    'Gender' AS Attribute,
    Gender AS Category,
    COUNT(*) AS customers_count
FROM customer_loyalty_history
GROUP BY Gender

UNION ALL

        -- Totals by Education

SELECT 
    'Education' AS Attribute,
    Education AS Category,
    COUNT(*) AS customers_count
FROM customer_loyalty_history
GROUP BY Education

UNION ALL

        -- Totals by Marital Status

SELECT 
    'Marital_Status' AS Attribute,
    Marital_Status AS Category,
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
```
**Insights**: 

    Our customers:

![customers_by](/images/1_.png) 

- NLA has a total of 16,37 customers as of 2018.

![enroll_year](/images/1_2.png)

- The data shows that 2018 is when most of our customers enrolled. 2012 is the opposite.


Now. let's look at the members that enrolled in 2018, particularly the "promotion customers".

- The data shows that 971 customers enrolled during the promotion period (Feb - Apr 2018).

    - **Loyalty Card**: Start (433), Nova (330), and Aurora (2018).
    
    - **Flights booked post-promotion**: 42,721

    - **Card Points Earned**: 96,101,463 points

Now, let's look at cohorts. Such are defined by the year they enrolled.

### 2. Cohorts
Looked at cohorts to learn more about customers.

``` sql
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
    'Total_2018_CLV' AS Cohort,
    SUM(CLV) AS CLV_Value
FROM customer_loyalty_history
WHERE enrollment_year = 2018

UNION ALL

-- CLV for Feb–Apr 2018 promo cohort

SELECT 
    'Promo_CLV' AS Cohort,
    SUM(CLV) AS CLV_Value
FROM customer_loyalty_history
WHERE enrollment_year = 2018
  AND enrollment_month BETWEEN 2 AND 4

UNION ALL

-- Percentage contribution of promo cohort to 2018 total

SELECT 
    'Promo_Percentage' AS Metric,
    ROUND((SUM
    (CASE 
     WHEN enrollment_month BETWEEN 2 AND 4 
     THEN CLV 
     ELSE 0 
     END) * 100.0) 
     / SUM(CLV), 2) AS Value
FROM customer_loyalty_history
WHERE enrollment_year = 2018;
```

**Insights**: 
    
    Customer Lifetime Value (CLV) by cohort:

![clv](/images/2_1.png)

    - 2018 produced the most CLV for the company.

- How much of that belongs to the customers that joined during the promotion?

    ![promo_clv](/images/2_4.png)

    The data shows the promotion customers hold a 32% of the CLV for 2018. This signifies that customers that joined during the promotion are high-value customers.


Now, let's look into the campaign itself.


### 3. Campaign
How did the campaign impact the company?

``` sql
-- What impact did the campaign have on loyalty program memberships (gross / net)?

    -- Cohort comparison: Pre-Promo, Promo, Post-Promo

WITH cohort_numbers AS (
    SELECT 'PrePromo' AS Cohort,
           COUNT(*) AS Gross,
           COUNT(*) FILTER (WHERE cancellation_year <= 2018) AS Cancellations
    FROM customer_loyalty_history
    WHERE (enrollment_year BETWEEN 2012 AND 2017)
       OR (enrollment_year = 2018 AND enrollment_month = 1)

    UNION ALL

    SELECT 'Promo' AS Cohort,
           COUNT(*) AS Gross,
           COUNT(*) FILTER (WHERE cancellation_year <= 2018) AS Cancellations
    FROM customer_loyalty_history
    WHERE enrollment_year = 2018 AND enrollment_month BETWEEN 2 AND 4

    UNION ALL

    SELECT 'PostPromo' AS Cohort,
           COUNT(*) AS Gross,
           COUNT(*) FILTER (WHERE cancellation_year <= 2018) AS Cancellations
    FROM customer_loyalty_history
    WHERE enrollment_year = 2018 AND enrollment_month BETWEEN 5 AND 12
)
SELECT Cohort,
       Gross,
       Cancellations,
       (Gross - Cancellations) AS Net_Impact,
       ROUND((Gross - Cancellations) * 100.0 / Gross, 2) AS Retention_Percentage
FROM cohort_numbers;

```

The numbers:

![cohort_numbers](/images/3_2.png)

This shows us that the post-promo cohort has the highest retention percentage. One factor that may contribute to this is that the campaign not only attracted high_value customers, but customers kept signing up even after the promo. Its all about the campaign building awareness for NLA.

Let's now break down the impact on loyalty members.

**NOTE**: Here, campaign adoption is understood to be how many joined in order to get the 1.5X loyalty card points from booking flights from May 2018 - Dec 2018.

``` SQL
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

```


**Insights**: 
- The data shows that more females (3,968) joined during the promotion. Males totaled 3,840 new memberships. Females booked more flights for the period after the promotion (21,524). Males booked 21,197 flights.
- Education fell under the High School or Below, College, Bachelor, Master, and Doctor categories. The data shows that customers under the Bachelor category booked more flights for May 2018-Dec 2018. The category that booked the least amount of flights was Master.
- Marriage status was also investigated. The categories are Single, Married, and Divorced. The married folks booked more flights for the post-promo period (24,529). Single people booked 11,701 flights, and divorced individuals had 6,491 flights.
- Salary was looked at as well. But the question focuses on the 2018 promotion customers.

  ![salary](/images/3_3.png) 

    - Customers within the salary range of 50k-99k booked the most flights. Thus, being the customers that took the most advantage of the promotion!

# Conclusions
### Insights
- **1. Customers**: Data shows that most of our customers joined in 2018.

- **2. Cohortss**: The 2018 cohort produced the most CLV for NLA. But one great insight is that the 2018 promotion customers produced 32% of the CLV for 2018. This means this group is made up by high-value customers. It's something to keep in mind!

- **3. Campaign**: The 50k-99k salary group within the 2018 promotion folks booked the most flights after the promo. NLA could offer more promotions targeting this group!

### Closing Thoughts
It is important to know how to ask for the data (through SQL). But it is more important to understand what the data is revealing! 🙂
