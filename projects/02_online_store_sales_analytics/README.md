# Sales Analytics & BI Dashboard
## E-Commerce User Behavior Analysis | Portfolio Project

[![Tableau Public](https://img.shields.io/badge/Tableau_Public-View_Dashboard-E97627?style=flat&logo=tableau&logoColor=white)](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)
[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?style=flat&logo=jupyter&logoColor=white)](https://jupyter.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Project Overview

This portfolio project demonstrates **end-to-end data analytics skills** for a Data Analyst role, combining:
- **Statistical analysis** (hypothesis testing, segmentation, correlation analysis)
- **BI dashboard design** (Tableau operational monitoring)
- **Business insights** (actionable recommendations based on data-driven evidence)

**Business Context:** E-commerce furniture sales analytics with 350K+ sessions, $31.9M revenue, and multi-dimensional customer behavior data.

**Key Objective:** Separate **statistical rigor** (Jupyter notebook) from **operational monitoring** (Tableau BI) — ensuring data scientists and business users each have tools suited to their workflow.

**Live Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)

---

## Key Results & Insights

### Critical Findings

1. **Unregistered User Anomaly (Most Significant)**
   - **92% of sessions** are from unregistered users
   - Unregistered users generate **majority of revenue** (atypical for e-commerce)
   - **90% of registered users** have zero revenue
   - **Hypothesis:** Guest checkout removes friction, attracting high-value customers
   - **Recommendation:** Qualitative research (CustDev) + A/B test simplified registration

2. **Geographic Concentration**
   - **USA dominates:** 43.5% of global revenue ($13.9M)
   - **Americas region:** 55.3% of total revenue ($17.7M)
   - **Top 3 regions (Americas, Asia, Europe):** 97.4% of revenue

3. **Product Portfolio Concentration**
   - **Top 2 categories (Sofas + Chairs):** 45.4% of revenue ($14.5M)
   - **Top 3 categories:** 60.8% of revenue
   - **AOV varies:** Sofas ($1,951) >> Chairs ($1,032)

4. **Traffic Channel Performance**
   - **Organic Search:** Largest channel (34.2% revenue, $10.9M)
   - **Paid + Organic + Direct:** 81% of revenue
   - **Statistical evidence:** Kruskal-Wallis H=368.98, p<0.001
   - **Recommendation:** Reallocate budget from Social to Organic/Paid

5. **Device Consistency**
   - **Desktop:** 58-59% across all channels (consistent)
   - **Mobile:** ~40% (no channel-specific device preference)

---

## Project Structure

```
sales-analytics/
|
|-- data/
|   |-- raw/                              # Original BigQuery exports
|   |   +-- DA_dataset_damp.csv
|   +-- processed/
|       |-- analytics_master_enriched.csv          # Main dataset, Tableau data source (349K rows)
|
|-- notebooks/
|   +-- PortfolioProject1_final_version_ENG.ipynb  # Statistical analysis
|
|-- bi/
|   |-- Sales_Analytics_Dashboard.twb              # Tableau workbook
|   |-- tableau_dashboard_FINAL_SPECIFICATION.md   # Complete technical spec
|   |-- tableau_dashboard_plan.md                  # Dashboard plan
|   |-- DASHBOARD_MOCKUP_WIREFRAME.md              # Visual wireframes
|   |-- screenshots/
|   |   |-- EXECUTIVE MONITOR.png                  # Dashboard 1 screenshot
|   |   +-- TOP MOVER.png                          # Dashboard 2 screenshot
|   +-- scripts/
|       |-- create_aggregated_dataset.py           # Data preprocessing
|
|-- sql/
|   +-- session_date_for_csv_export_from_BQ.md     # BigQuery extraction query
|
|-- docs/
|   +-- methodology.md                             # Statistical methodology
|
|-- README.md                              # This file
|-- requirements.txt                       # Python dependencies
+-- LICENSE                                # MIT License
```

---

## Tableau Dashboard

### Live Dashboard

**[View on Tableau Public](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)**

---

### Dashboard 1: Executive Monitor

**Purpose:** Daily KPIs and high-level trends for quick business overview

![Executive Monitor](bi/screenshots/EXECUTIVE%20MONITOR.png)

**Components:**
- **KPI Cards** — Revenue, Orders, Sessions, Conversion Rate, AOV (with period-over-period deltas)
- **Revenue Trend** — Daily + 7-day rolling average
- **Orders Trend** — Daily + 7-day rolling average
- **Revenue by Country (TOP-10)** — Horizontal bar chart
- **Revenue by Continent** — Horizontal bar chart
- **Revenue by Device** — Horizontal bar chart
- **Revenue by Traffic Channel** — Horizontal bar chart

**Parameters:** Date Range Selector (1 day / 7 days / 30 days)

---

### Dashboard 2: Drill-Down & Analysis (Top Mover)

**Purpose:** Dynamic segment investigation with switchable dimensions

![Top Mover](bi/screenshots/TOP%20MOVER.png)

**Components:**
- **Top Mover Table** — Dynamic table with 10 metrics per dimension value
- **Dimension Selector** — Country / Category / Channel / Device
- **Period-over-period comparison** — Delta values for all metrics

**Table Columns:** Revenue $, Revenue %, Orders #, Sessions #, Conversion %, C.R. p.p., AOV $, Delta AOV $, Revenue Share %

---

### Standalone Worksheets
- **Revenue by User Type** — Stacked area chart (Registered vs Unregistered)
- **Top 10 Categories by Revenue** — Horizontal bar chart

---

### Design Decisions

| Decision | Rationale |
|----------|-----------|
| Top Mover table | Dynamic dimension switching covers more analysis scenarios |
| Revenue by Country on Dashboard 1 | Geographic breakdown is a primary daily monitoring need |
| Date Range as Parameter (1/7/30 days) | Standardized periods simplify baseline comparison |
| Standalone (User Type) | Important for deep analysis but not daily monitoring |

---

## Technologies & Skills

### Data Analysis & Statistics
- **Python:** pandas, numpy, scipy, statsmodels
- **Statistical Tests:** Chi-square, Kruskal-Wallis H-test, Mann-Whitney U, Kolmogorov-Smirnov, Bonferroni correction
- **Effect Size Metrics:** Cramer's V, Cliff's Delta

### Business Intelligence & Visualization
- **Tableau Desktop:** Interactive dashboards, calculated fields, parameters, table calculations
- **Dashboard Design:** Executive monitoring + drill-down analysis
- **Data Modeling:** Pre-aggregated data pipeline with baseline metrics

### Technical Skills
- **SQL (BigQuery):** Data extraction, window functions
- **Data Pipeline:** Python scripts for aggregation
- **Documentation:** Technical specifications, wireframing

---

## Dataset Description

**Source:** Google Analytics e-commerce data
**Granularity:** 1 row = 1 session x 1 product line
**Time Period:** November 1, 2020 — January 31, 2021 (3 months)
**Size:** 349,545 rows x 20 columns

### Key Metrics (Full Period)

| Metric | Value |
|--------|-------|
| **Total Revenue** | $31.9M |
| **Purchase Sessions** | 33,538 |
| **Total Sessions** | 349,545 |
| **Conversion Rate (proxy)** | 9.6% |
| **AOV (proxy)** | $953 |
| **Countries** | 100+ |
| **Product Categories** | 30+ |

---

## Methodology

### Analysis Workflow

```
1. Data Extraction (BigQuery)
   |
   v
2. Data Cleaning & Validation
   |
   v
3. Descriptive Statistics
   |
   v
4. Hypothesis Testing
   |  |-- Geographic differences (Chi-square)
   |  |-- Channel performance (Kruskal-Wallis)
   |  |-- User type behavior (Mann-Whitney U, KS test)
   |  +-- Post-hoc pairwise comparisons (Bonferroni)
   |
   v
5. Business Insights & Recommendations
   |
   v
6. BI Dashboard (Operational Monitoring)
   |
   v
7. Published to Tableau Public
```

### Dashboard Philosophy
- **BI = Operational Monitoring:** Daily trends, segment contributions, outlier detection
- **Notebook = Statistical Evidence:** P-values, correlations, hypothesis tests
- **No Statistical Tests in BI:** Business users see only actionable metrics

---

## How to Use This Repository

### Quick Overview (5 min)
1. Read this README for key findings
2. [View the live Tableau dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)

### Technical Deep-Dive (30 min)
1. Open [notebooks/PortfolioProject1_final_version_ENG.ipynb](notebooks/PortfolioProject1_final_version_ENG.ipynb) for statistical analysis
2. Review [bi/tableau_dashboard_FINAL_SPECIFICATION.md](bi/tableau_dashboard_FINAL_SPECIFICATION.md) for dashboard technical spec


```

---

## Data Limitations & Caveats

1. **"Order" Definition:** Dataset has 1 row per product line, not per order. 
2. **Attribution Quality:** 6.3% "Undefined" channel. Channel comparisons are directional
3. **Time Period:** Only 3 months (Nov 2020 — Jan 2021). Holiday season may skew patterns
4. **Order Date:** `order_date` proxied by `session.date`

---

## Documentation

| Document | Description |
|----------|-------------|
| [README.md](README.md) | Project overview (this file) |
| [PortfolioProject1_final_version_ENG.ipynb](notebooks/PortfolioProject1_final_version_ENG.ipynb) | Statistical analysis |
| [tableau_dashboard_FINAL_SPECIFICATION.md](bi/tableau_dashboard_FINAL_SPECIFICATION.md) | Complete Tableau spec |
| [DASHBOARD_MOCKUP_WIREFRAME.md](bi/DASHBOARD_MOCKUP_WIREFRAME.md) | Visual wireframes |
| [tableau_dashboard_plan.md](bi/tableau_dashboard_plan.md) | Dashboard plan |
| [methodology.md](docs/methodology.md) | Statistical methodology |
| [session_date_for_csv_export_from_BQ.md](sql/session_date_for_csv_export_from_BQ.md) | Data extraction query |

---

## License

This project is licensed under the MIT License.

**Data Source:** BigQuery public dataset (educational purposes)

---

**Last Updated:** 2026-02-09

**Status:** Completed — Statistical Analysis + Tableau Dashboard Published
