# Technical Specification – Returning & Retained by Expert

## Purpose
To provide a production-ready analytics dataset and dashboard for evaluating
expert performance through returning, retention, and financial value metrics.

---

## Business Users
- QA Managemers
- CS Managemers
---

## Data Sources
- Users table (experts scope and status)
- Orders table (expert–customer relationships)
- Transactions table (order closure confirmation)

---

## Output Dataset
A materialized analytical table containing:
- expert-level metrics,
- period-based aggregation,
- behavioral and financial indicators.

The dataset is designed for direct BI consumption.

---

## Refresh Logic
- Monthly refresh for month-based metrics
- Quarterly refresh for quarter-based metrics

The dataset is rebuilt using deterministic SQL logic to ensure reproducibility.

---

## BI Consumption
The dataset serves as the single data source for the Looker Studio dashboard.
No business logic is applied at the BI layer.
