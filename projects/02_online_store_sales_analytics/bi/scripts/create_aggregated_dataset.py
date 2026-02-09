#!/usr/bin/env python3
"""
Create Aggregated Dataset for Tableau BI Dashboard
===================================================

Purpose:
    Pre-aggregate session-level data to daily grain for faster Tableau performance.
    This script reduces 349K rows to ~10K rows while preserving all dimensions.

Input:
    data/processed/analytics_master_enriched.csv (349,545 rows)

Output:
    data/processed/analytics_master_aggregated.csv (~10,000 rows)

Aggregation Logic:
    1 row = 1 date + 1 dimension combination (continent, country, device, channel, category, user_type)

Metrics:
    - sessions: COUNT(DISTINCT ga_session_id)
    - orders: COUNT(DISTINCT ga_session_id WHERE has_purchase = True)
    - revenue: SUM(revenue)
    - avg_product_price: AVG(product_price WHERE has_purchase = True)

Author: Data Analyst
Date: 2026-01-28
"""

import pandas as pd
import numpy as np
from pathlib import Path
import sys

# Configuration
INPUT_FILE = Path("data/processed/analytics_master_enriched.csv")
OUTPUT_FILE = Path("data/processed/analytics_master_aggregated.csv")

def main():
    """Main execution function"""

    print("="*80)
    print("TABLEAU AGGREGATED DATASET GENERATOR")
    print("="*80)

    # 1. Load data
    print("\n[1/5] Loading source data...")
    try:
        df = pd.read_csv(INPUT_FILE, parse_dates=['order_date'])
        print(f"✓ Loaded {len(df):,} rows from {INPUT_FILE}")
    except FileNotFoundError:
        print(f"✗ ERROR: File not found: {INPUT_FILE}")
        print(f"  Current working directory: {Path.cwd()}")
        sys.exit(1)

    # 2. Data validation
    print("\n[2/5] Validating data...")
    print(f"  - Date range: {df['order_date'].min()} to {df['order_date'].max()}")
    print(f"  - Total sessions: {df['ga_session_id'].nunique():,}")
    print(f"  - Purchase sessions: {df[df['has_purchase']==True]['ga_session_id'].nunique():,}")
    print(f"  - Total revenue: ${df[df['has_purchase']==True]['revenue'].sum():,.2f}")

    # 3. Create user type dimension
    print("\n[3/5] Creating derived dimensions...")
    df['user_type'] = df['user_id'].apply(
        lambda x: 'Registered' if pd.notna(x) and str(x).strip() != '' else 'Unregistered'
    )
    print(f"✓ Created user_type dimension")
    print(f"  - Registered: {(df['user_type']=='Registered').sum():,} sessions")
    print(f"  - Unregistered: {(df['user_type']=='Unregistered').sum():,} sessions")

    # 4. Aggregate by multiple dimensions
    print("\n[4/5] Aggregating data...")

    # Define aggregation groups
    group_cols = [
        'order_date',
        'continent',
        'country',
        'device',
        'traffic_channel',
        'product_category',
        'user_type'
    ]

    # Aggregation function
    def aggregate_metrics(group):
        """Custom aggregation function for each group"""

        # All sessions
        total_sessions = group['ga_session_id'].nunique()

        # Purchase sessions only
        purchase_data = group[group['has_purchase'] == True]
        orders = purchase_data['ga_session_id'].nunique()
        revenue = purchase_data['revenue'].sum()

        # Calculate metrics
        conversion_rate = (orders / total_sessions * 100) if total_sessions > 0 else 0
        aov = (revenue / orders) if orders > 0 else 0
        avg_product_price = purchase_data['product_price'].mean() if len(purchase_data) > 0 else 0

        return pd.Series({
            'sessions': total_sessions,
            'orders': orders,
            'revenue': revenue,
            'conversion_rate': conversion_rate,
            'aov': aov,
            'avg_product_price': avg_product_price
        })

    # Perform aggregation
    print(f"  Grouping by: {', '.join(group_cols)}")
    aggregated = df.groupby(group_cols, dropna=False).apply(aggregate_metrics).reset_index()

    print(f"✓ Aggregated to {len(aggregated):,} rows")
    print(f"  Compression ratio: {len(df) / len(aggregated):.1f}x")

    # 5. Add calculated fields
    print("\n[5/5] Adding calculated fields...")

    # Revenue share (global)
    total_revenue = aggregated['revenue'].sum()
    aggregated['revenue_share_pct'] = (aggregated['revenue'] / total_revenue * 100).round(2)

    # Session share (global)
    total_sessions = aggregated['sessions'].sum()
    aggregated['session_share_pct'] = (aggregated['sessions'] / total_sessions * 100).round(2)

    print(f"✓ Added revenue_share_pct and session_share_pct")

    # 6. Data quality checks
    print("\n[DATA QUALITY CHECKS]")
    print(f"  - NULL values:")
    null_counts = aggregated.isnull().sum()
    for col in null_counts[null_counts > 0].index:
        print(f"    • {col}: {null_counts[col]:,} ({null_counts[col]/len(aggregated)*100:.1f}%)")

    print(f"\n  - Revenue validation:")
    original_revenue = df[df['has_purchase']==True]['revenue'].sum()
    aggregated_revenue = aggregated['revenue'].sum()
    revenue_diff = abs(original_revenue - aggregated_revenue)
    print(f"    • Original total: ${original_revenue:,.2f}")
    print(f"    • Aggregated total: ${aggregated_revenue:,.2f}")
    print(f"    • Difference: ${revenue_diff:,.2f}")

    if revenue_diff < 0.01:
        print(f"    ✓ Revenue totals match (within $0.01)")
    else:
        print(f"    ⚠ WARNING: Revenue mismatch detected!")

    # 7. Save aggregated dataset
    print(f"\n[SAVING OUTPUT]")
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    aggregated.to_csv(OUTPUT_FILE, index=False)
    print(f"✓ Saved to: {OUTPUT_FILE}")

    # 8. Summary statistics
    print("\n" + "="*80)
    print("AGGREGATION SUMMARY")
    print("="*80)

    print(f"\nDimensions:")
    for col in group_cols:
        unique_count = aggregated[col].nunique()
        print(f"  • {col}: {unique_count:,} unique values")

    print(f"\nMetrics Summary:")
    print(f"  • Total Sessions: {aggregated['sessions'].sum():,}")
    print(f"  • Total Orders: {aggregated['orders'].sum():,}")
    print(f"  • Total Revenue: ${aggregated['revenue'].sum():,.2f}")
    print(f"  • Avg Conversion Rate: {aggregated['conversion_rate'].mean():.2f}%")
    print(f"  • Avg AOV: ${aggregated['aov'].mean():,.2f}")

    print(f"\nTop 5 Rows (by revenue):")
    top5 = aggregated.nlargest(5, 'revenue')[group_cols + ['revenue', 'orders', 'sessions']]
    print(top5.to_string(index=False))

    print("\n" + "="*80)
    print("✓ AGGREGATION COMPLETE")
    print("="*80)
    print(f"\nNext steps:")
    print(f"  1. Open Tableau Desktop")
    print(f"  2. Connect to: {OUTPUT_FILE}")
    print(f"  3. Build dashboards as per specification")
    print(f"\n  Estimated Tableau load time: ~1-2 seconds (vs 5-10 seconds with raw data)")
    print()

if __name__ == "__main__":
    main()
