# Financial Performance Analysis: PostgreSQL + Power BI

An end-to-end analytics project on retail sales data. I used SQL to answer 60+ business questions, then built a 4-page interactive Power BI report to show where the business makes money, where it loses it, and what returns cost.

**Tools:** PostgreSQL · Power BI (DAX) · SQL (CTEs, window functions, joins)

---

## Why I built this

Most of my earlier projects were in Python. I wanted one project that shows I can take a business question, answer it in SQL, and present the answer in a dashboard a manager could actually use. The question behind the whole project is simple: **which products, regions and segments are driving profit, and which are quietly losing money?**

## Dataset

A retail sales dataset with three tables (Superstore-style data, dates covering 2023 to 2026). The dataset is publicly available and not real company data. *(Add your source link here.)*

| Table | What it holds |
|---|---|
| `orders` | One row per order line: order and ship dates, ship mode, customer, segment, city, state, region, category, sub-category, product, sales, quantity, discount, profit |
| `people` | Regional manager for each region |
| `returns` | Order IDs that were returned |

## Project structure

```
├── README.md
├── new.sql                    # all SQL queries (schema + 60+ business questions)
├── financial_analysis.pbix    # Power BI report
└── screenshots/               # dashboard page images
```

## SQL analysis

The queries are grouped by business area. Each one starts from a plain-English question and builds up from basic aggregations to more advanced logic.

| Section | Example questions answered |
|---|---|
| Sales | Total sales by region, state, category; top 10 customers and products; monthly sales and quantity trend; top 5 cities |
| Profit | Profit by region, state, category, sub-category; loss-making products; overall profit margin |
| Customer segments | Which segment brings the most sales and profit; ranking segments; segments above the average |
| Regional analysis | Sales, profit and discount by region; each region mapped to its manager |
| Category and sub-category | Top sub-categories by sales and profit; categories above average profit; sub-category with the most returns |
| Customers | Ranking customers; Premium / Regular / Standard classification; customers with a negative average profit |
| Shipping | Sales and profit by ship mode; average fulfilment delay; return rate by ship mode |
| Advanced | Year-over-year growth, revenue and profit lost to returns, contribution to the top 10% most profitable orders |

**SQL concepts used:** `JOIN` / `LEFT JOIN`, `GROUP BY` / `HAVING`, subqueries, CTEs, `CASE WHEN` segmentation, `RANK()`, `LAG()`, `PERCENT_RANK()`, date functions (`EXTRACT`, `TO_CHAR`), type casting.

Written for **PostgreSQL**. If you run it on PostgreSQL older than version 16, give every subquery in a `FROM` clause an alias.

## Power BI report

A 4-page report with page navigation buttons and slicers for year, region, segment, category and ship mode.

| Page | What it shows |
|---|---|
| **Overview** | KPI cards (total sales, profit, unique orders, profit margin), sales by segment, monthly profit vs sales, top states by sales |
| **Sales** | Sales by sub-category, top customers, sales by year, quarter, region and regional manager |
| **Profitability** | Profit by sub-category, region and segment, loss-making products, discount vs profit |
| **Operations** | Manager performance, returns by category, returns over time, revenue lost to returns, ship mode preferences |

The data model links `orders`, `people` and `returns`, and the KPIs are built with DAX measures.

*(Add dashboard screenshots to the `screenshots/` folder and show them here.)*

## Key findings

- **Overall:** about $2.33M in sales and $292K in profit, a margin of roughly 12.6%.
- **Some products lose money:** Tables lose about $18K even though they bring around $0.21M in sales. Bookcases (about -$4K) and Supplies (about -$1K) also run at a loss. Copiers are the most profitable sub-category at $56K.
- **Sales don't mean profit:** Chairs are the top sub-category by sales (about $0.34M) but earn only about $27K in profit.
- **Central region is the weak spot:** it brings 21.6% of sales but only 13.6% of profit, a margin of about 8% compared with about 15% in the West.
- **Returns are costly:** returned orders account for about $180.5K of lost revenue, roughly 7.8% of total sales.
- **Q4 is peak season:** about 38% of sales happen in Q4, so stock and staffing need to be ready for it.
- **Consumer is the biggest segment** at about 50% of sales.
- **Standard Class shipping** makes up about 60% of orders.

## Recommendations

1. Review discounts and pricing on Tables, Bookcases and Supplies. These are where profit is leaking.
2. Look into why Central earns so little profit on solid sales. Discount levels would be the first thing to check.
3. Plan inventory and shipping capacity ahead of Q4.
4. Dig into the return drivers by category and ship mode before deciding where to act.

## How to run it

1. Create a PostgreSQL database and load the three tables (`orders`, `people`, `returns`) from the dataset.
2. Run `new.sql` to create the tables and run the queries.
3. Open `financial_analysis.pbix` in Power BI Desktop. If the report asks for a data source, point it to your own PostgreSQL database.

## Limitations and next steps

- The dataset is public sample data, so the findings show the analysis approach rather than a real business.
- Return rate by ship mode is answered in SQL (Q62) and still needs a proper DAX measure in the report.
- Next: add a discount-band vs margin analysis and a repeat-customer view.

## About me

**Nitin Pachori**: entry-level Data Analyst with a B.Com (Hons.) background. I like understanding the business context behind the numbers.

[LinkedIn](https://linkedin.com/in/nitinpachori) · [GitHub](https://github.com/nitinpachorinp-blip) · nitinpachori.np@gmail.com
