# Statistical Significance Methodology

## Method: Two-Proportion Z-Test

### Overview

We use a **two-proportion Z-test** (two-tailed) to determine whether the difference in conversion rates between the Control group (group 1) and the Test group (group 2) is statistically significant.

This test is appropriate when:
- Comparing two independent proportions (conversion rates)
- Sample sizes are sufficiently large (np > 5 and n(1-p) > 5)
- Observations are independent

### Metrics Analyzed

Each metric is defined as a ratio of events to sessions:

| Metric | Numerator Event | Denominator |
|--------|----------------|-------------|
| `add_payment_info / session` | add_payment_info | session |
| `add_shipping_info / session` | add_shipping_info | session |
| `begin_checkout / session` | begin_checkout | session |
| `new_accounts / session` | new account | session |

### Formulas

**Step 1: Conversion Rates**

$$\hat{p}_1 = \frac{X_1}{n_1}, \quad \hat{p}_2 = \frac{X_2}{n_2}$$

Where:
- $X_1$, $X_2$ — number of events (numerator) in control and test groups
- $n_1$, $n_2$ — number of sessions (denominator) in control and test groups

**Step 2: Pooled Proportion**

$$\hat{p}_{pool} = \frac{X_1 + X_2}{n_1 + n_2}$$

**Step 3: Standard Error**

$$SE = \sqrt{\hat{p}_{pool}(1 - \hat{p}_{pool})\left(\frac{1}{n_1} + \frac{1}{n_2}\right)}$$

**Step 4: Z-Statistic**

$$Z = \frac{\hat{p}_2 - \hat{p}_1}{SE}$$

**Step 5: P-Value**

Two-tailed p-value from the standard normal distribution:

$$p\text{-value} = 2 \times (1 - \Phi(|Z|))$$

### Decision Rule

- **Significance level:** $\alpha = 0.05$
- If $p\text{-value} < 0.05$ → **Statistically Significant** (the difference is real)
- If $p\text{-value} \geq 0.05$ → **Not Significant** (the difference could be due to chance)

### Metric Change Calculation

$$\text{Metric Change \%} = \frac{CR_{test} - CR_{control}}{CR_{control}} \times 100$$

### Dimensions

Significance is calculated at multiple levels:
- **Total** — overall per test (primary analysis)
- **By Device** — desktop, mobile, tablet
- **By Continent** — Europe, Asia, Americas, Africa, Oceania
- **By Channel** — Direct, Organic Search, Paid Search, Social Search, Undefined

### Implementation Notes

- The Python implementation uses `math.erfc` for the normal CDF calculation, avoiding external dependencies (no scipy required)
- Metrics are defined in a dictionary — adding new metrics requires only one line of configuration
- All calculations use loops and arrays — no hardcoded metric count
- Edge cases handled: zero denominators, zero standard error, pooled proportion at boundaries
