---

## 📋 Business Use Cases

| Report | Business Question | Rows |
|--------|------------------|------|
| rpt_revenue_analysis | Revenue by region, segment, date | 52M |
| rpt_customer_analysis | Customer lifetime value, segments | 100M |
| rpt_delivery_performance | On-time delivery rate by supplier | 5.9B |
| rpt_return_analysis | Return rate by product, supplier | 5.9B |
| rpt_supplier_performance | Supplier scorecard | 10M |
| rpt_product_analysis | Product profitability | 200M |

---

## 🔑 Key KPIs

**Revenue:**
- Net Revenue = extended_price × (1 - discount)
- Gross Revenue = net_revenue × (1 + tax)
- Profit Margin = net_revenue - supply_cost
- Average Order Value = revenue / order count

**Operations:**
- On-Time Delivery Rate
- Average Days Late
- Return Rate
- Revenue Lost to Returns

**Customer:**
- Customer Lifetime Value
- Customer Tenure Days
- Customer Value Segment (Platinum/Gold/Silver/Bronze)

---

## 🧪 Data Quality

**84 tests total — all passing:**
- 48 staging tests
- 36 marts core tests
- 3 custom singular tests

**Test types:**
- `unique` — no duplicate primary keys
- `not_null` — no missing critical values
- `accepted_values` — valid status codes
- `relationships` — referential integrity
- Custom: positive revenue, valid dates, discount range

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| dbt Core 1.8 | Data transformation |
| Snowflake | Cloud data warehouse |
| GitHub Actions | CI/CD pipeline |
| Python 3.11 | Environment |

---

## 🚀 How to Run

**1. Clone the repo**
```bash
git clone https://github.com/vaibs21787/commerce_analytics.git
cd commerce_analytics
```

**2. Set up environment**
```bash
conda create -n dbt-env python=3.11 pip -y
conda activate dbt-env
pip install -r requirements.txt
```

**3. Configure Snowflake connection**
```bash
# Edit ~/.dbt/profiles.yml with your credentials
# Run Snowflake setup script first:
# setup/snowflake_setup.sql
```

**4. Run the project**
```bash
dbt seed          # Load reference data
dbt run           # Build all models
dbt test          # Run all 84 tests
dbt docs generate # Generate documentation
dbt docs serve    # View lineage graph
```

---

## 📁 Snowflake Setup

Run `setup/snowflake_setup.sql` as ACCOUNTADMIN to create:
- Role: `dbt_role`
- Warehouse: `dbt_wh`
- Database: `commerce_analytics`
- Schemas: `raw`, `staging`, `intermediate`, `marts`, `reporting`

---

## 👩‍💻 Author

**Vaibhavi Shah**
Analytics Engineer
[GitHub](https://github.com/vaibs21787)