# Metrics Reference – Returning & Retained by Expert

This document defines all metrics used in the Returning & Retained by Expert analytics solution.
All definitions are strict, non-ambiguous, and consistent across SQL and BI layers.

---

## Customers (Total)
Total number of unique customers who have at least one closed order with a given expert
during the selected reporting period.

---

## New First Closed Customers
Customers whose **first-ever closed order on the platform** occurred during the selected
period and was completed with the given expert.

Attribution is strictly assigned to the first expert and is not duplicated.

---

## Returning Customers (STRICT)
Customers who:
- completed a first closed order on the platform,
- then completed a **second closed order**,
- and the second order was completed with the **same expert** as the first one,
- within the selected reporting period.

Returning reflects *return-after-first* behavior and is treated separately from retention.

---

## Returning Rate
The share of returning customers among new first closed customers.

Calculated as:
Returning Customers / New First Closed Customers

---

## Retained Customers
Customers who have completed **three or more closed orders** with the same expert
over the entire platform lifetime.

Retention eligibility is lifetime-based, while metrics are reported per period.

---

## Retained Rate
The share of retained customers among total customers in the selected period.

Calculated as:
Retained Customers / Total Customers

---

## Orders (Retained)
Total number of closed orders placed by retained customers with the expert
during the selected period.

---

## Orders Value (Retained)
Total monetary value of closed orders placed by retained customers
during the selected period.

---

## ARPU (Retained)
Average revenue per retained customer.

Calculated as:
Orders Value (Retained) / Retained Customers

---

## Order Frequency (Retained)
Average number of closed orders per retained customer in the selected period.

This metric is used to explain differences in customer value and average check
between experts.
