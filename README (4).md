# Healthcare Claims Denial Rate Analysis | SQL & Power BI

## Overview

This project demonstrates end-to-end healthcare claims analytics using SQL Server and Power BI. The objective is to understand why claims are denied, where denials concentrate, and how much revenue they put at risk, through SQL queries on a cleaned claims table and an interactive dashboard.

## Tools & Technologies

- SQL Server (T-SQL)
- Power BI
- DAX (denial rate and amount measures)
- Git & GitHub

## Project Objectives

- Measure the overall claim denial rate
- Identify the most frequent denial categories and reason codes
- Find the places of service, provider specialties and payer types with the most denials
- Track denied claims and denied amounts by year and quarter
- Evaluate the effect of prior authorization on denials
- Build a KPI dashboard with interactive filters

## Current Progress

### SQL

- ✅ Database and cleaned claims table (`Healthcare_denial_rate.claims_cleaned`)
- ✅ Denial volume and category analysis
- ✅ Reason code analysis
- ✅ Place of service, specialty and payer analysis
- ✅ Quarterly trend analysis
- ✅ Prior authorization analysis
- 🚧 Denial rate by segment (denied ÷ total claims)
- 🚧 Advanced SQL (CTEs, window functions)

### Power BI

- ✅ Dashboard developed (see below)
- 🚧 Business insights documentation

## SQL Analysis

Script: [`sql/claims_denial_analysis.sql`](sql/claims_denial_analysis.sql)

| # | Business question |
|---|---|
| 1 | What is the total number of denied claims? |
| 2 | Which denial category occurs most frequently? |
| 3 | Which denial reason code occurs most frequently? |
| 4 | Which place of service has the highest number of denied claims? |
| 5 | Which provider specialty has the most denied claims? |
| 6 | Which payer type has the most denied claims? |
| 7 | How many claims were denied in each year and quarter? |
| 8 | What is the total denied claim amount by year and quarter? |
| 9 | Among denied claims, how many had prior authorization obtained versus not obtained? |

### SQL Topics Covered

- SELECT, WHERE, ORDER BY
- GROUP BY
- Aggregate functions (COUNT, SUM)
- Filtering on outcome (`denied`)
- Time-based grouping (year and quarter)
- Business KPI queries

## Power BI Dashboard

File: [`powerbi/Healthcare_Claims_Denial_Dashboard.pbix`](powerbi/Healthcare_Claims_Denial_Dashboard.pbix)

**Healthcare Claims Denial Analysis Dashboard**

KPI cards:

- Total Claims
- Total Denied Claims
- Total Denied Amount
- Denial Rate %

Visuals:

- Denied amount by denial category
- Denied amount by denial reason code
- Claims by prior authorization status
- Claims by place of service
- Denied amount by payer type
- Claims by provider specialty
- Denied amount by year and quarter

Interactive filters: claim year, claim quarter, payer type, provider specialty and place of service.

## Repository Structure

```
healthcare-claims-denial-analysis/
│
├── README.md
├── sql/
│   └── claims_denial_analysis.sql
└── powerbi/
    └── Healthcare_Claims_Denial_Dashboard.pbix
```

## How to Use

1. Load the cleaned claims data into SQL Server as `claims_cleaned` in the `Healthcare_denial_rate` database.
2. Run the queries in `sql/` one at a time.
3. Open the `.pbix` file in Power BI Desktop and update the data source if needed.

## Upcoming Updates

- Denial rate by payer, specialty and place of service
- Advanced SQL (CTEs, window functions)
- Business insights and recommendations
- Dashboard screenshots

## About

Designed a SQL and Power BI analytics project on healthcare claims to identify the drivers of claim denials, quantify denied revenue, and measure the impact of prior authorization, using aggregations and time-based grouping with a filterable KPI dashboard.
