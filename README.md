# TrailBlaze Outdoors: 2024 Sales Analysis (SQL + Power BI)

> **Headline:** Focusing on revenue rank alone would send TrailBlaze's budget to the wrong places. Camping Gear leads on revenue, but Accessories earns the most per dollar sold (66% margin), and Footwear combines the highest return rate (6.7%) with the lowest margin (49.9%).

![TrailBlaze dashboard](dashboard-screenshot.png)

**Capstone project | HerTechTrail Data Analytics Starter Project | PostgreSQL, Power BI, DAX**

## At a glance
| | |
|---|---|
| Revenue (2024) | $47,088 |
| Orders | 500 |
| Average order value | $94.18 |
| Return rate | 4.60% (23 of 500 orders) |
| Online share of revenue | 72.7% |
| Overall profit margin | 56.3% |

## The problem
TrailBlaze Outdoors sells hiking and camping gear online and in store. Before planning next year's inventory and marketing budget, leadership wanted a clear picture of 2024 sales: what sells, where, to whom, and what is going wrong.

I took the role of junior data analyst. The data is a fictional 2024 dataset (60 customers, 15 products, 500 orders) provided with the course.

## My approach
1. **SQL first (23 queries):** I explored the data and answered specific questions before building anything visual, so the dashboard rests on numbers I had already checked.
2. **Power BI second:** I built a one-page executive dashboard for a store manager, with the KPI measures written in DAX.
3. **Reconciled the two:** the SQL results and the dashboard agree (revenue, order count, average order value and the 4.60% return rate).

## What I found

**1. Revenue rank and profitability point in different directions.**

| Category | Revenue | Orders | Margin % | Return rate |
|---|---|---|---|---|
| Camping Gear | $12,325 | 69 | 55.0% | 2.9% (2 of 69) |
| Backpacks | $9,985 | 82 | 53.9% | 4.9% (4 of 82) |
| Footwear | $9,462 | 75 | **49.9%** | **6.7% (5 of 75)** |
| Apparel | $9,090 | 94 | 60.5% | 4.3% (4 of 94) |
| Accessories | $6,226 | 180 | **66.0%** | 4.4% (8 of 180) |

Camping Gear brings in the most revenue and the most absolute margin ($6,775), so it keeps stock priority. Accessories has the lowest revenue but the best margin per dollar, and it is cheap to stock, so it deserves more marketing than its revenue rank suggests.

**2. Footwear is the one to watch.** It has the highest return rate and the lowest margin, and the most returned revenue of any category ($778). The sample is small (5 returns in 75 orders), so this is a flag to investigate and not yet a conclusion. I would look into sizing and reasons for return before spending more on footwear marketing.

**3. Loyalty tiers do not show higher spending.** Standard customers bring in 52.5% of revenue, but they are also half of all customers (30 of 60). Per customer, Standard spends about $825, Gold about $777 and Silver about $708. Gold customers are not spending more, so the tier benefits are worth reviewing.

**4. There is no strong seasonal peak, but there are two dips.** Revenue is fairly flat through the year, with April ($2,652) and August ($1,800, the lowest) well below it. August had fewer orders (30) and a much lower average order ($60 against $94 overall), which suggests a demand problem and not only a volume problem.

**Also noted:**
- Online brings in 72.7% of revenue. Five orders (1%) had no sales channel and are shown separately as Unknown.
- Europe and North America together bring in 52% of revenue. East Africa is smallest by revenue (11%) but has the highest revenue per customer ($870), which may point to room to acquire more customers there (small numbers, so treat it as a lead).
- The top 10 customers account for 30.5% of revenue, so TrailBlaze is not overly dependent on a few buyers.

## Recommendations
1. **Investigate Footwear returns** (sizing, product descriptions, return reasons) before increasing footwear marketing.
2. **Keep Camping Gear as the top stock priority** and **push Accessories harder in marketing**, because it is highly profitable and cheap to stock.
3. **Plan promotions for April and August**, the two weakest months.
4. **Review the loyalty programme.** Higher tiers should show higher spend, and currently they do not.

## SQL
23 queries in [`trailblaze_sql_queries.sql`](trailblaze_sql_queries.sql), covering:
- Filtering, sorting and date ranges
- Aggregation: `SUM`, `AVG`, `COUNT`, `GROUP BY`, `HAVING`
- `JOIN` and `LEFT JOIN` (a check for dormant customers found none: all 60 customers ordered)
- `COALESCE` for missing sales channels
- CTEs, `RANK()`, `ROW_NUMBER()` and running totals with `SUM() OVER`

## Dashboard
A one-page Power BI dashboard with:
- **KPI cards:** Total Revenue, Total Orders, Average Order Value, Return Rate
- **Visuals:** monthly trend, revenue by category, region map, sales channel split, loyalty tier, top 10 customers, best-selling product per category and profit margin by category
- **Slicers** for Region and Category
- **DAX measures:** Total Revenue, Total Orders, Average Order Value, Return Rate and Margin %, plus a cleaned sales channel field to handle missing values

## Limitations and next steps
- The data is one year of fictional sales, so seasonality and trends cannot be checked across years.
- Several category and region figures rest on small counts, so I show the counts next to the rates.
- Margin is calculated from list unit cost and does not adjust for returned orders.
- With real data I would add return reasons, customer-level repeat purchases and a comparison against the previous year.

## Files
| File | What it is |
|---|---|
| `trailblaze_sql_queries.sql` | All 23 SQL queries |
| `TrailBlaze_Executive_Dashboard.pbix` | Power BI dashboard file |
| `TrailBlaze_Executive_Dashboard.pdf` | PDF export of the dashboard |
| `dashboard-screenshot.png` | Dashboard preview |

**Author:** Favour Udochi Secondus
