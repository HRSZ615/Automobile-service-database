# Automobile Repair & Service History Database

## Overview
This project presents a fully functioning centralized automobile repair and service history database, built in Microsoft Access as part of BUS 385 — Business Data Management at Farmingdale State College. The database addresses a core operational problem in the auto repair industry: scattered service records, disconnected customer data, and the absence of business analytics — all managed through a structured relational database and a library of 12 SQL queries.

## Role
**Testing and Documentation Lead** — responsible for validating query accuracy, documenting the full SQL query library, and producing the final project report.

## Dataset
- **Source:** [Motor Vehicle Repair & Towing Dataset — Kaggle](https://www.kaggle.com/datasets/aryan208/motor-vehicle-repair-and-towing-dataset)
- **Coverage:** Vehicle repair and service records from 2020 to 2024
- **Size:** ~15,000 records (trimmed from 1M+ for Microsoft Access compatibility)
- **Tool:** Microsoft Access

## Database Structure
The database contains six normalized tables linked through primary and foreign keys:

| Table | Description |
|---|---|
| CUSTOMERS | Customer ID, name, and contact information |
| VEHICLES | Vehicle ID, type, make/model, linked to customer |
| SERVICES | Core service records — repair type, cost, mechanic, date |
| PARTS | Parts used per service with pricing |
| TOWING | Towing events linked to service records |
| MECHANICS | Mechanic ID and name, linked to services |

**Key relationships:** CUSTOMERS → VEHICLES → SERVICES → PARTS / TOWING / MECHANICS (all one-to-many)

## SQL Query Library
12 queries were developed and executed in Microsoft Access SQL view across four categories:

### Data Retrieval & Advanced Queries
1. Service Totals by Brand — crosstab of service types per vehicle brand
2. Average & Total Cost of Parts — parts usage and cost summary
3. Average & Total Profit by Service Type — profitability ranking by service
4. Average Mechanic Ratings — technician performance evaluation
5. Customer Visit & Spending Totals — top customer identification

### Filtering Queries
6. Follow-Ups Needed — all service records flagged for follow-up
7. Insurance Claims — all records paid through insurance

### Analytical Queries
8. Monthly Profit, Revenue & Expenses by Year — parameterized seasonal report
9. Towing Mileage Information — distance and cost-per-mile analysis

### Lookup Queries
10. Vehicles Serviced More Than Once — repeat repair identification
11. Customer Records Search — parameterized full customer history lookup
12. Parts Used For Each Service — parameterized parts and cost breakdown per job

## Key Findings
- Transmission Repair and Towing generated nearly 75% of total profit despite representing less than 30% of total jobs — the business should prioritize staffing and equipment for these services
- Oil Changes were the most frequently performed service but contributed only $33,502 in profit, the lowest of all service types
- 7,485 of 14,998 service records required a follow-up — impossible to manage without a centralized system
- Service volume was consistent at ~3,000 per year from 2020–2024, with a slight dip in 2021–2022 attributable to pandemic-era supply shortages
- Average towing distance was 53.1 miles at $3.67 per mile, with pickups spread evenly across six location types

## Files
- `queries.sql` — Full SQL query library (Microsoft Access syntax)
- `Automobile_Repair_Service_History_Final_Report.pdf` — Complete 30-page project report












