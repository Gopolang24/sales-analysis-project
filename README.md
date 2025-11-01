# Retail Sales Analysis Project (SQL Only)

### MySQL Data Cleaning & Analytical Views

This project demonstrates a complete **SQL-based data analytics workflow** — from cleaning raw retail sales data to generating reusable analytical views for insights.

---

## Project Overview

**Goal:**  
To analyze retail sales data and uncover actionable business insights such as:
- Best-selling categories, customers, and months  
- Profitability and growth trends  
- Customer demographics and spending behavior  

**Key Focus Areas:**
1. Data Cleaning & Validation  
2. Data Transformation & Aggregation  
3. Analytical SQL Views  
4. KPI & Insight Extraction  

---

## Database Schema

**Table:** `retail_sales`

| Column Name       | Data Type | Description |
|-------------------|------------|--------------|
| transactions_id   | INT (PK)   | Unique transaction identifier |
| sale_date         | DATE       | Date of sale |
| sale_time         | TIME       | Time of sale |
| customer_id       | INT        | Customer identifier |
| gender            | VARCHAR(6) | Gender of customer |
| age               | INT        | Customer age |
| category          | VARCHAR(15)| Product category |
| quantity          | INT        | Units sold |
| price_per_unit    | DOUBLE     | Price per item |
| cogs              | FLOAT      | Cost of goods sold |
| total_sale        | INT        | Total sale amount |

---

## Step 1: Data Cleaning & Validation

Performed key data cleaning operations:
- Removed nulls, zeros, and invalid entries  
- Replaced missing ages with category-level averages  
- Verified `total_sale = quantity * price_per_unit` consistency  
- Added validation logic to flag data quality issues  

**Key Views:**
- `v_clean_sales` → filters out invalid records  
- `v_data_quality_issues` → lists invalid rows (price, quantity, or age issues)

---

## Step 2: Analytical SQL Views

### Performance & Trend Views

| View | Description |
|------|--------------|
| `v_category_sales_summary` | Total and average sales per category |
| `v_monthly_sales` | Monthly total and average sales |
| `v_best_selling_month` | Best-performing month per year |
| `v_sales_with_shift` | Adds shift classification (Morning/Afternoon/Evening) |
| `v_monthly_growth` | Month-over-month sales growth % using window functions |

### Customer & Demographics Views

| View | Description |
|------|--------------|
| `v_top_customers` | Top customers ranked by purchase amount |
| `v_customer_summary` | Each customer’s total orders, spend, and average sale |
| `v_gender_category_performance` | Sales by gender and category |
| `v_age_group_sales` | Sales grouped by age segments (18–25, 26–35, etc.) |

### Profitability & KPI Views

| View | Description |
|------|--------------|
| `v_profit_margin_by_category` | Profit margin per product category |
| `v_category_contribution` | % contribution of each category to total sales |
| `v_gender_spending_comparison` | Gender-based sales comparison |
| `v_kpi_dashboard` | Combines major business KPIs (total sales, top category, etc.) |

---

## SQL Highlights

- Extensive use of **window functions** (`RANK()`, `LAG()`)  
- Conditional logic via **CASE** for shifts and age segmentation  
- Modular and maintainable structure using **views**  
- Built-in **data validation logic** for integrity checking  

---

## Insights Discovered (Example)

- **Customers aged 26–35** drive the highest sales volume  
- **Electronics** and **Clothing** are top revenue categories  
- **Afternoon** shift sees the most sales activity  
- **November** was the most profitable month overall  

---

## Recommended Folder Structure

sales-analysis-project/
│
├── sql/
│ ├── sales_analysis.sql
│ ├── data_cleaning.sql
│ └── views/
│ ├── v_clean_sales.sql
│ ├── v_best_selling_month.sql
│ └── v_kpi_dashboard.sql
│
└── README.md


---

## Tools Used
- **MySQL** — for data cleaning, validation, and analysis  
- **GitHub** — for version control and sharing  
- *(Power BI planned for future visualization phase)*  

---

## Future Improvements
- Add triggers for automatic validation logging  
- Integrate stored procedures for periodic data updates  
- Build Power BI dashboard using the existing SQL views  

---

## Author
**Created by:** *Gopolang mmutlwane* 
GitHub: [github.com/Gopolang24](https://github.com/Gopolang24)  

