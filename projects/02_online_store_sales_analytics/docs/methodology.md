# Statistical Methodology & Analytical Framework
## Sales Analytics Portfolio Project

**Author:** Data Analyst
**Date:** 2026-02-09
**Version:** 2.0

**Tableau Public:** [Sales Analytics Dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)

---

## Table of Contents

1. [Overview](#overview)
2. [Data Structure & Grain](#data-structure--grain)
3. [Data Cleaning & Validation](#data-cleaning--validation)
4. [Descriptive Statistics](#descriptive-statistics)
5. [Hypothesis Testing Framework](#hypothesis-testing-framework)
6. [Statistical Tests Applied](#statistical-tests-applied)
7. [Effect Size Metrics](#effect-size-metrics)
8. [Multiple Comparison Corrections](#multiple-comparison-corrections)
9. [Assumptions & Validation](#assumptions--validation)
10. [Limitations & Caveats](#limitations--caveats)
11. [Interpretation Guidelines](#interpretation-guidelines)
12. [References](#references)

---

## 1. Overview

### 1.1 Research Objectives

This analysis aims to answer **four primary business questions**:

1. **Geographic Analysis:** Which continents and countries drive the most revenue?
2. **Product Analysis:** What are top product categories, and do category preferences differ by geography?
3. **Traffic Analysis:** Which acquisition channels deliver the best performance?
4. **Customer Analysis:** Do registered users (subscribed vs unsubscribed) differ in purchasing behavior?

### 1.2 Analytical Approach

The methodology follows a **hypothesis-driven framework**:

```
Business Question
    ↓
Formulate Hypothesis (H₀ vs H₁)
    ↓
Select Statistical Test
    ↓
Check Assumptions
    ↓
Execute Test
    ↓
Calculate Effect Size
    ↓
Interpret Results (p-value + effect size)
    ↓
Business Recommendation
```

### 1.3 Statistical Philosophy

**Key Principles:**

- **P-values alone are insufficient** → Always report effect sizes
- **Statistical significance ≠ practical significance** → Focus on business impact
- **Multiple comparisons require correction** → Use Bonferroni or Holm methods
- **Assumptions must be validated** → Use non-parametric tests when assumptions fail
- **Transparency over complexity** → Document all decisions and limitations

---

## 2. Data Structure & Grain

### 2.1 Dataset Granularity

**Original Dataset:**
- **Grain:** 1 row = 1 session × 1 product line
- **Rows:** 349,545
- **Time Period:** 2020-11-01 to 2021-01-31 (3 months)

**Critical Constraint:**
- Multiple rows can share the same `ga_session_id` if a session has multiple products
- In this dataset, **most sessions have exactly 1 product** (single-item purchases)
- This means `COUNT(product_lines) ≈ COUNT(purchase_sessions)`

**Implication:**
- "Orders" metric = Purchase sessions (proxy)
- "AOV" = Average item price (not basket value)
- True basket-level analysis requires session-level aggregation first

### 2.2 Key Metrics Definitions

| Metric | Definition | Formula | Notes |
|--------|------------|---------|-------|
| **Sessions** | Unique session IDs | `COUNT(DISTINCT ga_session_id)` | All sessions (purchase + non-purchase) |
| **Orders (proxy)** | Purchase sessions | `COUNT(DISTINCT ga_session_id WHERE has_purchase = True)` | Proxy for orders |
| **Revenue** | Total sales | `SUM(revenue WHERE has_purchase = True)` | USD |
| **Conversion Rate (proxy)** | Purchase rate | `Orders / Sessions × 100` | Proxy due to data structure |
| **AOV (proxy)** | Average order value | `Revenue / Orders` | Actually avg item price |

---

## 3. Data Cleaning & Validation

### 3.1 Missing Values

**Approach:**
- **Categorical:** `(not set)`, `<Other>`, `(data deleted)` treated as separate categories (not NULL)
- **Numeric:** `product_price`, `revenue` have no NULLs (validated)
- **User attributes:** `user_id` empty for unregistered users (by design)

**Actions:**
- No imputation performed (preserves data integrity)
- Missing categories indicate **data quality issues** (attribution gaps)

### 3.2 Outliers

**Detection Method:**
- IQR method: `Q1 - 1.5×IQR` to `Q3 + 1.5×IQR`
- Z-score method: `|z| > 3`

**Decision:**
- **Revenue outliers:** Retained (high-value purchases are legitimate)
- **Product price outliers:** Validated against business logic (premium furniture)

**Rationale:**
- E-commerce has natural high variance (sofas $2,000+ vs chairs $100)
- Outliers represent real customer behavior, not errors

### 3.3 Data Validation Checks

| Check | Result | Action |
|-------|--------|--------|
| Date range continuity | ✓ No gaps | None |
| Revenue = Price × Quantity | ✓ Matches | None |
| Sessions ≥ Orders | ✓ Always true | None |
| Negative values | ✗ None found | None |
| Duplicate session IDs | ✓ Expected (multi-item) | Documented |

---

## 4. Descriptive Statistics

### 4.1 Measures of Central Tendency

**Revenue Distribution:**
- **Mean:** $953 (AOV proxy)
- **Median:** $609
- **Mode:** $149 (bar stool - frequent purchase)

**Interpretation:**
- Mean > Median → **Right-skewed distribution** (expected for sales data)
- High-value items (sofas, beds) pull mean upward
- Most purchases are mid-range furniture ($500-$1,000)

### 4.2 Measures of Dispersion

**Revenue Variability:**
- **Standard Deviation:** $823
- **Coefficient of Variation:** 86% (high variability)
- **Range:** $49 - $3,999

**Interpretation:**
- High CV indicates **diverse product portfolio**
- Price points span 80x (children's furniture to premium sofas)

### 4.3 Distribution Shape

**Tests Applied:**
- **Shapiro-Wilk test:** p < 0.001 → Reject normality
- **Anderson-Darling test:** Statistic = 452.3 → Non-normal
- **Q-Q Plot:** Heavy right tail

**Conclusion:**
- Revenue is **not normally distributed** → Use non-parametric tests

---

## 5. Hypothesis Testing Framework

### 5.1 General Framework

For each business question:

1. **Null Hypothesis (H₀):** No difference/relationship exists
2. **Alternative Hypothesis (H₁):** Difference/relationship exists
3. **Significance Level (α):** 0.05 (95% confidence)
4. **Decision Rule:** Reject H₀ if p-value < α

### 5.2 Test Selection Criteria

```
START
  ↓
Is data normally distributed?
  ├─ Yes → Parametric test (t-test, ANOVA)
  └─ No → Non-parametric test (Mann-Whitney, Kruskal-Wallis)
        ↓
Is variance homogeneous?
  ├─ Yes → Use standard test
  └─ No → Use Welch's correction
        ↓
Are there multiple comparisons?
  ├─ Yes → Apply Bonferroni correction
  └─ No → Use standard α = 0.05
        ↓
Calculate effect size
  ↓
Interpret results
```

---

## 6. Statistical Tests Applied

### 6.1 Chi-Square Test of Independence

**Purpose:** Test if category mix differs between USA and global markets

**Hypotheses:**
- H₀: Category distribution is independent of market (USA vs Global)
- H₁: Category distribution differs by market

**Test Statistic:**
```
χ² = Σ[(Observed - Expected)² / Expected]
```

**Assumptions:**
1. ✓ Independence of observations
2. ✓ Expected frequency ≥ 5 in all cells
3. ✓ Categorical variables

**Results:**
- χ² = 26.2
- df = 30 (degrees of freedom)
- p-value = 0.9882
- **Decision:** Fail to reject H₀

**Effect Size (Cramér's V):**
```
V = √(χ² / (n × (k-1)))
V = 0.0088 (negligible)
```

**Interpretation:**
- No meaningful difference in category preferences
- USA behaves like global average → Can use global strategy

---

### 6.2 Kruskal-Wallis H-Test

**Purpose:** Compare sessions across traffic channels

**Hypotheses:**
- H₀: Session distributions are equal across all channels
- H₁: At least one channel differs

**Test Statistic:**
```
H = (12 / (N(N+1))) × Σ(R²ᵢ / nᵢ) - 3(N+1)
```
Where:
- N = total sample size
- nᵢ = sample size for group i
- Rᵢ = sum of ranks for group i

**Assumptions:**
1. ✓ Independent observations
2. ✓ Ordinal or continuous dependent variable
3. ✓ Similar distribution shapes (checked via histograms)

**Results:**
- H = 368.98
- df = 4 (5 channels - 1)
- p-value = 1.40 × 10⁻⁷⁸
- **Decision:** Reject H₀

**Interpretation:**
- **Channels differ significantly**
- Post-hoc tests required to identify which pairs differ

---

### 6.3 Mann-Whitney U Test (Wilcoxon Rank-Sum)

**Purpose:** Compare revenue distributions between subscribed vs unsubscribed users

**Hypotheses:**
- H₀: Revenue distributions are equal for both groups
- H₁: Revenue distributions differ

**Test Statistic:**
```
U = n₁n₂ + (n₁(n₁+1))/2 - R₁
```
Where:
- n₁, n₂ = sample sizes
- R₁ = sum of ranks for group 1

**Assumptions:**
1. ✓ Independent observations
2. ✓ Ordinal or continuous dependent variable
3. ✗ Normal distribution NOT required

**Results:**
- U = 4,523,890
- p-value = 0.23
- **Decision:** Fail to reject H₀

**Effect Size (Cliff's Delta):**
```
δ = (n₊ - n₋) / (n₁ × n₂)
δ = 0.01 (negligible)
```

**Interpretation:**
- No meaningful difference in revenue
- **Email subscription status does not predict purchasing**

---

### 6.4 Kolmogorov-Smirnov Test

**Purpose:** Test if registered vs unregistered users have different revenue distributions

**Hypotheses:**
- H₀: Both groups have same distribution
- H₁: Distributions differ

**Test Statistic:**
```
D = max|F₁(x) - F₂(x)|
```
Where:
- F₁, F₂ = cumulative distribution functions

**Results:**
- D = 1.0 (maximum possible value)
- p-value < 0.001
- **Decision:** Reject H₀

**Interpretation:**
- **Complete separation** of distributions
- Registered and unregistered users are **fundamentally different segments**
- 90% of registered users have zero revenue (anomaly)

---

## 7. Effect Size Metrics

### 7.1 Why Effect Sizes Matter

**Problem with p-values alone:**
- Large samples → even tiny differences become "significant"
- p-value measures "confidence" not "importance"
- Business needs practical significance, not just statistical significance

**Solution:**
- **Always report effect sizes** alongside p-values
- Effect size measures **magnitude of difference**

### 7.2 Effect Size Interpretation Guidelines

#### Cramér's V (for Chi-Square)
```
V = 0.00 - 0.10  →  Negligible
V = 0.10 - 0.30  →  Small
V = 0.30 - 0.50  →  Medium
V ≥ 0.50         →  Large
```

**Example:**
- USA vs Global category mix: V = 0.0088 → **Negligible**

#### Cliff's Delta (for Mann-Whitney U)
```
|δ| = 0.00 - 0.15  →  Negligible
|δ| = 0.15 - 0.33  →  Small
|δ| = 0.33 - 0.47  →  Medium
|δ| ≥ 0.47          →  Large
```

**Example:**
- Subscribed vs Unsubscribed: δ = 0.01 → **Negligible**

---

## 8. Multiple Comparison Corrections

### 8.1 Problem: Inflated Type I Error

**Scenario:**
- Testing 10 hypotheses at α = 0.05
- Probability of at least one false positive: `1 - (0.95)¹⁰ = 40%`

**Solution:**
- Apply **multiple comparison correction**

### 8.2 Bonferroni Correction

**Method:**
```
α_adjusted = α / m
```
Where m = number of comparisons

**Example:**
- Post-hoc tests for 5 channels: `C(5,2) = 10 pairwise comparisons`
- α_adjusted = 0.05 / 10 = **0.005**

**Pros:**
- Simple, conservative
- Controls family-wise error rate (FWER)

**Cons:**
- Very conservative (increases Type II error)

### 8.3 Holm-Bonferroni Method (Less Conservative)

**Method:**
1. Order p-values: p₁ ≤ p₂ ≤ ... ≤ pₘ
2. Test each against: α / (m + 1 - i)
3. Stop at first failure to reject

**Example:**
- p₁ = 0.001 vs α/10 = 0.005 → Reject H₀
- p₂ = 0.003 vs α/9 = 0.0056 → Reject H₀
- p₃ = 0.008 vs α/8 = 0.0063 → Fail to reject (stop)

**Decision:**
- First 2 comparisons are significant

---

## 9. Assumptions & Validation

### 9.1 Independence

**Requirement:** Observations must be independent

**Validation:**
- ✓ Each session is unique (different users/times)
- ✗ Same user can have multiple sessions (minor violation)

**Mitigation:**
- For user-level analysis, aggregate by `user_id` first

### 9.2 Normality

**Requirement:** Data follows normal distribution (for parametric tests)

**Validation Methods:**

1. **Shapiro-Wilk Test:**
   - H₀: Data is normally distributed
   - Results: p < 0.001 → **Reject** (not normal)

2. **Q-Q Plot:**
   - Visual inspection of quantile-quantile plot
   - Revenue: Heavy right tail → **Not normal**

3. **Skewness & Kurtosis:**
   - Skewness = 2.1 (right-skewed)
   - Kurtosis = 8.3 (heavy tails)

**Decision:**
- **Use non-parametric tests** (Mann-Whitney, Kruskal-Wallis)

### 9.3 Homogeneity of Variance

**Requirement:** Equal variances across groups (for ANOVA, t-tests)

**Validation:**
- **Levene's Test:** p = 0.002 → Variances differ

**Decision:**
- Confirm need for non-parametric approach

---

## 10. Limitations & Caveats

### 10.1 Data Structure Limitations

**Issue 1: Order Definition**
- Dataset has 1 row per product line, not per order
- "Orders" metric = product lines = sessions (in this dataset)
- **Implication:** Cannot analyze basket composition or multi-item orders

**Issue 2: Order Date Proxy**
- `order_date` is proxied by `session.date`
- No actual order timestamp available
- **Implication:** Multi-day purchase journeys not captured

### 10.2 Attribution Quality

**Issue 3: High "Undefined" Share**
- 6.3% revenue has Undefined channel
- 6.3% revenue from "(data deleted)" sources
- **Implication:** Channel comparisons are directional, not absolute

**Issue 4: Conversion Rate Artifact**
- Conversion rate is identical across channels (~9.6%)
- This is an artifact of the data structure (1 product line per session)
- **Implication:** Cannot compare channel conversion rates accurately

### 10.3 Time Period

**Issue 5: Limited Time Window**
- Only 3 months of data (Nov 2020 - Jan 2021)
- Includes holiday season (Black Friday, Cyber Monday, Christmas)
- **Implication:** Seasonality effects may skew patterns

### 10.4 Sample Size Considerations

**Issue 6: Unbalanced Groups**
- Unregistered: 321,600 sessions (92%)
- Registered: 27,945 sessions (8%)
- **Implication:** Statistical power differs across segments

---

## 11. Interpretation Guidelines

### 11.1 p-value Interpretation

**What p-value means:**
- Probability of observing data this extreme **if H₀ is true**
- NOT the probability that H₀ is true

**Interpretation Scale:**
```
p < 0.001  →  Very strong evidence against H₀
p < 0.01   →  Strong evidence against H₀
p < 0.05   →  Moderate evidence against H₀
p ≥ 0.05   →  Insufficient evidence to reject H₀
```

**Common Mistakes:**
- ✗ "p = 0.04 → Significant, p = 0.06 → Not significant" (arbitrary threshold)
- ✓ "p = 0.04 → Weak evidence, p = 0.001 → Very strong evidence"

### 11.2 Statistical vs Practical Significance

**Example:**
- Channel A: Mean revenue $1,000
- Channel B: Mean revenue $1,005
- p-value = 0.001 (statistically significant)
- Effect size = 0.5% difference

**Interpretation:**
- **Statistically significant** (p < 0.05) → Real difference exists
- **Not practically significant** (0.5% difference) → Business impact minimal

**Decision:**
- Do not reallocate budget based on this finding

### 11.3 Reporting Standards

**Minimum Required:**
1. Test name
2. Test statistic value
3. p-value
4. Effect size
5. Sample sizes
6. Decision (reject/fail to reject H₀)
7. Business interpretation

**Example:**
```
Mann-Whitney U test comparing revenue for subscribed vs unsubscribed users:
- U = 4,523,890
- p = 0.23
- Cliff's δ = 0.01 (negligible effect)
- n₁ = 18,943 (subscribed), n₂ = 9,002 (unsubscribed)
- Decision: Fail to reject H₀
- Interpretation: No meaningful difference in revenue between groups.
  Email subscription status does not predict purchasing behavior.
```

---

## 12. References

### Statistical Methods
- **Mann-Whitney U Test:** Wilcoxon, F. (1945). Individual comparisons by ranking methods.
- **Kruskal-Wallis Test:** Kruskal, W. H., & Wallis, W. A. (1952). Use of ranks in one-criterion variance analysis.
- **Kolmogorov-Smirnov Test:** Kolmogorov, A. (1933). Sulla determinazione empirica di una legge di distribuzione.

### Effect Sizes
- **Cramér's V:** Cramér, H. (1946). Mathematical Methods of Statistics.
- **Cliff's Delta:** Cliff, N. (1993). Dominance statistics: Ordinal analyses to answer ordinal questions.

### Multiple Comparisons
- **Bonferroni Correction:** Dunn, O. J. (1961). Multiple comparisons among means.
- **Holm Method:** Holm, S. (1979). A simple sequentially rejective multiple test procedure.

### Books
- **Applied Statistics:** Cohen, J. (1988). Statistical Power Analysis for the Behavioral Sciences.
- **Nonparametric Statistics:** Hollander, M., & Wolfe, D. A. (1999). Nonparametric Statistical Methods.

### Software
- **Python:** pandas, numpy, scipy.stats, statsmodels
- **Jupyter Notebook:** Interactive analysis environment

---

**Document Version:** 2.0
**Last Updated:** 2026-02-09
**Author:** Data Analyst
**Project:** Sales Analytics Portfolio
**Tableau Public:** [Live Dashboard](https://public.tableau.com/app/profile/roman.fin/viz/SalesAnalyticProject/EXECUTIVEMONITOR)

---
