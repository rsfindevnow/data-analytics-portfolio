# Tableau BI Dashboard Plan
## Sales & User Behavior Analytics (Daily Monitoring)

**Status:** FINAL (implemented and published)
**Tableau Public:** [Sales Analytics Dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)

---

## Overview

BI-dashboard for **operational post-analysis**: daily monitoring of trends, deviations, and segment contributions **without complex statistical tests**.
Target audience: business users, daily usage, parameter-driven date range selection.

---

## 1. Dashboard Structure (Sheet-by-Sheet)

### Dashboard 1 — Executive Monitor

#### S1. KPI Cards (5 separate text worksheets)
**Type:** KPI Cards
**Metrics:**
- Revenue (selected period)
- Orders (selected period)
- Sessions (selected period)
- Conversion Rate proxy (selected period)
- AOV proxy (selected period)

**Baseline:** Delta (%) vs previous analogous period.
**Date Range Parameter:** 1 day / 7 days / 30 days.

---

#### S2. Revenue Trend — Daily + 7D Rolling
**Type:** Line chart
- Line 1: Daily Revenue (gray, thin)
- Line 2: 7D Rolling Mean (red, thick)

**Purpose:** Trend detection without daily noise.

---

#### S3. Orders Trend — Daily + 7D Rolling
**Type:** Line chart
- Line 1: Daily Orders (gray, thin)
- Line 2: 7D Rolling Mean (red, thick)

---

#### S4. Revenue by Traffic Channel
**Type:** Horizontal bar chart
- Y: Traffic Channel (5 channels)
- X: Revenue

---

#### S5. Revenue by Country (TOP-10)
**Type:** Horizontal bar chart
- Y: Country (Top 10 by revenue)
- X: Revenue

**Note:** This sheet was added during implementation (not in original plan). Provides geographic drill-down directly on Dashboard 1.

---

#### S6. Revenue by Continent
**Type:** Horizontal bar chart
- Y: Continent
- X: Revenue

---

#### S7. Revenue by Device
**Type:** Horizontal bar chart
- Y: Device (desktop, mobile, tablet)
- X: Revenue

---

### Dashboard 2 — Drill-Down & Analysis (Top Mover)

#### S9. Top Mover Table
**Type:** Dynamic table with Parameter Selector
**Parameter:** Dimension Selector (Country / Category / Channel / Device)

**Columns:**
- Dimension value (dynamic)
- Revenue $ (absolute)
- Revenue % (delta vs previous period)
- Orders #
- Sessions #
- Conversion % (CR proxy)
- C.R. p.p. (conversion rate change vs previous period)
- AOV $
- Delta AOV $
- Revenue Share %

**Navigation:** "< Executive Monitor" link to Dashboard 1.

---

### Standalone Worksheets (not placed on dashboards)

#### S8. Revenue Split by User Type
**Type:** Stacked Area chart
- X: Date
- Y: Revenue
- Color: User Type (Registered / Unregistered)

**Purpose:** Monitor user segment contribution over time.

#### Top 10 Categories by Revenue
**Type:** Horizontal bar chart
- Y: Product Category (Top 10)
- X: Revenue

---

## 2. Tableau Calculated Fields

### 2.1 Core Metrics

**AOV:**
`AOV = IIF([Orders] > 0, [Revenue] / [Orders], NULL)`

**Conversion Rate:**
`CR = IIF([Sessions] > 0, [Orders] / [Sessions], NULL)`

---

### 2.2 Baseline Logic (Previous Analogous Period)

Date Range Parameter selects period length: 1 / 7 / 30 days.
Baseline = same-length period immediately preceding the selected period.

Example: if "Last 30 days" is selected (Jan 10 - Feb 9), baseline = Dec 11 - Jan 9.

Baseline metrics are pre-calculated in the dataset (`analytics_master_with_baseline_v2.csv`).

---

### 2.3 Delta Metrics

```
Delta Revenue = [Revenue] - [Baseline Revenue]
Delta Revenue % = ([Revenue] - [Baseline Revenue]) / [Baseline Revenue]
Delta Orders = [Orders] - [Baseline Orders]
Delta Sessions = [Sessions] - [Baseline Sessions]
Delta CR p.p. = [CR] - [Baseline CR]
Delta AOV = [AOV] - [Baseline AOV]
```

---

### 2.4 Rolling Metrics (Trend)

```
Revenue 7D MA = WINDOW_AVG(SUM([Revenue]), -6, 0)
Orders 7D MA = WINDOW_AVG(SUM([Orders]), -6, 0)
```

Compute using: `Date`

---

### 2.5 Dynamic Dimension Selector

```
Parameter: Dimension Selector
Type: String
Values: Country, Category, Channel, Device

Calculated Field — Selected Dimension:
CASE [Dimension Selector]
    WHEN "Country" THEN [country]
    WHEN "Category" THEN [product_category]
    WHEN "Channel" THEN [traffic_channel]
    WHEN "Device" THEN [device]
END
```

---

## 3. Data Source

### 3.1 Primary File
**File:** `analytics_master_with_baseline_v2.csv`
**Granularity:** 1 row = 1 day + segmentation dimensions
**Pre-calculated:** baseline metrics, rolling averages

### 3.2 Dimensions
- date
- user_type (Registered / Unregistered)
- continent
- country
- traffic_channel
- device
- product_category

### 3.3 Core Metrics
- sessions
- orders
- revenue

### 3.4 Baseline Fields
- baseline_date
- baseline_sessions
- baseline_orders
- baseline_revenue
- baseline_cr
- baseline_aov

---

## 4. Parameters

| Parameter | Type | Values | Default | Scope |
|-----------|------|--------|---------|-------|
| Date Range Selector | String | 1 day / 7 days / 30 days | 30 days | Both dashboards |
| Dimension Selector | String | Country / Category / Channel / Device | Country | Dashboard 2 |

---

## 5. Key BI Principles

- Period-over-period comparison (vs previous analogous period)
- Rolling averages for trend detection
- No statistical tests in BI layer
- Focus on contribution & deltas
- Dynamic dimension switching for drill-down
- Clear separation of Registered vs Unregistered users (standalone worksheet)

---

**Result:**
BI dashboard usable daily for monitoring business trends and decision-making without analyst involvement.

**Version:** 2.0 (Final)
**Date:** 2026-02-09
