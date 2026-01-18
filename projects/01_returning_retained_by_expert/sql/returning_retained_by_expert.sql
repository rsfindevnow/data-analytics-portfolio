-- =================================================================================================
-- Returning & Retained Clients by Expert
--
-- Purpose
--   Build a BI-ready (month/quarter) reporting table with:
--     - total closed customers per expert-period
--     - new first-closed customers (platform-first, attributed to the first expert)
--     - returning customers (STRICT: 2nd closed order in period AND same expert as the 1st)
--     - retained customers (lifetime eligibility: 3+ closed orders with the same expert)
--     - retained financial metrics (orders value, orders count, ARPU)
--
-- Definitions
--   Closed order:
--     transactions.type='wage' AND transactions.status='success'
--     Event timestamp: transactions.createdAt (wage_ts)
--
-- Parameters
--   dt_to   = last day of previous month
--   dt_from = start of year of dt_to (YTD). Switchable to rolling-12 if needed.
--
-- Notes for GitHub / portability
--   Replace the placeholders below with your real project/dataset names.
--   Recommended convention:
--     source:  `project_id.analytics.users|orders|transactions`
--     output:  `project_id.analytics.returning_retained_dashboard`
-- =================================================================================================

-- ---------------------------
-- 0) Parameters
-- ---------------------------
DECLARE dt_to   DATE DEFAULT LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH));
DECLARE dt_from DATE DEFAULT DATE_TRUNC(dt_to, YEAR);  -- YTD

-- If you need rolling 12 months instead of YTD, use:
-- DECLARE dt_from DATE DEFAULT DATE_SUB(dt_to, INTERVAL 12 MONTH);

-- ---------------------------
-- 1) Output table
-- ---------------------------
-- Set output table here (placeholder). Example:
-- CREATE OR REPLACE TABLE `my_project.analytics.returning_retained_dashboard` AS
CREATE OR REPLACE TABLE `project_id.analytics.returning_retained_dashboard` AS

WITH
/* -------------------------------------------------------------------------------------------------
   2) Expert scope
   Only experts that should appear in the report.
-------------------------------------------------------------------------------------------------- */
experts_filtered AS (
  SELECT
    u.id AS expert_id,
    CONCAT(u.firstName, ' ', u.lastName) AS expert_full_name,
    u.status AS expert_status
  FROM `project_id.analytics.users` u
  WHERE LOWER(TRIM(u.role)) = 'expert'
    AND LOWER(TRIM(u.status)) IN ('active', 'limited')
),

/* -------------------------------------------------------------------------------------------------
   3) Orders base (platform-wide)
   Minimal mapping order -> (expert, customer). Keeping this separate helps clarity and QA.
-------------------------------------------------------------------------------------------------- */
orders_all AS (
  SELECT
    o.id AS order_id,
    o.expertId AS expert_id,
    o.customerId AS customer_id
  FROM `project_id.analytics.orders` o
  WHERE o.id IS NOT NULL
    AND o.expertId IS NOT NULL
    AND o.customerId IS NOT NULL
),

/* -------------------------------------------------------------------------------------------------
   4) Wage-success transactions (closed facts)
   We treat a successful wage transaction as the single source of truth for "Closed".
   - wage_ts: first successful wage timestamp per order
   - wage_amount_cents: sum of wage amounts per order (kept in cents, converted later)
-------------------------------------------------------------------------------------------------- */
wage_success_by_order AS (
  SELECT
    t.orderId AS order_id,
    MIN(t.createdAt) AS wage_ts,
    SUM(SAFE_CAST(t.amount AS NUMERIC)) AS wage_amount_cents
  FROM `project_id.analytics.transactions` t
  WHERE t.orderId IS NOT NULL
    AND LOWER(TRIM(t.type)) = 'wage'
    AND LOWER(TRIM(t.status)) = 'success'
  GROUP BY t.orderId
),

/* -------------------------------------------------------------------------------------------------
   5) Closed orders on the platform
   Join orders with their closed timestamp & value.
-------------------------------------------------------------------------------------------------- */
closed_orders_platform AS (
  SELECT
    o.customer_id,
    o.expert_id,
    o.order_id,
    w.wage_ts,
    w.wage_amount_cents
  FROM orders_all o
  JOIN wage_success_by_order w
    ON w.order_id = o.order_id
),

/* -------------------------------------------------------------------------------------------------
   6) Rank closed orders per customer (platform-wide lifecycle)
   This ranking is the core of returning/new attribution logic.
-------------------------------------------------------------------------------------------------- */
ranked_closed AS (
  SELECT
    customer_id,
    expert_id,
    order_id,
    wage_ts,
    wage_amount_cents,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY wage_ts, order_id) AS rn
  FROM closed_orders_platform
),

/* -------------------------------------------------------------------------------------------------
   7) First & second closed order on platform per customer
-------------------------------------------------------------------------------------------------- */
first_closed_platform AS (
  SELECT
    customer_id,
    expert_id AS first_expert_id,
    wage_ts  AS first_closed_ts
  FROM ranked_closed
  WHERE rn = 1
),
second_closed_platform AS (
  SELECT
    customer_id,
    expert_id AS second_expert_id,
    wage_ts  AS second_closed_ts
  FROM ranked_closed
  WHERE rn = 2
),

/* -------------------------------------------------------------------------------------------------
   8) Closed orders for reported experts inside the time window (dt_from..dt_to)
   We filter by experts scope AND reporting window for BI periodization.
-------------------------------------------------------------------------------------------------- */
closed_orders_reported_in_window AS (
  SELECT c.*
  FROM closed_orders_platform c
  JOIN experts_filtered e
    ON e.expert_id = c.expert_id
  WHERE DATE(c.wage_ts) BETWEEN dt_from AND dt_to
),

/* -------------------------------------------------------------------------------------------------
   9) Period dimension (month + quarter)
   We generate period rows per expert present in the window.
-------------------------------------------------------------------------------------------------- */
expert_period_month AS (
  SELECT DISTINCT
    expert_id,
    'month' AS period_type,
    DATE_TRUNC(DATE(wage_ts), MONTH) AS period_start,
    FORMAT_DATE('%Y-%m', DATE_TRUNC(DATE(wage_ts), MONTH)) AS period_label
  FROM closed_orders_reported_in_window
),
expert_period_quarter AS (
  SELECT DISTINCT
    expert_id,
    'quarter' AS period_type,
    DATE_TRUNC(DATE(wage_ts), QUARTER) AS period_start,
    CONCAT(
      CAST(EXTRACT(YEAR FROM DATE(wage_ts)) AS STRING),
      '-Q',
      CAST(EXTRACT(QUARTER FROM DATE(wage_ts)) AS STRING)
    ) AS period_label
  FROM closed_orders_reported_in_window
),
expert_periods AS (
  SELECT * FROM expert_period_month
  UNION ALL
  SELECT * FROM expert_period_quarter
),

/* -------------------------------------------------------------------------------------------------
   10) Total closed customers per expert-period
   Unique customers with at least one closed order with the expert in the selected period.
-------------------------------------------------------------------------------------------------- */
expert_customer_period_all AS (
  SELECT
    c.expert_id,
    c.customer_id,
    'month' AS period_type,
    DATE_TRUNC(DATE(c.wage_ts), MONTH) AS period_start
  FROM closed_orders_reported_in_window c
  GROUP BY c.expert_id, c.customer_id, period_type, period_start

  UNION ALL

  SELECT
    c.expert_id,
    c.customer_id,
    'quarter' AS period_type,
    DATE_TRUNC(DATE(c.wage_ts), QUARTER) AS period_start
  FROM closed_orders_reported_in_window c
  GROUP BY c.expert_id, c.customer_id, period_type, period_start
),

total_clients_closed AS (
  SELECT
    expert_id,
    period_type,
    period_start,
    COUNT(DISTINCT customer_id) AS total_clients_closed_qty
  FROM expert_customer_period_all
  GROUP BY expert_id, period_type, period_start
),

/* -------------------------------------------------------------------------------------------------
   11) New first-closed customers in period
   Platform-first closed order is attributed strictly to the first expert (no duplication).
-------------------------------------------------------------------------------------------------- */
new_first_closed_in_period AS (
  SELECT
    f.first_expert_id AS expert_id,
    'month' AS period_type,
    DATE_TRUNC(DATE(f.first_closed_ts), MONTH) AS period_start,
    COUNT(DISTINCT f.customer_id) AS new_first_closed_clients_qty
  FROM first_closed_platform f
  JOIN experts_filtered e
    ON e.expert_id = f.first_expert_id
  WHERE DATE(f.first_closed_ts) BETWEEN dt_from AND dt_to
  GROUP BY expert_id, period_type, period_start

  UNION ALL

  SELECT
    f.first_expert_id AS expert_id,
    'quarter' AS period_type,
    DATE_TRUNC(DATE(f.first_closed_ts), QUARTER) AS period_start,
    COUNT(DISTINCT f.customer_id) AS new_first_closed_clients_qty
  FROM first_closed_platform f
  JOIN experts_filtered e
    ON e.expert_id = f.first_expert_id
  WHERE DATE(f.first_closed_ts) BETWEEN dt_from AND dt_to
  GROUP BY expert_id, period_type, period_start
),

/* -------------------------------------------------------------------------------------------------
   12) Returning customers (STRICT)
   Returning = second closed order occurs in the period AND it is with the same expert as the first.
-------------------------------------------------------------------------------------------------- */
returning_metrics AS (
  SELECT
    f.first_expert_id AS expert_id,
    x.period_type,
    x.period_start,
    COUNT(DISTINCT x.customer_id) AS returning_clients_qty
  FROM (
    SELECT
      s.customer_id,
      s.second_expert_id,
      'month' AS period_type,
      DATE_TRUNC(DATE(s.second_closed_ts), MONTH) AS period_start
    FROM second_closed_platform s
    WHERE DATE(s.second_closed_ts) BETWEEN dt_from AND dt_to

    UNION ALL

    SELECT
      s.customer_id,
      s.second_expert_id,
      'quarter' AS period_type,
      DATE_TRUNC(DATE(s.second_closed_ts), QUARTER) AS period_start
    FROM second_closed_platform s
    WHERE DATE(s.second_closed_ts) BETWEEN dt_from AND dt_to
  ) x
  JOIN first_closed_platform f
    ON f.customer_id = x.customer_id
   AND f.first_expert_id = x.second_expert_id
  JOIN experts_filtered e
    ON e.expert_id = f.first_expert_id
  GROUP BY expert_id, period_type, period_start
),

/* -------------------------------------------------------------------------------------------------
   13) Retained eligibility (lifetime)
   A retained customer has 3+ closed orders with the same expert over platform history.
-------------------------------------------------------------------------------------------------- */
expert_customer_closed_counts_platform AS (
  SELECT
    expert_id,
    customer_id,
    COUNT(*) AS closed_orders_cnt_with_expert_platform
  FROM closed_orders_platform
  GROUP BY expert_id, customer_id
),

retained_eligible_pairs AS (
  SELECT expert_id, customer_id
  FROM expert_customer_closed_counts_platform
  WHERE closed_orders_cnt_with_expert_platform >= 3
),

/* -------------------------------------------------------------------------------------------------
   14) Retained metrics in period
   For eligible retained pairs, we include ALL their closed orders inside the reporting period.
-------------------------------------------------------------------------------------------------- */
retained_orders_in_window AS (
  SELECT
    c.expert_id,
    c.customer_id,
    c.order_id,
    c.wage_ts,
    c.wage_amount_cents,
    'month' AS period_type,
    DATE_TRUNC(DATE(c.wage_ts), MONTH) AS period_start
  FROM closed_orders_reported_in_window c
  JOIN retained_eligible_pairs r
    ON r.expert_id = c.expert_id
   AND r.customer_id = c.customer_id

  UNION ALL

  SELECT
    c.expert_id,
    c.customer_id,
    c.order_id,
    c.wage_ts,
    c.wage_amount_cents,
    'quarter' AS period_type,
    DATE_TRUNC(DATE(c.wage_ts), QUARTER) AS period_start
  FROM closed_orders_reported_in_window c
  JOIN retained_eligible_pairs r
    ON r.expert_id = c.expert_id
   AND r.customer_id = c.customer_id
),

retained_metrics AS (
  SELECT
    expert_id,
    period_type,
    period_start,
    COUNT(DISTINCT customer_id) AS retained_clients_qty,
    COUNT(DISTINCT order_id) AS orders_closed_qty_retained,
    SUM(wage_amount_cents) AS orders_closed_value_retained_cents
  FROM retained_orders_in_window
  GROUP BY expert_id, period_type, period_start
)

-- -------------------------------------------------------------------------------------------------
-- 15) Final output (BI-ready rows)
-- -------------------------------------------------------------------------------------------------
SELECT
  e.expert_id,
  e.expert_full_name,
  e.expert_status,

  p.period_type,
  p.period_start,
  p.period_label,

  IFNULL(tc.total_clients_closed_qty, 0) AS total_clients_closed_qty,
  IFNULL(nw.new_first_closed_clients_qty, 0) AS new_first_closed_clients_qty,

  IFNULL(rm.returning_clients_qty, 0) AS returning_clients_qty,
  CAST(
    ROUND(
      SAFE_DIVIDE(
        IFNULL(rm.returning_clients_qty, 0),
        NULLIF(IFNULL(nw.new_first_closed_clients_qty, 0), 0)
      ),
      4
    ) AS FLOAT64
  ) AS returning_client_rate,

  IFNULL(rt.retained_clients_qty, 0) AS retained_clients_qty,
  CAST(
    ROUND(
      SAFE_DIVIDE(
        IFNULL(rt.retained_clients_qty, 0),
        NULLIF(IFNULL(tc.total_clients_closed_qty, 0), 0)
      ),
      4
    ) AS FLOAT64
  ) AS retained_client_rate,

  IFNULL(rt.orders_closed_qty_retained, 0) AS orders_closed_qty_retained,
  -- Convert cents to currency units
  CAST(ROUND(IFNULL(rt.orders_closed_value_retained_cents, 0) / 100, 2) AS FLOAT64) AS orders_closed_value_retained,

  CAST(
    ROUND(
      SAFE_DIVIDE(
        (IFNULL(rt.orders_closed_value_retained_cents, 0) / 100),
        NULLIF(IFNULL(rt.retained_clients_qty, 0), 0)
      ),
      4
    ) AS FLOAT64
  ) AS arpu_closed_retained

FROM expert_periods p
JOIN experts_filtered e
  ON e.expert_id = p.expert_id

LEFT JOIN total_clients_closed tc
  ON tc.expert_id = p.expert_id
 AND tc.period_type = p.period_type
 AND tc.period_start = p.period_start

LEFT JOIN new_first_closed_in_period nw
  ON nw.expert_id = p.expert_id
 AND nw.period_type = p.period_type
 AND nw.period_start = p.period_start

LEFT JOIN returning_metrics rm
  ON rm.expert_id = p.expert_id
 AND rm.period_type = p.period_type
 AND rm.period_start = p.period_start

LEFT JOIN retained_metrics rt
  ON rt.expert_id = p.expert_id
 AND rt.period_type = p.period_type
 AND rt.period_start = p.period_start
;
