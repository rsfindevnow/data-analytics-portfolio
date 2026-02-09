# Tableau Dashboard — Visual Mockup & Wireframe
## Sales & User Behavior Analytics

**Status:** FINAL (matches published Tableau Public version)
**Tableau Public:** [Sales Analytics Dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)

---

## Dashboard 1: EXECUTIVE MONITOR

**Purpose:** Daily KPIs and high-level trends for quick business overview

**Size:** 1920x1080 (Full HD)
**Target Audience:** C-level, Marketing Director, Business Analysts

---

### Layout Structure

```
+-------------------------------------------------------------------------------------+
|  Sales Analytics - Executive Monitor                     [Date Range Period: 30 days]|
|                                                          [Active Filters]            |
+-------------------------------------------------------------------------------------+
|                                                                                      |
|  +-----------+-----------+------------+-------------+-----------+                    |
|  |  REVENUE  |  ORDERS   |  SESSIONS  |  CONVERTION |    AOV    |                    |
|  | $9,650.8K | 10,095    |  114,882   |    8.8%     |  $956.00  |                    |
|  | v 19.2%   | v 17.1%   |  ^ 7.8%    |   v 1.3%    |  v 2.5%   |                    |
|  +-----------+-----------+------------+-------------+-----------+                    |
|                                                                                      |
+-------------------------------------------------------------------------------------+
|                                                                                      |
|  +--------------------------------------+ +---------------------------------------+  |
|  | Revenue Trend                        | | Orders Trend                          |  |
|  | Daily & 7-Day Rolling Average        | | Daily & 7-Day Rolling Average         |  |
|  |                                      | |                                       |  |
|  |  800K|        /\   /\                | |  400|       /\    /\                   |  |
|  |      |   /\  /  \_/  \     /\       | |     |  /\  /  \_/  \     /\           |  |
|  |  600K|  /  \/         \   /  \      | |  300| /  \/         \   /  \          |  |
|  |      | /              \_/    \     | |     |/              \_/    \         |  |
|  |  400K|/                       \    | |  200|                       \        |  |
|  |      +-------------------------+   | |     +-------------------------+      |  |
|  |       Nov        Dec        Jan    | |      Nov        Dec        Jan      |  |
|  |  -- Daily (gray)  -- 7D MA (red)   | |  -- Daily (gray)  -- 7D MA (red)    |  |
|  +--------------------------------------+ +---------------------------------------+  |
|                                                                                      |
+-------------------------------------------------------------------------------------+
|                                                                                      |
|  +--------------------------------------+ +---------------------------------------+  |
|  | Revenue by Country (TOP-10)          | | Revenue by Continent                  |  |
|  |                                      | |                                       |  |
|  | United States ############ $5.3M 55% | | Americas   ############### $5.4M 55%  |  |
|  | India         ####  $845K  9%        | | Asia       ######  $2.3M   24%        |  |
|  | Canada        ###   $741K  8%        | | Europe     #####   $1.8M   18%        |  |
|  | United Kingdom ##   $264K  3%        | | Africa     #       $143K    1%        |  |
|  | France         #    $253K  3%        | | Oceania    #        $58K    1%        |  |
|  | ...                                  | |                                       |  |
|  +--------------------------------------+ +---------------------------------------+  |
|                                                                                      |
+-------------------------------------------------------------------------------------+
|                                                                                      |
|  +--------------------------------------+ +---------------------------------------+  |
|  | Revenue by Device                    | | Revenue by Traffic Channel            |  |
|  |                                      | |                                       |  |
|  | desktop ################ $5.6M  58%  | | Organic Search ############ $3.4M 35% |  |
|  | mobile  ##########  $3.7M       38%  | | Paid Search    ########  $2.5M    26% |  |
|  | tablet  #           $196K        2%  | | Direct         #######   $2.2M    23% |  |
|  |                                      | | Social Search  ###       $766K     8% |  |
|  |                                      | | Undefined      ##        $593K     6% |  |
|  +--------------------------------------+ +---------------------------------------+  |
|                                                                                      |
+-------------------------------------------------------------------------------------+
```

---

### Color Scheme — Dashboard 1

**Header:**
- Background: White
- Title: Dark gray (#333333) — Bold

**KPI Cards:**
- Background: White (#FFFFFF)
- Border: Light gray (#E0E0E0)
- Text (Value): Dark red (#8B1A1A) — Size 36pt Bold
- Text (Label): Dark gray (#555555) — Size 12pt
- Delta (Positive): Green (#28A745) with ^ arrow
- Delta (Negative): Red (#DC3545) with v arrow

**Line Charts (Trends):**
- Daily line: Light gray (#CCCCCC), width 1px
- 7D Rolling Average: Red (#C44E52), width 2px
- Background: White
- Grid: Light gray dashed

**Bar Charts:**
- Country: Blue gradient (#4E79A7 to #A0CBE8)
- Continent: Blue gradient (#4E79A7 to #A0CBE8)
- Device: Blue (#4E79A7)
- Traffic Channel: Categorical blue shades

---

## Dashboard 2: DRILL-DOWN & ANALYSIS — TOP MOVER

**Purpose:** Deep-dive into segments by dynamic dimension for detailed investigation

**Size:** 1920x1080 (Full HD)
**Target Audience:** Product Managers, Marketing Analysts, Data Analysts

---

### Layout Structure

```
+-------------------------------------------------------------------------------------+
|  [< Executive Monitor]      DRILL-DOWN & ANALYSIS                                    |
|                             TOP MOVER                                                |
|                                                                                      |
|                                              Dimension Selector: [Country       v]   |
|                                              Date Range Selector: [Last 30 days v]   |
+-------------------------------------------------------------------------------------+
|                                                                                      |
|  +---------------------------------------------------------------------------------+ |
|  | Dimension   | Revenue $  | Revenue % | Orders # | Sessions # | Conv % | ...    | |
|  |-------------|------------|-----------|----------|------------|--------|--------| |
|  | USA         | $5,343,154 | -19.4%    | 5,590    | 53,413     | 10.5%  | ...    | |
|  | India       | $845,055   | -23.5%    | 908      | 10,253     | 8.9%   | ...    | |
|  | Canada      | $741,517   | -25.0%    | 781      | 9,140      | 8.5%   | ...    | |
|  | UK          | $264,274   | -24.2%    | 283      | 3,495      | 8.1%   | ...    | |
|  | France      | $253,147   | -3.1%     | 253      | 2,320      | 10.9%  | ...    | |
|  | Germany     | $215,556   | +22.2%    | 237      | 1,924      | 12.3%  | ...    | |
|  | ...         | ...        | ...       | ...      | ...        | ...    | ...    | |
|  |             |            |           |          |            |        |        | |
|  | Total       | $9,650,774 | -19.2%    | 10,095   | 114,882    | 8.8%   | ...    | |
|  +---------------------------------------------------------------------------------+ |
|                                                                                      |
+-------------------------------------------------------------------------------------+
```

**Full Table Columns:**
1. Dimension (Country / Category / Channel / Device — dynamic)
2. Revenue $ — absolute value
3. Revenue % — delta vs previous period
4. Orders # — count
5. Sessions # — count
6. Conversion % — CR proxy
7. C.R. p.p. — conversion rate change in percentage points vs previous period
8. AOV $ — average order value
9. Delta AOV $ — AOV change vs previous period
10. Revenue Share % — share of total revenue

---

### Color Scheme — Dashboard 2

**Header:**
- Background: Light gray (#F5F5F5)
- Title: Dark gray (#333333) — Bold
- Navigation link: Blue (#1F77B4)

**Top Mover Table:**
- Header row: Dark blue-gray background (#4E5D6C), white text
- Data rows: Alternating white / light gray (#F8F9FA)
- Positive deltas: Green text (#28A745)
- Negative deltas: Red text (#DC3545)
- Total row: Bold, light gray background

**Parameter Controls:**
- Dropdown style, positioned top-right
- Active selection highlighted

---

## Additional Worksheets (Standalone)

### S8: Revenue by User Type
**Type:** Stacked area chart
**Status:** Implemented as standalone worksheet (not placed on dashboard)

```
+--------------------------------------+
| Revenue by User Type                 |
|                                      |
|  800K|  ############################|
|      |  ## Unregistered (light blue) |
|  600K|  ############################|
|      |  ############################|
|  400K|  ############################|
|      |  ## Registered (dark blue)   |
|  200K|  ############################|
|      +-------------------------------+
|       Nov        Dec        Jan      |
+--------------------------------------+
```

### Top 10 Categories by Revenue
**Type:** Horizontal bar chart
**Status:** Implemented as standalone worksheet (not placed on dashboard)

---

## Interactive Elements

### Parameters
1. **Date Range Selector** — Parameter with 3 options: 1 day / 7 days / 30 days
2. **Dimension Selector** (Dashboard 2) — Country / Category / Channel / Device

### Baseline Logic
- Deltas (%) compare selected period vs previous analogous period
- Example: Last 30 days vs preceding 30 days

### Click Actions
- **Dashboard 1:** Click on bar charts cross-filters related sheets
- **Dashboard 2:** Dimension Selector changes all rows in Top Mover table

### Navigation
- Dashboard 2 has "< Executive Monitor" link back to Dashboard 1
- Tab navigation between dashboards

---

## Responsive Design

### Desktop (1920x1080)
- Full layout as shown above
- Dashboard 1: 4 visual areas (KPIs + trends + 4 bar charts)
- Dashboard 2: Full-width table

### Laptop (1366x768)
- Reduce vertical spacing
- KPI cards: Font size 28pt to 24pt
- Table: Scrollable horizontally if needed

---

## Worksheets Summary

| # | Worksheet Name | Type | Dashboard | Status |
|---|---------------|------|-----------|--------|
| S1 | Revenue (txt) | KPI Card | Dashboard 1 | Implemented |
| S1 | Orders (txt) | KPI Card | Dashboard 1 | Implemented |
| S1 | Sessions (txt) | KPI Card | Dashboard 1 | Implemented |
| S1 | Conversion (txt) | KPI Card | Dashboard 1 | Implemented |
| S1 | AOV (txt) | KPI Card | Dashboard 1 | Implemented |
| S2 | Revenue Trend | Line Chart | Dashboard 1 | Implemented |
| S3 | Orders Trend | Line Chart | Dashboard 1 | Implemented |
| S4 | Revenue by Traffic Channel | Bar Chart | Dashboard 1 | Implemented |
| S5 | Revenue by Country | Bar Chart | Dashboard 1 | Implemented |
| S6 | Revenue by Continent | Bar Chart | Dashboard 1 | Implemented |
| S7 | Revenue by Device | Bar Chart | Dashboard 1 | Implemented |
| S8 | Revenue by User Type | Stacked Area | Standalone | Implemented |
| S9 | Top Mover | Dynamic Table | Dashboard 2 | Implemented |
| -- | Top 10 Categories | Bar Chart | Standalone | Implemented |

**Originally Planned but Not Implemented:**
- Category x Country Heatmap
- Warning Card (Unregistered Anomaly text box)
- Top 5 Countries bar chart (separate; covered by S5 on Dashboard 1)

---

**Mockup Version:** 2.0 (Final — matches production)
**Date:** 2026-02-09
**Tableau Public:** [Live Dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)
