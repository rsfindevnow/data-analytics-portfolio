# A/B Test Results — Interpretation & Conclusions

## Total Results Overview (4 Tests x 4 Metrics = 16 Checks)

### Test 1

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| add_payment_info / session | 5.73% | 6.18% | +7.7% | 0.601 | No |
| add_shipping_info / session | 8.83% | 7.30% | -17.3% | 0.115 | No |
| **begin_checkout / session** | **7.73%** | **9.86%** | **+27.5%** | **0.035** | **Yes** |
| new_accounts / session | 9.02% | 8.67% | -3.9% | 0.730 | No |

The test variant significantly **increased** the begin_checkout rate by 27.5%.
Other metrics showed no statistically confirmed changes.

### Test 2

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| add_payment_info / session | 5.03% | 3.96% | -21.3% | 0.125 | No |
| **add_shipping_info / session** | **8.68%** | **6.70%** | **-22.9%** | **0.027** | **Yes** |
| begin_checkout / session | 9.79% | 10.25% | +4.7% | 0.649 | No |
| new_accounts / session | 7.91% | 8.04% | +1.6% | 0.888 | No |

The test variant significantly **decreased** the add_shipping_info rate by 22.9%.
This is a negative outcome — the changes worsened the conversion funnel.

### Test 3

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| **add_payment_info / session** | **5.24%** | **6.89%** | **+31.6%** | **0.016** | **Yes** |
| add_shipping_info / session | 6.03% | 6.36% | +5.5% | 0.632 | No |
| **begin_checkout / session** | **12.19%** | **15.48%** | **+27.0%** | **0.001** | **Yes** |
| new_accounts / session | 6.62% | 7.70% | +16.4% | 0.144 | No |

The most successful test — **2 out of 4 metrics improved significantly**.
Begin_checkout grew by +27% and add_payment_info by +31.6%.
The changes positively impacted the conversion funnel.

### Test 4

| Metric | CR Control | CR Test | Change | p-value | Significant |
|--------|-----------|---------|--------|---------|-------------|
| **add_payment_info / session** | **4.53%** | **2.87%** | **-36.6%** | **0.000** | **Yes** |
| **add_shipping_info / session** | **5.94%** | **4.31%** | **-27.4%** | **0.002** | **Yes** |
| begin_checkout / session | 10.91% | 9.86% | -9.6% | 0.145 | No |
| new_accounts / session | 8.46% | 8.07% | -4.7% | 0.541 | No |

The worst-performing test — **2 metrics dropped significantly**.
The changes severely damaged the payment stages of the funnel.

## Significance Distribution by Dimension

| Dimension | Significant | Total | Rate |
|-----------|------------|-------|------|
| Total | 6 | 16 | **37.5%** |
| Device | 15 | 48 | 31.2% |
| Continent | 31 | 96 | 32.3% |
| Channel | 23 | 80 | **28.7%** |

~30-37% of all checks show statistical significance — this confirms that
the test variants produced **real, measurable changes** in user behavior,
not random noise.

## Business Conclusions & Recommendations

### 1. Implement Test 3 — Clear Winner
- Two key funnel metrics improved significantly (+27% checkout, +32% payment)
- No negative effects on other metrics
- **Action:** Roll out Test 3 changes to 100% of traffic immediately

### 2. Reject Test 4 — Clear Loser
- Significant damage to payment (-36.6%) and shipping (-27.4%) stages
- These are critical revenue-impacting steps in the funnel
- **Action:** Ensure Test 4 changes are fully reverted

### 3. Reject Test 2 — Negative Impact
- Shipping info step dropped by 22.9%
- No compensating positive effects elsewhere
- **Action:** Do not implement; investigate what caused the shipping step decline

### 4. Investigate Test 1 — Mixed Signal
- Checkout improved (+27.5%), but only 1 out of 4 metrics is significant
- The effect is isolated — no downstream improvement in payment or shipping
- **Action:** Run a follow-up test with larger sample size to confirm the effect before making a rollout decision

### 5. Leverage Dimensional Insights
- 31.2% significance at device level suggests **device-specific effects** that may warrant separate mobile vs desktop strategies
- Channel-level analysis (28.7%) can inform **budget allocation** for paid vs organic traffic during future tests
