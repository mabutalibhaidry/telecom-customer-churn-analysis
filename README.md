# 📊 Telecom Customer Churn Analysis

**End-to-end data analytics project** using **SQL**, **Python**, and **Power BI** — from a normalized multi-table database to an interactive, decision-ready retention dashboard.

---

## 🎯 Business Problem

Customer churn is one of the most expensive problems a telecom company faces — acquiring a new customer costs **5–7x more** than retaining an existing one. This project simulates a Data Analyst role on a telecom retention team, answering:

- **Who** is churning?
- **Why** are they churning?
- **Which active customers** are highest-risk right now, and how much revenue is at stake?
- **What** should the business act on first?

## 🗂️ Dataset

A normalized relational database (`telecom_churn`) with **5 related tables** and **~146,000 rows total**, built on top of the IBM Telco Customer Churn dataset and extended with simulated support-ticket and monthly-usage logs for realism.

| `customers` | 7,043 | Demographics, signup date |
| `accounts` | 7,043 | Contract, billing, churn label |
| `services` | 7,043 | Subscribed add-ons |
| `support_tickets` | 10,525 | Support interactions, satisfaction scores |
| `monthly_usage` | 121,127 | Monthly data/call/SMS usage logs |

---

## 🛠️ Workflow

```
MySQL (extraction & exploration)  →  Python/Pandas (cleaning & feature engineering)  →  Power BI (dashboard)
```

### 1️⃣ SQL — Data Exploration & Extraction
- Structural checks: row counts, duplicate keys, NULL audits
- Early insight queries: churn rate by contract type, support ticket patterns
- A master extraction query joining all 5 tables (INNER + LEFT joins, aggregated subqueries, `COALESCE`) into one analysis-ready extract

### 2️⃣ Python — Cleaning & Feature Engineering
- Fixed data types (`signup_date` → datetime)
- Traced each missing-value column to its root cause and handled accordingly (zero-usage vs. genuinely-unknown satisfaction scores, with a `has_support_ticket` flag)
- Engineered dashboard-ready features: `tenure_bucket`, `annual_revenue_at_risk`, `total_addons_subscribed`, `is_churned`

### 3️⃣ Power BI — Interactive Dashboard
Two pages, built for two audiences:

**Page 1 — Executive Overview**

**Page 2 — Churn Rate & Retention Operations**

---

## 🔑 Key Findings

- **26.54%** overall churn rate — roughly 1 in 4 customers has left
- Churn is **front-loaded**: 47.44% of customers in their first year churn, vs. 9.51% for 4+ year customers
- **Month-to-month** contracts churn far more than annual contracts
- Fiber optic customers **without Tech Support** churn at ~49%, vs. ~23% with it — nearly 2x
- Churn rate falls almost linearly as customers adopt **more add-on services**
- Customers who raise **more support tickets** churn at a visibly higher rate

## ✅ Business Recommendations

- Prioritize retention offers in the **first 12 months** of the customer lifecycle
- Incentivize migration from month-to-month to **annual contracts**
- Bundle a free **Tech Support trial** for new Fiber optic customers
- Route customers with **2+ support tickets** into proactive retention outreach
- Act on the dashboard's revenue-ranked **High-Risk Active Customers** list first

---

## 🚀 How to Reproduce

1. Import SQL file into MySQL Workbench to build the database and run the extraction query.
2. Export the extraction query result as CSV and run the python file (.pynb) to clean the data and engineer features.
3. Load the cleaned CSV into Dashboard in Power BI Desktop.

---

## 🧰 Tools Used

`MySQL Workbench` · `Python (Pandas)` · `Power BI Desktop` · `DAX`

---

Feel free to connect if you have questions or feedback about this project.
