# F&B Sales Analytics: Coffee Shop Sales Analysis

An analysis of 53,820 POS transactions from three coffee shops in Indonesia between January and September 2025. The project explores where, when, and what drives revenue, investigates the April sales decline, and identifies potential opportunities for business growth.

**Tools:** Python · pandas · NumPy · Matplotlib · Seaborn · Jupyter Notebook

---

## Key Findings

| Area | Insights |
|---|---|
| **Business Overview** | 53,820 transactions, 61,973 items sold, and **~1.32 billion IDR** in revenue (January 2 – September 30, 2025). Average paid transaction: ~25.3K IDR; median: 23K IDR. |
| **Store Performance** | `SHOP001` generates **49%** of total revenue (644M IDR), `SHOP003` 31% (410M IDR), and `SHOP002` 20% (262M IDR). Average transaction values are nearly identical (25.1–25.3K IDR), indicating that the revenue gap is driven primarily by **transaction volume**, not spending per transaction. |
| **Monthly Trends** | Revenue peaked in June (**183M IDR, +37.8%** MoM), while April saw a significant decline (**110M IDR, −27.7%** MoM). Revenue continued to decrease afterward: July −3.5%, August −17.4%, and September −7.3%. |
| **April Decline** | Daily revenue dropped by 60% at `SHOP003` (~1.80M → 0.72M IDR) and 23% at `SHOP002`, while `SHOP001` remained stable. All three stores recorded transactions every day in April, and average transaction values remained stable. This indicates that the decline was driven by **fewer transactions rather than reduced operating days or lower spending per transaction**. |
| **Time Patterns** | The strongest hours are **17:00–22:00** (~7.1–7.5% of daily revenue per hour), while the weakest are **7:00–8:00 AM** (~4.3–4.4%). Differences across weekdays are relatively small. |
| **Product Categories** | Coffee accounts for ~36% of both units sold and revenue. **Menu Gedhe** represents 20.3% of units sold but generates 26.1% of revenue. **Snacks** account for 9.4% of units but only 7.0% of revenue. Add-ons contribute ~1.3%. |
| **Top Products** | The top 10 products generate **34.4%** of total revenue across 68 products. Leading products include Friendly Coffee, WHITE, and Basic Latte. |
| **Loyalty Program** | 1,733 transactions (3.2%) involved free items worth **44.3M IDR** (3.3% of total item value). Free items are most common in Menu Gedhe (3.9%), Other (3.7%), and Coffee (3.3%) categories, while tea accounts for only 0.7%. |
| **Payment Methods** | BCA accounts for 79.5% of transactions and 82.2% of revenue; cash represents 20.3% and 17.6%, respectively. GoFood accounts for only 0.2% (102 transactions). Average paid transaction values are nearly identical across payment methods (25.3K vs. 25.2K IDR). |
| **Basket Analysis** | **84.9%** of transactions contain one item, while 15.1% contain two (1.15 items per transaction on average). Coffee appears in 59% of two-item transactions. The most common category combination is Coffee + Menu Gedhe (14.6%). |

---

## Visualizations

### Monthly Revenue: June Peak and April Decline
![Monthly Revenue](images/01_monthly_revenue.png)

### April Performance by Store: Declines at SHOP003 and SHOP002, SHOP001 Remains Stable
![April Revenue by Store](images/02_april_by_outlet.png)

### Purchase Patterns: Strong Evenings, Weak Mornings, Similar Weekday Trends
![Weekday and Hour Heatmap](images/03_heatmap_weekday_hour.png)

### Product Categories: Menu Gedhe Generates a Higher Revenue Share Than Its Sales Volume
![Revenue by Product Category](images/04_categories.png)

### Top 10 Products by Revenue
![Top 10 Products](images/05_top_products.png)

### What Customers Buy Together
![Product Category Combinations](images/06_category_pairs.png)

All visualizations, detailed tables, and calculations are available in the Jupyter Notebook.

---

## Analysis Workflow

1. **Data Quality Checks:** Identified missing values, duplicate transactions, negative and zero amounts, and validated the reporting period.
2. **Revenue Reconciliation:** Verified that revenue calculated from individual product items matched transaction totals within one rupiah (1,315,276,000 IDR).
3. **Data Preparation:** Split product lists into individual transaction items using `explode` and joined the product catalog.
4. **Exploratory Analysis:** Analyzed KPIs, store performance, monthly revenue trends (MoM), the April decline, weekday and hourly demand patterns, product categories, individual products, loyalty program usage, payment methods, and basket composition.
5. **Business Insights:** Summarized findings and developed actionable business hypotheses.

---

## Business Recommendations & Hypotheses

The following opportunities were identified based on the analysis. Each requires further validation before implementation.

1. **Increase the share of multi-item transactions.** Only 15% of transactions contain a second item. Test product bundles such as coffee + pastry combinations to encourage additional purchases.
2. **Strengthen morning sales (7:00–8:00 AM).** These are the weakest hours across all three stores. Consider testing breakfast deals or morning promotions.
3. **Investigate the April decline at `SHOP002` and `SHOP003`.** Both stores remained operational, but transaction volumes dropped significantly. Potential explanations include nearby construction, holidays, competitors, or promotional changes.
4. **Review loyalty program incentives for tea and add-ons.** Their redemption rates are particularly low, suggesting an opportunity to reassess the current reward structure.
5. **Focus on customer traffic at `SHOP002` and `SHOP003`.** Since average transaction values are already comparable to the leading store, increasing transaction volume may offer greater growth potential.

---

## Limitations

- **No cost data:** The analysis measures revenue, not profit.
- **No customer identifiers:** Repeat purchases, customer retention, and customer-level behavior cannot be analyzed.
- **Limited reporting period:** Only nine months of data are available, making annual seasonality analysis impossible.
- **April decline remains unexplained:** The data identify where and to what extent the decline occurred but do not establish its underlying cause.
- **Zero-value loyalty transactions:** Transactions paid entirely with loyalty rewards have zero recorded amounts, so average transaction value is calculated using paid transactions only.

---

## Dataset

| File | Description |
|---|---|
| `Transactions.csv` | 53,820 POS transactions containing store, date, time, amounts, product lists, item counts, payment methods, and loyalty indicators. |
| `Products.csv` | Product catalog with 96 menu entries (68 unique product names), including category, variant, and price. |

**Currency:** Indonesian Rupiah (IDR).

---

## Repository Structure

```text
├── data/
│   ├── Products.csv
│   └── Transactions.csv
├── notebook/
│   └── notebook.ipynb
├── images/                  # Visualizations used in README
└── README.md
```

## Author

**Dmytro Chuchman**  
Computer Mathematics student at Taras Shevchenko National University of Kyiv.

Email: dmytrochuchman2024@gmail.com
