# Returning & Retained Clients by Expert

## Overview
This project delivers a production-ready analytics solution to evaluate expert performance through customer returning and retention metrics, combined with financial impact analysis.

The solution covers the full analytics lifecycle:
SQL data modeling in BigQuery → materialized reporting table → BI dashboard in Looker Studio → business-ready insights for management and operations.

---

## Business Context
In an expert-based marketplace, long-term value is driven not by one-off orders, but by customer retention and repeat behavior.

Management and Customer Success teams require a transparent, comparable, and financially grounded view of:
- how effectively experts retain customers,
- how often customers return after their first order,
- how valuable retained customers are in monetary terms.

Before this solution, these questions could not be answered consistently due to missing unified definitions and fragmented analytics.

---

## Problem Statement
Key challenges addressed:
- Lack of a single, trusted definition of **Returning** and **Retained** customers.
- No consistent attribution of customers to experts across their lifecycle.
- Inability to compare experts fairly across time (month / quarter).
- Missing linkage between retention metrics and financial value.

---

## Goals & Success Criteria
**Analytics goals**
- Define strict, non-ambiguous customer lifecycle metrics.
- Build a reusable, explainable data model at expert level.
- Support dynamic time aggregation (month / quarter).

**Business goals**
- Enable expert comparison for CS and Management.
- Provide a foundation for incentive, pricing, and quality programs.
- Shift decisions from intuition to data-driven evaluation.

---

## Definitions & Methodology
This project applies strict lifecycle logic:

- **Closed order**: order with a successful Wage transaction (used as the single source of truth).
- **New First Closed Customer**: customer whose first-ever closed order on the platform occurred in the selected period and is attributed to the first expert.
- **Returning Customer (STRICT)**: customer who completed a second closed order with the same expert after the first order.
- **Retained Customer**: customer with 3 or more closed orders with the same expert over platform lifetime.

Retention and returning are treated as **different behavioral signals**, not interchangeable metrics.

---

## Data & Modeling Approach
- Source data: BigQuery (users, orders, transactions).
- Platform-wide customer ranking is used to correctly identify first and second closed orders.
- Expert-level reporting is limited to active and limited experts.
- Final output is stored as a **materialized table** to ensure performance, consistency, and BI stability.

The data model supports both **month** and **quarter** aggregation with a unified period dimension.

---

## SQL Implementation
The SQL layer:
- reconstructs customer order history across the entire platform,
- applies strict window-based ranking logic,
- separates eligibility logic (retained) from period-based metrics,
- produces a denormalized reporting table ready for BI consumption.

The query is optimized for reproducibility and monthly refresh.

(See `/sql` for full implementation.)

---

## BI Layer & Dashboard
The Looker Studio dashboard is built directly on the materialized BigQuery table.

Key features:
- Expert-level filtering (including `All`).
- Dynamic period type (month / quarter).
- Two analytical views:
  - **Dynamics**: retention and returning trends over time.
  - **Experts Ranking (Top-10)**: comparative expert performance with financial metrics.

The dashboard is designed for direct use by CS, Management, and Operations without additional interpretation.

(See `/dashboards` for screenshots and access link.)

---

## Key Results & Insights
The solution reveals:
- significant variance in retention quality between experts,
- cases where high order volume does not correlate with strong retention,
- experts with smaller customer bases but disproportionately high retained value,
- different behavioral patterns between returning and retained customers.

These insights were previously invisible in aggregated platform-level reporting.

---

## Business Impact
This analytics solution creates a measurable foundation for improving expert evaluation, motivation, and internal competition.

By combining Returning and Retained metrics with financial indicators, the dashboard enables the business to:
- move from subjective expert assessment to objective, data-driven evaluation,
- differentiate experts not only by volume, but by quality of customer relationships,
- identify experts who generate long-term customer value, not just short-term revenue.

The report supports the redesign of expert incentive and motivation programs by:
- linking bonuses and rewards to retention and returning performance,
- encouraging experts to focus on customer satisfaction and repeat behavior,
- increasing healthy competition between experts based on transparent and comparable metrics.

As a result, the business gains a scalable tool to align expert behavior with long-term platform value, customer loyalty, and sustainable revenue growth.

---

## Limitations & Next Steps
**Limitations**
- Retention is based on historical closed orders only.
- No cohort aging or churn timing analysis included.

**Next steps**
- Introduce cohort-based retention curves.
- Add time-to-second-order analysis.
- Extend model with pricing and discount impact.

---

## Tech Stack
- BigQuery (SQL, materialized tables)
- Looker Studio (BI & visualization)

---

## Repository Structure
See repository folders for SQL logic, dashboard assets, metrics reference, and sample data.
