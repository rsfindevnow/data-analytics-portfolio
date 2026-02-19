# A/B Test Results — Interpretation & Conclusions

## Total Results Overview (4 Tests x 4 Metrics = 16 Checks)

### Test 1

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| **add_payment_info / session** | **4.38%** | **4.93%** | **+12.5%** | **0.000** | **Yes** |
| **add_shipping_info / session** | **6.69%** | **7.13%** | **+6.6%** | **0.009** | **Yes** |
| **begin_checkout / session** | **8.34%** | **8.90%** | **+6.7%** | **0.003** | **Yes** |
| new_accounts / session | 8.43% | 8.15% | -3.4% | 0.123 | No |

The test variant significantly **increased** 3 out of 4 metrics. Payment info, shipping info,
and checkout initiation rates all improved. Only new account creation showed no statistically confirmed change.

### Test 2

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| add_payment_info / session | 4.63% | 4.79% | +3.6% | 0.215 | No |
| add_shipping_info / session | 6.87% | 6.99% | +1.7% | 0.478 | No |
| begin_checkout / session | 8.42% | 8.58% | +2.0% | 0.341 | No |
| new_accounts / session | 8.23% | 8.33% | +1.2% | 0.556 | No |

None of the 4 metrics reached statistical significance. All observed differences are within the range
of random variation — the test had no measurable effect on user behavior.

### Test 3

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| add_payment_info / session | 5.17% | 5.25% | +1.5% | 0.520 | No |
| add_shipping_info / session | 7.56% | 7.37% | -2.6% | 0.157 | No |
| **begin_checkout / session** | **13.61%** | **13.15%** | **-3.4%** | **0.012** | **Yes** |
| new_accounts / session | 8.36% | 8.27% | -1.1% | 0.520 | No |

The test variant significantly **decreased** the begin_checkout rate by 3.4%.
This is a negative outcome — the change reduced checkout initiation without any compensating improvements elsewhere.

### Test 4

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| add_payment_info / session | 3.55% | 3.42% | -3.5% | 0.116 | No |
| add_shipping_info / session | 4.88% | 4.71% | -3.4% | 0.074 | No |
| **begin_checkout / session** | **11.95%** | **11.67%** | **-2.4%** | **0.046** | **Yes** |
| **new_accounts / session** | **8.55%** | **8.26%** | **-3.4%** | **0.018** | **Yes** |

The test variant significantly **decreased** checkout initiation and new account creation.
The changes negatively impacted top-of-funnel metrics.

## Significance Distribution by Dimension

| Dimension | Significant | Total | Rate |
|-----------|------------|-------|------|
| Total | 6 | 16 | **37.5%** |
| Device | 17 | 48 | 35.4% |
| Continent | 28 | 96 | 29.2% |
| Channel | 32 | 80 | **40.0%** |

~30–40% of all checks show statistical significance — this confirms that
the test variants produced **real, measurable changes** in user behavior,
not random noise.

Higher significance rate at **Channel level** (40.0%) suggests that
the effects of test variants vary meaningfully by traffic source.

## Business Conclusions & Recommendations

### 1. Implement Test 1 — Clear Winner
- Three key funnel stages improved significantly: payment (+12.5%), shipping (+6.6%), checkout (+6.7%)
- No negative effects on any other metric
- **Action:** Roll out Test 1 changes to 100% of traffic immediately

### 2. Reject Test 3 — Negative Impact
- Checkout initiation declined by 3.4% — the only significant result
- No compensating improvements elsewhere
- **Action:** Do not implement; investigate what caused the checkout step decline

### 3. Reject Test 4 — Negative Impact
- Significant damage to checkout initiation (−2.4%) and new account creation (−3.4%)
- Both are important top-of-funnel metrics
- **Action:** Ensure Test 4 changes are fully reverted

### 4. No Action on Test 2 — No Effect Detected
- Zero metrics reached statistical significance
- All observed differences are within random variation
- **Action:** No implementation decision possible; consider re-running with a refined hypothesis

### 5. Leverage Dimensional Insights
- 40.0% significance at channel level suggests **channel-specific effects** —
  the impact of test changes varies by traffic source (paid vs organic vs direct)
- 35.4% significance at device level may warrant **separate mobile vs desktop strategies**
  before rolling out Test 1
