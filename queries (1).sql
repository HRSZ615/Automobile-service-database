-- Automobile Repair & Service History Database
-- Microsoft Access SQL Query Library
-- Note: All queries written in Microsoft Access SQL syntax

-- ============================================================
-- SECTION 1: DATA RETRIEVAL & ADVANCED QUERIES
-- ============================================================

-- Query 1: Service Totals by Brand
-- Analyzes service demand by vehicle brand, breaking down how many times
-- each service type was performed per brand. Supports targeted maintenance
-- planning, inventory preparation, and service strategy optimization.

TRANSFORM COUNT(Service_Type) AS [Count]
SELECT LEFT(Make_and_Model, INSTR(Make_and_Model," ")-1) AS Brand,
       COUNT(VEHICLES.Vehicle_ID) AS [Number of Vehicles]
FROM VEHICLES INNER JOIN SERVICES ON VEHICLES.Vehicle_ID = SERVICES.Vehicle_ID
GROUP BY LEFT(Make_and_Model, INSTR(Make_and_Model," ")-1)
PIVOT Service_Type;


-- Query 2: Average & Total Cost of Parts
-- Tracks parts usage and costs by summarizing frequency, average cost, and
-- total cost per part type. Helps manage inventory and control purchasing decisions.

SELECT Parts_Used AS Parts,
       COUNT(Parts_Used) AS [Total Used],
       AVG(Price) AS [Average Cost],
       SUM(Price) AS [Total Cost]
FROM PARTS
GROUP BY Parts_Used
ORDER BY SUM(Price) DESC;


-- Query 3: Average & Total Profit by Service Type
-- Analyzes profitability of each service type. Helps determine which services
-- are most profitable, guiding pricing strategy and resource allocation.

SELECT Service_Type AS [Service Type],
       COUNT(*) AS [Total Performed],
       AVG(Service_Price - Service_Cost) AS [Average Profit],
       (SUM(Service_Price) - SUM(Service_Cost)) AS [Total Profit]
FROM SERVICES
GROUP BY Service_Type
ORDER BY AVG(Service_Price - Service_Cost) DESC;


-- Query 4: Average Mechanic Ratings
-- Evaluates mechanic performance by average customer rating. Supports
-- decisions on training, promotions, and service quality management.

SELECT MECHANICS.Mechanic_ID AS ID,
       Mechanic_Name AS [Mechanic Name],
       ROUND(AVG(Technician_Rating),1) AS [Average Rating / 5]
FROM MECHANICS INNER JOIN SERVICES ON MECHANICS.Mechanic_ID = SERVICES.Mechanic_ID
GROUP BY MECHANICS.Mechanic_ID, Mechanic_Name
ORDER BY ROUND(AVG(Technician_Rating),1) DESC;


-- Query 5: Customer Visit & Spending Totals
-- Identifies most valuable and frequent customers by visit count and total spend.
-- Enables targeted marketing, loyalty programs, and customer relationship management.

SELECT Customer_Name AS Name,
       COUNT(Service_ID) AS [Total Visits],
       SUM(Service_Price) AS [Total Spent],
       Phone_Number AS [Phone Number]
FROM CUSTOMERS INNER JOIN (VEHICLES INNER JOIN SERVICES
     ON VEHICLES.Vehicle_ID = SERVICES.Vehicle_ID)
     ON CUSTOMERS.Customer_ID = VEHICLES.Customer_ID
GROUP BY Customer_Name, Phone_Number
ORDER BY COUNT(Service_ID) DESC, SUM(Service_Price) DESC;


-- ============================================================
-- SECTION 2: FILTERING QUERIES
-- ============================================================

-- Query 6: Follow-Ups Needed
-- Retrieves all service records requiring a follow-up visit.
-- Ensures timely follow-ups and prevents unresolved issues from being overlooked.

SELECT *
FROM SERVICES
WHERE FollowUP_Needed = 'Yes';


-- Query 7: Insurance Claims
-- Retrieves all service records paid through insurance.
-- Helps track insurance transactions and streamline claims processing.

SELECT *
FROM SERVICES
WHERE Payment_Method = 'Insurance';


-- ============================================================
-- SECTION 3: ANALYTICAL QUERIES
-- ============================================================

-- Query 8: Monthly Profit, Revenue & Expenses by Year
-- Summarizes business performance by month for a user-selected year.
-- Supports seasonal trend analysis, budgeting, and operational planning.
-- Note: User is prompted to enter a year when the query runs.

SELECT FORMAT(Repair_Date, "mmmm") AS [Month],
       COUNT(Service_ID) AS [Total Services Performed],
       SUM(Service_Cost) AS [Total Expenses],
       SUM(Service_Price) AS [Total Revenue],
       (SUM(Service_Price) - SUM(Service_Cost)) AS [Total Profit]
FROM SERVICES
WHERE YEAR(Repair_Date) LIKE [Enter Year]
GROUP BY FORMAT(Repair_Date, "mmmm"), MONTH(Repair_Date)
ORDER BY MONTH(Repair_Date);


-- Query 9: Towing Mileage Information
-- Analyzes towing operations: average, minimum, and maximum distances
-- plus average cost per mile. Supports pricing, routing, and resource allocation.

SELECT ROUND(AVG(Tow_Distance_Miles),1) AS [Average Towing Distance],
       MIN(Tow_Distance_Miles) AS [Lowest Towing Distance],
       MAX(Tow_Distance_Miles) AS [Highest Towing Distance],
       ROUND((SUM(Service_Cost) / SUM(Tow_Distance_Miles)),2) AS [Average Cost/Mile]
FROM TOWING INNER JOIN SERVICES ON TOWING.Service_ID = SERVICES.Service_ID;


-- ============================================================
-- SECTION 4: LOOKUP QUERIES
-- ============================================================

-- Query 10: Vehicles Serviced More Than Once
-- Identifies vehicles with repeat service records, flagging potential
-- ongoing mechanical issues for diagnostics and follow-up.

SELECT Make_and_Model AS Vehicle,
       VEHICLES.Vehicle_ID AS [Vehicle ID],
       Customer_Name AS Owner,
       Phone_Number AS [Phone Number],
       COUNT(Service_ID) AS [Total Services]
FROM CUSTOMERS INNER JOIN (VEHICLES INNER JOIN SERVICES
     ON VEHICLES.Vehicle_ID = SERVICES.Vehicle_ID)
     ON CUSTOMERS.Customer_ID = VEHICLES.Customer_ID
GROUP BY Customer_Name, Phone_Number, Make_and_Model, VEHICLES.Vehicle_ID
HAVING COUNT(Service_ID) > 1
ORDER BY COUNT(Service_ID) DESC, Customer_Name;


-- Query 11: Customer Records Search
-- Parameterized lookup returning full service history for a named customer,
-- including vehicles, services, repair dates, costs, and total spent.
-- Note: User is prompted to enter a customer name when the query runs.

SELECT Customer_Name AS Name,
       V.Vehicle_ID AS [Vehicle ID],
       Make_and_Model AS Vehicle,
       Service_Type AS Service,
       Repair_Date AS [Repair Date],
       Service_Price AS Price
FROM CUSTOMERS AS C INNER JOIN (VEHICLES AS V INNER JOIN SERVICES AS S
     ON V.Vehicle_ID = S.Vehicle_ID)
     ON C.Customer_ID = V.Customer_ID
WHERE Customer_Name LIKE "*" & [Enter Customer Name] & "*"
ORDER BY Repair_Date DESC
UNION ALL
SELECT "","","","","Total Spent", SUM(sub.Price)
FROM (
    SELECT Customer_Name, V.Vehicle_ID, Make_and_Model, Service_Type, Repair_Date,
           Service_Price AS Price
    FROM CUSTOMERS AS C INNER JOIN (VEHICLES AS V INNER JOIN SERVICES AS S
         ON V.Vehicle_ID = S.Vehicle_ID)
         ON C.Customer_ID = V.Customer_ID
    WHERE Customer_Name LIKE "*" & [Enter Customer Name] & "*"
) AS sub;


-- Query 12: Parts Used For Each Service
-- Parameterized lookup returning all parts and total parts cost for a given Service ID.
-- Supports accurate billing and transparency in service records.
-- Note: User is prompted to enter a Service ID when the query runs.

SELECT S.Service_ID AS [Service ID],
       Service_Type AS Service,
       Repair_Date AS [Repair Date],
       Parts_Used AS [Parts Used],
       P.Price
FROM SERVICES AS S INNER JOIN PARTS AS P ON S.Service_ID = P.Service_ID
WHERE S.Service_ID LIKE [Enter Service ID]
UNION ALL
SELECT ' ', ' ', ' ', 'Total Cost', SUM(sub.Price)
FROM (
    SELECT S.Service_ID, Service_Type, Repair_Date, Parts_Used, P.Price
    FROM SERVICES AS S INNER JOIN PARTS AS P ON S.Service_ID = P.Service_ID
    WHERE S.Service_ID LIKE [Enter Service ID]
) AS sub;


-- ============================================================
-- SECTION 5: DATA MANIPULATION
-- ============================================================

-- Adding a new customer
INSERT INTO CUSTOMERS (Customer_ID, Customer_Name, Phone_Number)
VALUES (11498, 'Joshua Hayes', '(516)878-8141');

-- Adding a new vehicle for an existing customer
INSERT INTO VEHICLES (Vehicle_ID, Vehicle_Type, Make_and_Model, Customer_ID)
VALUES (210466, 'Van', 'Ford Sienna', 1);

-- Updating a customer phone number
UPDATE CUSTOMERS
SET Phone_Number = '(516)421-2413'
WHERE Customer_ID = 5;

-- Deleting a duplicate parts record
DELETE FROM PARTS
WHERE Part_ID = 'B9999';
