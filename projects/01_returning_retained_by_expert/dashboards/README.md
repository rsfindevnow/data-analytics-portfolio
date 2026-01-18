# Returning & Retained by Expert – BI Dashboard

## Dashboard Purpose
This dashboard provides a business-ready view of customer returning and retention performance at the expert level, enriched with financial and behavioral signals.

Its primary purpose is to support expert evaluation, motivation, and performance comparison by combining:
- customer lifecycle metrics (returning and retention),
- financial outcomes,
- and order frequency patterns that help explain differences in customer value across experts.

The dashboard is designed as a decision-support tool for continuous operational and management use.

---

## Target Users
The dashboard is intended for:
- Management teams responsible for expert performance, incentives, and quality standards,
- Customer Success and Operations teams monitoring expert effectiveness,
- Product and Analytics stakeholders analyzing retention and value dynamics.

It is built to be used independently, without additional analytical interpretation.

---

## Key Metrics & Dimensions
The dashboard focuses on a strictly defined and limited set of metrics:

**Behavioral metrics**
- New First Closed Customers
- Returning Customers (STRICT logic)
- Retained Customers (lifetime-based)
- Order Frequency (average number of closed orders per customer)

**Financial metrics**
- Retained Revenue
- Retained ARPU
- Share of retained value in total revenue

**Core dimensions**
- Expert
- Period (Month / Quarter)
- Period Type

Order frequency is used as an explanatory metric to better understand why customers associated with different experts may generate different average check sizes and long-term value.

Returning and Retained metrics are treated as distinct behavioral signals and are not used interchangeably.

---

## Analytical Views & Pages
The dashboard consists of two primary analytical views:

1. **Dynamics View**
   - Time-based trends of returning and retained customers
   - Retained revenue and ARPU dynamics
   - Order frequency trends as a behavioral driver of customer value
   - Identification of changes in expert performance over time

2. **Experts Ranking (Top-10)**
   - Comparative ranking of experts by retention and retained value
   - Side-by-side comparison of order frequency and financial outcomes
   - Identification of experts who achieve higher customer value through frequency rather than price

Interactive filters allow switching between experts and aggregation periods.

---

## Typical Business Questions Answered
The dashboard enables the business to answer questions such as:
- Which experts generate the highest long-term customer value?
- Are differences in retained revenue driven by price, frequency, or retention?
- Do some experts compensate lower average check with higher order frequency?
- How stable is expert retention and frequency behavior over time?
- Which experts demonstrate sustainable customer engagement patterns?

---

## How the Dashboard Is Used in Practice
In day-to-day operations, the dashboard is used to:
- evaluate expert performance beyond raw revenue or order count,
- distinguish between value driven by pricing versus repeat engagement,
- support data-driven expert motivation and incentive programs,
- encourage healthy internal competition based on transparent and comparable metrics.

By incorporating order frequency, the dashboard helps the business avoid simplistic conclusions based solely on average check and instead focus on sustainable customer behavior.

---

## Design & UX Decisions
Key design decisions include:
- explicit separation of behavioral, financial, and frequency metrics,
- minimal metric set to reduce cognitive overload,
- consistent definitions across all views and periods,
- emphasis on comparability and explainability rather than visual complexity.

The dashboard prioritizes clarity, interpretability, and decision usability.

---

## Limitations & Next Improvements
**Current limitations**
- Retention is based on historical closed orders only.
- Frequency analysis does not yet distinguish between order types or complexity.
- No cohort aging or churn timing analysis included.

**Potential next steps**
- Introduce cohort-based retention and frequency curves.
- Add time-to-second-order and repeat cadence analysis.
- Extend expert comparison with pricing, discounts, and order mix impact.

---

## Data Source & Refresh Logic
The dashboard is powered by a materialized analytical table built in BigQuery.

Data is refreshed on a regular schedule to ensure stability and consistency of metrics across reporting periods.

Detailed SQL logic, data modeling decisions, and metric definitions are documented separately in the repository.
