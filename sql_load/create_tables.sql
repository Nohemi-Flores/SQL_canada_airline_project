
CREATE TABLE IF NOT EXISTS calendar
(
Date DATE PRIMARY KEY,  
Start_of_Year   DATE,
Start_of_Quarter    DATE,
Start_of_Month DATE
);


CREATE TABLE IF NOT EXISTS customer_loyalty_history
(
Loyalty_Number INTEGER,
Country TEXT,
Province    TEXT,
City    TEXT,
Postal_Code TEXT,
Gender  TEXT,
Education   TEXT,
Salary  INTEGER NULL,
Marital_Status  TEXT,
Loyalty_Card    TEXT,
CLV NUMERIC (7,2),
Enrollment_Type TEXT,
Enrollment_Year INTEGER,
Enrollment_Month INTEGER,   
Cancellation_Year   INTEGER NULL,
Cancellation_Month INTEGER NULL,
PRIMARY KEY (Loyalty_Number)
);


CREATE TABLE IF NOT EXISTS customer_flight_activity
(
Loyalty_Number  INTEGER ,
Year    INTEGER,
Month   INTEGER,
Total_Flights INTEGER,  
Distance    INTEGER,
Points_Accumulated NUMERIC, 
Points_Redeemed INTEGER,
Dollar_Cost_Points_Redeemed INTEGER,
FOREIGN KEY (Loyalty_Number) REFERENCES customer_loyalty_history (Loyalty_Number)
);


CREATE TABLE IF NOT EXISTS data_dictionary
(
"table" TEXT NULL,
Field TEXT NOT NULL,
description TEXT NOT NULL
);

CREATE INDEX idx_loyalty_number ON customer_flight_activity (Loyalty_Number);