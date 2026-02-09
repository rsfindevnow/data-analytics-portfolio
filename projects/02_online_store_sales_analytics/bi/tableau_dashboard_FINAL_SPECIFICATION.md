# Tableau BI Dashboard — Complete Technical Specification
## Sales & User Behavior Analytics (Operational Monitoring)

**Status:** FINAL (implemented and published)
**Tableau Public:** [Sales Analytics Dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)

---

## Project Context

**Purpose:** Portfolio project for GitHub repository (Mid/Senior Data Analyst level)
**Data Source:** E-commerce analytics
**BI Approach:** Operational monitoring dashboard — daily trends, deviations, contributions, "where to dig"
**Audience:** Business users, daily usage, parameter-driven period selection

**Key Principle:**
- **BI = Operational monitoring** (trends, outliers, segment contribution)
- **Notebook = Methodology & statistical evidence** (p-values, correlations, tests)
- **Separation:** No statistical tests in BI layer, only actionable business metrics

---

## 1. Data Source Structure

### 1.1 Raw Data
**File:** `analytics_master_enriched.csv`
**Rows:** 349,545
**Granularity:** 1 row = 1 session (may contain multiple product lines per session)

### 1.2 Tableau Data Source
**File:** `analytics_master_with_baseline_v2.csv`
**Granularity:** Pre-aggregated daily data with baseline metrics
**Pre-calculated fields:** baseline metrics, rolling averages, delta values

### 1.3 Columns (Raw Data — 20 fields)

| # | Column | Type | Description | Tableau Role |
|---|--------|------|-------------|-------------|
| 1 | order_date | Date | Transaction/session date | Date dimension |
| 2 | ga_session_id | String | Unique session identifier | Dimension (not used in viz) |
| 3 | continent | String | User continent (6 values) | Dimension |
| 4 | country | String | User country (100+ values) | Dimension |
| 5 | device | String | desktop/mobile/tablet | Dimension |
| 6 | browser | String | Browser name | Dimension (drill-down) |
| 7 | operating_system | String | OS name | Dimension (drill-down) |
| 8 | mobile_model_name | String | Mobile device model | Dimension (drill-down) |
| 9 | language | String | User language | Dimension (drill-down) |
| 10 | traffic_source_name | String | Traffic source detail | Dimension (drill-down) |
| 11 | traffic_channel | String | 5 channels | Dimension |
| 12 | user_id | String | User ID (empty for unregistered) | Dimension |
| 13 | email_verified | Integer | 0/1 flag | Dimension |
| 14 | is_subscribed | Integer | 0/1 flag | Dimension |
| 15 | product_category | String | Product category (30+ values) | Dimension |
| 16 | product_name | String | Product name | Dimension (drill-down) |
| 17 | product_price | Numeric | Product price (USD) | Measure |
| 18 | product_short_description | String | Description | Dimension (tooltip) |
| 19 | has_purchase | Boolean | True/False (purchase flag) | Filter |
| 20 | revenue | Numeric | Transaction revenue (USD) | Measure |

### 1.4 Key Dimensions

**Traffic Channels:** 5
- Direct, Organic Search, Paid Search, Social Search, Undefined

**Devices:** 3
- desktop, mobile, tablet

**User Types:** 2 (derived)
- Registered (user_id not empty): 27,945 sessions (8%)
- Unregistered: 321,600 sessions (92%)

### 1.5 Baseline Metrics (Full Period)

| Metric | Value | Notes |
|--------|-------|-------|
| **Total Sessions** | 349,545 | All rows |
| **Total Revenue** | $31.9M | Sum of revenue where has_purchase = True |
| **Purchase Sessions (Orders proxy)** | 33,538 | has_purchase = True |
| **Conversion Rate (proxy)** | 9.6% | Purchase sessions / Total sessions |
| **AOV (proxy)** | $953 | Revenue / Purchase Sessions |

---

## 2. Dashboard Architecture

### Dashboard 1 — Executive Monitor
**Purpose:** Daily KPIs, trends, and segment performance at a glance

**Sheets (11 worksheet elements):**
1. **S1 — KPI Cards** (5 text worksheets): Revenue, Orders, Sessions, Conversion, AOV
2. **S2 — Revenue Trend** — Daily + 7D rolling average (line chart)
3. **S3 — Orders Trend** — Daily + 7D rolling average (line chart)
4. **S4 — Revenue by Traffic Channel** — Horizontal bar chart (5 channels)
5. **S5 — Revenue by Country (TOP-10)** — Horizontal bar chart
6. **S6 — Revenue by Continent** — Horizontal bar chart
7. **S7 — Revenue by Device** — Horizontal bar chart (3 devices)

**Parameters:**
- Date Range Selector (1 day / 7 days / 30 days)

---

### Dashboard 2 — Drill-Down & Analysis (Top Mover)
**Purpose:** Dynamic segment investigation with switchable dimensions

**Sheets (1 worksheet element):**
8. **S9 — Top Mover Table** — Dynamic table with Dimension Selector parameter

**Parameters:**
- Dimension Selector (Country / Category / Channel / Device)
- Date Range Selector (1 day / 7 days / 30 days)

**Navigation:**
- "< Executive Monitor" link back to Dashboard 1

---

### Standalone Worksheets (not placed on dashboards)
9. **S8 — Revenue by User Type** — Stacked area chart (time series)
10. **Top 10 Categories by Revenue** — Horizontal bar chart

---

## 3. Detailed Sheet Specifications

---

### DASHBOARD 1: EXECUTIVE MONITOR

---

### Sheet S1: KPI Cards (5 text worksheets)

**Type:** KPI Dashboard (5 cards in a row)

**Metrics:**
1. **Revenue** — Format: `$###,###.#K` or `$##.#M`
2. **Orders** — Format: `##,###`
3. **Sessions** — Format: `###,###`
4. **Conversion Rate (proxy)** — Format: `#.#%`
5. **AOV (proxy)** — Format: `$###.##`

**Delta Logic:**
- Each KPI shows delta % vs previous analogous period
- Period determined by Date Range Selector parameter
- Green arrow (^) for positive, Red arrow (v) for negative

**Layout:**
```
+-----------+-----------+------------+-------------+-----------+
|  REVENUE  |  ORDERS   |  SESSIONS  |  CONVERTION |    AOV    |
| $9,650.8K | 10,095    |  114,882   |    8.8%     |  $956.00  |
| v 19.2%   | v 17.1%   |  ^ 7.8%    |   v 1.3%    |  v 2.5%   |
+-----------+-----------+------------+-------------+-----------+
```

**Implementation:**
- 5 separate text worksheets (one per KPI)
- Each uses `SUM` / `COUNTD` filtered by Date Range parameter
- Delta = (Current - Baseline) / Baseline * 100
- Conditional color formatting based on delta sign
- Assembled in Dashboard with horizontal layout container

---

### Sheet S2: Revenue Trend — Daily + 7D Rolling

**Type:** Dual-line chart

**X-axis:** Date (continuous)
**Y-axis:** Revenue (USD)

**Lines:**
1. **Daily Revenue** — thin, gray (#CCCCCC)
2. **7D Rolling Average** — thick, red (#C44E52)

**Calculated Field:**
```tableau
Revenue 7D MA:
WINDOW_AVG(SUM([Revenue]), -6, 0)
// Compute Using: Table (across) -> Date
```

---

### Sheet S3: Orders Trend — Daily + 7D Rolling

**Type:** Dual-line chart (same structure as S2)

**Lines:**
1. **Daily Orders** — thin, gray
2. **7D Rolling Average** — thick, red

---

### Sheet S4: Revenue by Traffic Channel

**Type:** Horizontal bar chart

**Rows:** Traffic Channel (5 channels, sorted by revenue descending)
**Columns:** SUM(Revenue)

**Labels:** Revenue value + % share
**Color:** Blue categorical shades

---

### Sheet S5: Revenue by Country (TOP-10)

**Type:** Horizontal bar chart

**Rows:** Country (Top 10 by revenue, sorted descending)
**Columns:** SUM(Revenue)

**Labels:** Revenue value + % share
**Color:** Blue gradient

**Top N Filter:** Top 10 countries by SUM(Revenue)

---

### Sheet S6: Revenue by Continent

**Type:** Horizontal bar chart

**Rows:** Continent (sorted by revenue descending)
**Columns:** SUM(Revenue)

**Labels:** Revenue value + % share
**Color:** Blue gradient

---

### Sheet S7: Revenue by Device

**Type:** Horizontal bar chart

**Rows:** Device (desktop, mobile, tablet)
**Columns:** SUM(Revenue)

**Labels:** Revenue value + % share
**Color:** Blue

---

### DASHBOARD 2: DRILL-DOWN & ANALYSIS (TOP MOVER)

---

### Sheet S9: Top Mover Table (Dynamic)

**Type:** Dynamic table with Parameter Selector

**Purpose:** Switch between dimensions (Country / Category / Channel / Device) to analyze top performers with period-over-period comparison.

**Parameter — Dimension Selector:**
```tableau
Name: Dimension Selector
Type: String
List values: Country, Category, Channel, Device
Default: Country
```

**Calculated Field — Selected Dimension:**
```tableau
CASE [Dimension Selector]
    WHEN "Country" THEN [country]
    WHEN "Category" THEN [product_category]
    WHEN "Channel" THEN [traffic_channel]
    WHEN "Device" THEN [device]
END
```

**Table Columns (10):**

| Column | Description | Format |
|--------|-------------|--------|
| Dimension | Dynamic dimension value | Text |
| Revenue $ | Absolute revenue | $###,### |
| Revenue % | Delta vs previous period | +/-##.#% |
| Orders # | Order count | ##,### |
| Sessions # | Session count | ###,### |
| Conversion % | CR proxy | ##.#% |
| C.R. p.p. | CR change in percentage points | +/-#.# p.p. |
| AOV $ | Average order value | $###.## |
| Delta AOV $ | AOV change vs previous period | +/-$###.## |
| Revenue Share % | Share of total revenue | ##.#% |

**Total Row:** Aggregated totals at the bottom of the table.

**Color Formatting:**
- Positive deltas: Green text
- Negative deltas: Red text
- Header: Dark blue-gray background, white text
- Rows: Alternating white / light gray

---

### STANDALONE WORKSHEETS

---

### Sheet S8: Revenue by User Type (Standalone)

**Type:** Stacked area chart
**Status:** Implemented as standalone worksheet (not placed on dashboard)

**X-axis:** Date (continuous)
**Y-axis:** Revenue (stacked)
**Color:** User Type (Registered = dark blue, Unregistered = light blue)

**Calculated Field:**
```tableau
User Type:
IF LEN([user_id]) > 0 THEN "Registered" ELSE "Unregistered" END
```

---

### Top 10 Categories by Revenue (Standalone)

**Type:** Horizontal bar chart
**Status:** Implemented as standalone worksheet (not placed on dashboard)

**Rows:** Product Category (Top 10 by revenue)
**Columns:** SUM(Revenue)

---

## 4. Tableau Calculated Fields Library

### 4.1 Core Metrics

```tableau
// Revenue
Revenue:
SUM([revenue])

// Orders (distinct purchase sessions)
Orders:
COUNTD(IF [has_purchase] = True THEN [ga_session_id] END)

// Sessions (all distinct sessions)
Sessions:
COUNTD([ga_session_id])

// AOV (proxy)
AOV Proxy:
IIF([Orders] > 0, [Revenue] / [Orders], NULL)

// Conversion Rate (proxy)
CR Proxy:
IIF([Sessions] > 0, [Orders] / [Sessions], NULL)

// Revenue Share (%)
Revenue Share:
SUM([Revenue]) / TOTAL(SUM([Revenue]))
```

---

### 4.2 User Segmentation

```tableau
// User Type
User Type:
IF LEN([user_id]) > 0 THEN "Registered" ELSE "Unregistered" END
```

---

### 4.3 Rolling Averages (Table Calculations)

```tableau
// Revenue 7D Moving Average
Revenue 7D MA:
WINDOW_AVG(SUM([Revenue]), -6, 0)
// Compute Using: Table (across) -> Date

// Orders 7D Moving Average
Orders 7D MA:
WINDOW_AVG([Orders], -6, 0)
// Compute Using: Table (across) -> Date
```

---

### 4.4 Delta Metrics (Period-over-Period)

```tableau
// Revenue Delta %
Delta Revenue %:
(SUM([Revenue]) - SUM([Baseline Revenue])) / SUM([Baseline Revenue])

// CR Delta (percentage points)
Delta CR pp:
[CR Proxy] - [Baseline CR]

// AOV Delta
Delta AOV:
[AOV Proxy] - [Baseline AOV]
```

---

### 4.5 Dynamic Dimension Selector

```tableau
// Parameter: Dimension Selector
Name: Dimension Selector
Type: String
List values: Country, Category, Channel, Device
Current value: Country

// Calculated Field: Selected Dimension
Selected Dimension:
CASE [Dimension Selector]
    WHEN "Country" THEN [country]
    WHEN "Category" THEN [product_category]
    WHEN "Channel" THEN [traffic_channel]
    WHEN "Device" THEN [device]
END
```

---

### 4.6 Date Range Parameter

```tableau
// Parameter: Date Range Selector
Name: Date Range Selector
Type: String
List values: 1 day, 7 days, 30 days
Current value: 30 days

// Calculated Field: In Date Range
In Date Range:
CASE [Date Range Selector]
    WHEN "1 day"  THEN [order_date] >= TODAY() - 1
    WHEN "7 days" THEN [order_date] >= TODAY() - 7
    WHEN "30 days" THEN [order_date] >= TODAY() - 30
END
```

---

## 5. Parameters Summary

| Parameter | Type | Values | Default | Used In |
|-----------|------|--------|---------|---------|
| Date Range Selector | String | 1 day / 7 days / 30 days | 30 days | Both dashboards, all sheets |
| Dimension Selector | String | Country / Category / Channel / Device | Country | Dashboard 2 (Top Mover) |

---

## 6. Data Pipeline

### 6.1 Scripts

| Script | Purpose | Input | Output |
|--------|---------|-------|--------|
| `create_aggregated_dataset.py` | Aggregate raw data to daily grain | `analytics_master_enriched.csv` | `analytics_master_aggregated.csv` |

### 6.2 Pipeline Flow

```
analytics_master_enriched.csv (349K rows, session-level)
    |
    v [Tableau Desktop]
Sales_Analytics_Dashboard.twb
    |
    v [Tableau Public]
Published dashboard
```

---

## 7. Best Practices & Data Warnings

### 7.1 Data Interpretation Warnings

**"Orders" Metric:**
- Dataset has 1 row per product line within a session
- `COUNTD(ga_session_id WHERE has_purchase = True)` counts purchase sessions, not unique orders
- "Orders" and "Conversion Rate" are proxies
- Labeled as proxies throughout the dashboard

**Attribution Quality:**
- "Undefined" channel: 6.3% of revenue
- Conversion rate appears similar across channels (artifact of data structure)
- Channel comparisons are directional, not absolute

**Unregistered Anomaly:**
- 92% of sessions are from unregistered users
- Unregistered users generate majority of revenue
- Atypical for e-commerce — documented in notebook analysis

### 7.2 Design Decisions

**Why Top Mover table instead of Heatmap:**
- Dynamic dimension switching provides more flexibility
- Single table covers Country, Category, Channel, Device analysis
- Period-over-period deltas add temporal context
- Heatmap would require fixed dimensions

**Why Revenue by Country on Dashboard 1:**
- Geographic breakdown is a primary monitoring need
- Adds country-level granularity beyond continent view
- Top 10 filter keeps the chart readable

**Why standalone S8 (Revenue by User Type):**
- User type split is important for deep analysis but not daily monitoring
- Keeps Dashboard 2 focused on the Top Mover drill-down
- Available for ad-hoc investigation when needed

---

## 8. Key Insights Summary

**Geographic:**
- USA dominates: 43.5% of global revenue ($13.9M)
- Top 3 regions (Americas, Asia, Europe): 97.4% of revenue

**Product:**
- Top 2 categories (Sofas + Chairs): 45.4% of revenue
- AOV varies 7x between categories

**Traffic:**
- Organic Search: largest channel (34.2%)
- Top 3 channels: 81% of revenue

**Device:**
- Desktop: 58-59% across all channels
- Mobile: ~40% consistent
- Tablet: ~2% minimal

**User Behavior (ANOMALY):**
- Unregistered: 92% of sessions, majority of revenue
- Registered: 90% have zero revenue

---

## 9. Deliverables Checklist

### For GitHub Portfolio:
- [x] `analytics_master_enriched.csv` — source data
- [x] `Sales_Analytics_Dashboard.twb` — Tableau workbook
- [x] `tableau_dashboard_FINAL_SPECIFICATION.md` — this document
- [x] `DASHBOARD_MOCKUP_WIREFRAME.md` — wireframes (updated to match final)
- [x] `tableau_dashboard_plan.md` — dashboard plan (updated)
- [x] `README.md` — project overview with Tableau Public link
- [x] Screenshots of both dashboards (PNG)
- [x] `PortfolioProject1_final_version_ENG.ipynb` — statistical analysis
- [x] Data pipeline scripts (`create_aggregated_dataset.py`, `calculate_baseline_metrics_v2.py`)
- [x] Published to Tableau Public

### Quality Checks:
- [x] All sheets load without errors
- [x] Parameters work (Date Range, Dimension Selector)
- [x] Delta calculations verified
- [x] Dashboard navigation works (link between dashboards)
- [x] Published to Tableau Public and accessible

---

**Version:** 2.0 (Final — matches published dashboard)
**Date:** 2026-02-09
**Author:** Data Analyst (Portfolio Project)
**Data Source:** `analytics_master_enriched.csv` (349,545 rows)
**Dashboard Pages:** 2 (Executive Monitor + Drill-Down Top Mover)
**Total Worksheets:** 14 (11 on dashboards + 2 standalone + top 10 categories)
**Tableau Public:** [Live Dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)
