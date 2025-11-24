
COPY customer_flight_activity
FROM '/Users/nohemiflores/Documents/airline_program/csv_files/Customer Flight Activity.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY calendar
FROM '/Users/nohemiflores/Documents/airline_program/csv_files/Calendar.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY customer_loyalty_history
FROM '/Users/nohemiflores/Documents/airline_program/csv_files/Customer Loyalty History.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8', NULL '');

COPY data_dictionary
FROM '/Users/nohemiflores/Documents/airline_program/csv_files/Airline Loyalty Data Dictionary.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8', NULL '');
