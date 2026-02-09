/* ============================================================
  DATASET FOR PORTFOLIO PROJECT 1 (from data-analytics-mate.DA)
   Output: for CSV export (Google Drive / BigQuery UI)
   Grain: ga_session_id × item_id (order line within a session)
   IMPORTANT: order_date is proxied by session.date (order table has no date)

   Study environment note:
   We intentionally avoid persistent VIEW objects in a shared training workspace
   to reduce the risk of third-party changes and ensure reproducibility.
   ============================================================ */

WITH
-- 1) Sessions base (keep ALL sessions)
s AS (
  SELECT
    date AS session_date,
    ga_session_id
  FROM `data-analytics-mate.DA.session`
),

-- 2) Session params (may have duplicates per session -> deduplicate)
sp AS (
  SELECT
    ga_session_id,
    ANY_VALUE(continent) AS continent,
    ANY_VALUE(country) AS country,
    ANY_VALUE(device) AS device,
    ANY_VALUE(browser) AS browser,
    ANY_VALUE(mobile_model_name) AS mobile_model_name,
    ANY_VALUE(operating_system) AS operating_system,
    ANY_VALUE(language) AS language,
    ANY_VALUE(name) AS traffic_source_name,
    ANY_VALUE(channel) AS traffic_channel
  FROM `data-analytics-mate.DA.session_params`
  GROUP BY ga_session_id
),

-- 3) Orders (may be multiple items per session)
o AS (
  SELECT
    ga_session_id,
    item_id
  FROM `data-analytics-mate.DA.order`
),

-- 4) Products dictionary
p AS (
  SELECT
    item_id,
    category AS product_category,
    name AS product_name,
    price AS product_price,
    short_description AS product_short_description
  FROM `data-analytics-mate.DA.product`
),

-- 5) Session -> account mapping
sa AS (
  SELECT
    ga_session_id,
    account_id
  FROM `data-analytics-mate.DA.account_session`
),

-- 6) Account attributes
a AS (
  SELECT
    id AS account_id,
    is_verified,
    is_unsubscribed
  FROM `data-analytics-mate.DA.account`
)

SELECT
  -- Time / session
  s.session_date AS order_date,
  s.ga_session_id,

  -- Geo
  sp.continent,
  sp.country,

  -- Device / environment
  sp.device,
  sp.browser,
  sp.operating_system,
  sp.mobile_model_name,
  sp.language,

  -- Traffic (mandatory by task)
  sp.traffic_source_name,
  sp.traffic_channel,

  -- User / email status (NULL for anonymous sessions)
  sa.account_id AS user_id,
  a.is_verified AS email_verified,
  CASE
    WHEN a.is_unsubscribed IS NULL THEN NULL
    WHEN a.is_unsubscribed = 1 THEN 0
    WHEN a.is_unsubscribed = 0 THEN 1
    ELSE NULL
  END AS is_subscribed,

  -- Product (NULL when no purchase)
  p.product_category,
  p.product_name,
  p.product_price,
  p.product_short_description

FROM s
LEFT JOIN sp
  ON sp.ga_session_id = s.ga_session_id
LEFT JOIN o
  ON o.ga_session_id = s.ga_session_id
LEFT JOIN p
  ON p.item_id = o.item_id
LEFT JOIN sa
  ON sa.ga_session_id = s.ga_session_id
LEFT JOIN a
  ON a.account_id = sa.account_id
;
