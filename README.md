# RCM Claims Analytics & AR / Denial Performance Dashboard

An end-to-end analysis of healthcare revenue cycle management (RCM) claims data, built to monitor accounts receivable (AR), payment lags and claim denials, and to find denials that could have been prevented.

**Tools:** SQL, Power BI, Excel (Pivot Tables, slicers)

---

## Project Overview

In US healthcare, providers bill insurers (payers) for the care they deliver. Claims that are denied or paid late delay cash collection and cause revenue leakage. This project analyzes a claims dataset to answer three questions:

1. How much of the billed amount is being denied, and how much is still outstanding?
2. Where are payments getting delayed (payment lag and AR aging)?
3. Which denials were preventable, and what is the recovery opportunity?

## Dataset

| Item | Detail |
|---|---|
| Claims records | 5,001 |
| Attributes | 42 |
| Total charges | $1.65M |

> The data used is anonymized / sample data. No patient identifiers or protected health information (PHI) are included.

## Approach

1. **Data preparation:** cleansed and validated the claims data (missing values, duplicates, inconsistent formats) using SQL and Excel.
2. **Analysis:** wrote SQL queries to calculate denial rate, payment lag, AR aging buckets and charges vs payments.
3. **Dashboard:** built an interactive dashboard with slicers so users can filter by payer, status and time period.
4. **Recovery analysis:** separated denials into preventable and non-preventable to size the immediate recovery opportunity.

## Key Metrics Tracked

- Denial rate
- Denied amount
- Preventable denial amount
- Payment lag (days from billing to payment)
- AR aging (0-30, 31-60, 61-90, 90+ days)
- Total charges vs collections

## Key Findings

| Metric | Result |
|---|---|
| Denial rate | **17.78%** |
| Denied amount | **$544.4K** |
| Preventable denials | **$73.7K**, identified as an immediate recovery opportunity |

These findings show where a revenue cycle team should focus first: fixing the root causes of preventable denials and following up on aged receivables.

## Dashboard

*(Add screenshots here, for example `images/dashboard_overview.png` and `images/ar_aging.png`.)*

## Repository Structure

```
├── README.md
├── data/                  # anonymized sample data
├── sql/                   # SQL queries used for the analysis
├── dashboard/             # Power BI (.pbix) / Excel file
└── images/                # dashboard screenshots
```

## How to Use

1. Clone this repository.
2. Open the SQL scripts in the `sql/` folder and run them on your SQL database to reproduce the metrics.
3. Open the dashboard file in Power BI Desktop or Excel and use the slicers to explore the data.

## Skills Demonstrated

SQL (joins, aggregations, CTEs, window functions) · Power BI · Excel Pivot Tables and slicers · Data cleansing and validation · Healthcare RCM domain knowledge (AR, denials, payer analysis) · Dashboard design

## Author

**Karthigaipriya**
Data Analyst | SQL | Power BI | Excel
priyaselvi788@gmail.com
