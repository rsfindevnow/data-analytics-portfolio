# Methodology – Returning & Retained by Expert

This document describes the methodological principles behind the Returning & Retained
analytics solution.

---

## Closed Order Definition
A closed order is defined strictly as an order with:
- transaction type = Wage
- transaction status = Success

The transaction creation timestamp is used as the single source of truth
for order closure.

---

## Customer Lifecycle Logic
Customer behavior is reconstructed using **platform-wide order history** to avoid
misattribution and local expert bias.

First and second closed orders are identified globally before expert-level aggregation.

---

## Returning vs Retained
Returning and retained customers represent different behavioral patterns:

- Returning reflects early repeat behavior after the first order.
- Retained reflects long-term engagement and loyalty.

These metrics are intentionally not merged or substituted for one another.

---

## Retention Eligibility
Retention eligibility is defined using lifetime order count with the same expert
(≥ 3 closed orders).

All closed orders of eligible retained customers within the reporting period
are included in retained metrics.

---

## Periodization
The solution supports:
- Monthly aggregation
- Quarterly aggregation

Period logic is unified across all metrics to ensure comparability.
