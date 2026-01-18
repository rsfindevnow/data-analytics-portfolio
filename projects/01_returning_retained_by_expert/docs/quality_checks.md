# Quality Checks – Returning & Retained by Expert

This document lists mandatory data quality and sanity checks applied
before publishing analytics results.

---

## Sanity Checks
- Returning Customers ≤ New First Closed Customers
- Retained Customers ≤ Total Customers
- Orders (Retained) ≥ Retained Customers

---

## Deduplication
- Customers are counted uniquely per expert and period.
- No customer can be attributed to multiple experts as first closed.

---

## Aggregation Validation
- BI aggregates are reconciled with raw SQL outputs.
- Period-level totals are cross-checked against base tables.

---

## Consistency
- Metric definitions are consistent between SQL and BI layers.
- No metric is recalculated or overridden at the BI level.

Only validated data is published for business use.
