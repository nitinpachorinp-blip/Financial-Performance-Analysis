drop table if exists orders;

create table orders (
row_id int primary key,
order_id varchar(500),
order_date date,
ship_date date,
ship_mode varchar(500),
customer_id varchar(500),
customer_name varchar(500),
segment varchar(500),
country varchar(500),
city varchar(500),
state varchar(500),
postal_code varchar(500),
region varchar(500),
product_id varchar(500),
category varchar(500),
sub_category varchar(500),
product_name varchar(500),
sales numeric,
quantity int,
discount numeric,
profit numeric
);

select * from orders;

create table people (
regional_manager varchar(50),
region varchar(10) primary key
);

select * from people;

create table returns (
order_id varchar(500),
returned varchar(10)
);

select * from returns;

BUSINESS PROBLEMS

SALES ANALYSIS

Q1.TOTAL SALE BY REGION

select region,sum(sales) as total_sales
from orders
group by 1
order by 2 desc;

Q2.TOTAL SALE BY STATE

select state,sum(sales) as total_sales
from orders
group by 1
order by 2 desc;

Q3.TOTAL SALE BY CATEGORY 

select category, sum(sales) as total_sales
from orders
group by 1
order by 2;

Q4.TOP 10 CUSTOMER BY SALE 

select customer_id,
customer_name,
sum(sales) as total_sales from orders
group by 1,2
order by 3 desc
limit 10;

Q5.TOP 10 PRODUCT BY SALE 

select product_id,
product_name,
sum(sales) as total_sales 
from orders
group by 1,2
order by 3 desc
limit 10;

Q6.What are the total sales and total quantity sold for each year and month?

method 1

select 
extract(year from order_date) as order_year,
extract(month from order_date) as order_month,
sum(sales) as total_sales,
sum(quantity) as total_quantity
from orders
group by 1,2
order by 1,2 asc;

method 2

SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY order_month;

Q7.Which top 5 cities generated the highest total revenue

select city, 
sum(sales) as total_sales
from orders
group by 1
order by 2 desc
limit 5;

PROFIT ANALYSIS

Q8.TOTAL PROFIT BY REGION 

select region,
sum(profit) as total_profit
from orders
group by 1
order by 2 desc;

Q9.TOTAL PROFIT BY STATE

select state,
sum(profit) as total_profit
from orders
group by 1
order by 2 desc;

Q10.TOTAL PROFIT BY CATEGORY

select category,
sum(profit) as total_profit
from orders
group by 1
order by 2 desc;

Q11.TOTAL PROFIT BY SUB CATEGORY

select sub_category,
sum(profit) as total_profit
from orders
group by 1
order by 2 desc;

Q12.top 10 customer by profit

select customer_id,
customer_name,
sum(profit) as total_profit
from orders
group by 1,2
order by 3 desc
limit 10;

Q13.TOP 10 PRODUCT BY PROFIT

select product_id,
product_name,
sum(profit) as total_profit
from orders
group by 1,2
order by 3 desc
limit 10;

Q14.LOSS MAKING PRODUCT

select product_id,
product_name,
sum(profit) as total_profit
from orders
group by 1,2
having sum(profit) <0
order by 3;

Q15.What is the overall profit margin percentage for the business

select 
sum(profit) as total_profit,
sum(sales) as total_sales,
round((sum(profit)/sum(sales))*100,2) as profit_margin
from orders;

Q16.How many orders resulted in a net loss, and what is the total amount lost

select 
count(distinct order_id) as no_of_loss_items,
sum(profit) as total_profit
from orders
where profit < 0;

BASIC CUSTOMER SEGMENT ANALYSIS

Q17.WHICH CUTOMER SEGMENT GENERATES THE HIGHEST TOTAL SALE AND PROFIT

select 
segment,
sum(sales) as total_sales,
sum(profit) as total_profit
from orders
group by 1
order by 2 desc, 3 desc;

Q18.Which customer segment has the highest average profit per order?

select 
segment,
avg(profit) as avg_profit
from orders
group by 1
order by 2 desc;

Q19.Which customer segment has placed the highest number of orders?

select 
segment,
count(*) as no_of_orders
from orders
group by 1
order by 2 desc;

Q20.Which customer segment has the highest average sales per order?

select
segment,
avg(sales) as avg_sales
from orders
group by 1
order by 2 desc;

Q21.Which customer segment has sold the highest total quantity of products?

select 
segment,
sum(quantity) as total_quantity
from orders
group by 1
order by 2 desc;

Q22.Which customer segment receive the highest average profit ?

select
segment,
avg(profit) as total_profit
from orders
group by 1
order by 2 desc;

ADVANCE CUSTOMER SEGMENT ANALYSIS

Q23.Business Scenario
The company wants to classify its customer segments based on total sales performance so that the marketing 
team can plan different strategies.

Business Rules:
High Sales → Total Sales ≥ 700000
Medium Sales → Total Sales between 500000 and 699999
Low Sales → Total Sales < 500000

select
segment,
sum(sales) as total_sales,
case
when sum(sales) >= 700000 then 'High Sales'
when sum(sales) between 500000 and 699999 then 'Medium Sales'
else 'Low Sales'
end as performance
from orders
group by 1
order by 2 desc;

Q24.Rank the customer segments based on their total sales from highest to lowest.

select 
segment,
sum(sales) as total_sales,
rank() over (order by sum(sales) desc) as rnk
from orders
group by segment
order by rnk;

Q25. The management wants to identify only the customer segments whose total sales are greater than ₹500,000.

method 1

select 
segment,
sum(sales) as total_sales
from orders
group by 1
having sum(sales) >500000
order by 2 desc;

method 2

with segment_sales as(
select segment,
sum(sales) as total_sales
from orders
group by 1
)
select * from segment_sales
where total_sales >500000;

Q26.Find the customer segments whose total sales are greater than the average total sales of all 
customer segments.

select segment,
sum(sales) as total_sales,
avg(sales) as avg_sales
from orders
group by 1
having sum(sales) > 
(
select avg(total_sales) as avg_sales
from( 
select segment,sum(sales) as total_sales from orders
group by segment) as segment_totals
);

Q27.Which customer segment has the highest return rate?

select o.segment,
count (distinct o.quantity) as total_quantity,
count(distinct r.order_id) as total_return,
round((count(distinct r.order_id)::numeric/count(distinct o.order_id))*100,2) as return_rate
from
orders o left join returns r on
o.order_id = r.order_id
group by o.segment
order by return_rate desc;

Q28.What is the contribution of each segment to the top 10% of most profitable orders?

with ranked_orders as (
select order_id,segment,sum(profit)as order_profit,
percent_rank() over (order by sum(profit) desc) as p_rank
from orders
group by 1,2
)
select segment, count(order_id) as high_profit
from ranked_orders
where p_rank <=0.10
group by segment
order by high_profit desc;

Basic Regional Analysis

Q29.Which region generates the highest total sales and total profit for the company?

select region,
sum(sales) as total_sales,
sum(profit) as total_profit
from orders
group by region
order by 2 desc, 3 desc;

Q31.Which region has the highest average profit per order?

select region,
count(order_id) as total_orders,
avg(profit) as avg_profit
from orders
group by region
order by 3 desc;

Q32.Which region has the highest number of orders?

select region,
count(order_id) as total_orders
from orders
group by region
order by 2 desc;

Q33.Which region has the highest average sales per order?

select region,
count(order_id) as total_orders,
round(avg(sales),2) as avg_sales
from orders
group by region
order by 3 desc;

Q34.Which region sold the highest total quantity of products?

select region,
sum(quantity) as total_quantity
from orders
group by region
order by 2 desc;

Q34.Which region offers the highest average discount to customers?

select region,
round(avg(discount),2) as avg_discount
from orders
group by 1
order by 2 desc;

Q35.What are the total sales and profit generated by each region, mapped to their respective regional managers?

select o.region,
sum(o.sales) as total_sales,
sum(o.profit) as total_profit,
p.regional_manager
from orders o join people p on
o.region = p.region
group by o.region,p.regional_manager
order by total_sales desc;

ADVANCED BUSINESS ANALYSIS

Q36.Classify each region based on total sales.

Business Rules
High Sales → Total Sales ≥ 700,000
Medium Sales → Total Sales between 500,000 and 699,999
Low Sales → Total Sales < 500,000

select region,
sum(sales) as total_sales,
case
when sum(sales) >=700000 then 'High Sales'
when sum(sales) between 500000 and 699999 then 'Medium Sales'
else 'Low Sales'
end as category
from orders
group by region;

Q37.Rank the regions based on total sales from highest to lowest?

select region,
sum(sales) as total_sales,
rank() over (order by sum(sales) desc) as rnk
from orders
group by region
order by rnk;

Q38.Management wants to identify only those regions whose total sales are greater than ₹500,000.

method 1

select region,
sum(sales) as total_sales
from orders
group by region
having sum(sales) > 500000;

method 2

with high_sales as (
select region,
sum(sales) as total_sales
from orders
group by region
)
select * from 
high_sales
where total_sales > 500000;

Q39.Find the regions whose total sales are greater than the average total sales of all regions.

select region,
sum(sales) as total_sales
from orders
group by region 
having sum(sales) > (select avg(total_sales) from (
select region,sum(sales) as total_sales from orders group by region
)) 
order by total_sales desc;

Q40.What is the Year-over-Year (YoY) growth rate in total sales?

with yoy as (
select extract(year from order_date) as year,
sum(sales) as total_sales from orders
group by 1
order by 1
)
select *,
lag(total_sales) over (order by year) as prev_year_sales,
(total_sales - lag(total_sales) over (order by year)) as growth_sales,
round(((total_sales - lag(total_sales) over (order by year))/(lag(total_sales) over (order by year)))*100,2)
as growth_rate
from yoy;

Q41.How much potential revenue and profit was lost specifically due to returned orders?

select sum(o.sales) as lost_sales,
sum(o.profit) as lost_profit
from orders o join returns r on 
o.order_id = r.order_id
where r.returned = 'Yes';

CATEGORY ANALYSIS

Q42.Which product category generated the highest total sales and total profit?

select category,
sum(sales) as total_sales,
sum(profit) as total_profit
from orders
group by category
order by 2 desc,3 desc

Q43.Classify each category based on total profit.

Business Rules
High Profit → Profit ≥ 130000
Medium Profit → Profit between 50000 and 129999
Low Profit → Profit < 50000

select category,
sum(profit) as total_profit,
case
when sum(profit) >=130000 then 'High Profit'
when sum(profit) between 50000 and 129999 then 'Medium Profit'
else 'Low Profit'
end as class_
from orders
group by category
order by 2 desc;

Q44.Rank the product categories based on total profit from highest to lowest.

select category,
sum(profit) as total_profit,
rank() over (order by sum(profit) desc) as rnk
from orders
group by category
order by rnk ;

Q45.Find the categories whose total profit is greater than the average total profit of all categories.

select category,
sum(profit) as total_profit
from orders
group by category
having sum(profit) > (
select avg(total_profit) from (
select category,sum(profit) as total_profit
from orders
group by category)
);

Q46.Which product category yields the highest average discount while still maintaining an 
overall positive profit?

select category,
round(avg(discount),2) as avg_discount,
sum(profit) as total_profit
from orders
group by category
having sum(profit) > 0;

SUB_CATEGORY ANALYSIS 

Q47.Which are the Top 5 sub-categories based on total sales?

select sub_category,
sum(sales) as total_sales
from orders
group by sub_category
order by 2 desc
limit 5;

Q48.Rank all sub-categories based on total profit from highest to lowest.

select sub_category,
sum(profit) as total_profit,
rank() over (order by sum(profit) desc) as rnk
from orders
group by sub_category 
order by rnk;

Q49.Find the sub-categories whose total profit is greater than ₹30,000.

select sub_category,
sum(profit) as total_profit
from orders
group by sub_category
having sum(profit) > 30000
order by 2 desc;

Q50.Find the sub-categories whose total sales exceed ₹200,000 using a CTE.

with sub_cat as (
select sub_category,
sum(sales) as total_sales
from orders
group by sub_category
)
select * from sub_cat
where total_sales > 200000
order by total_sales desc;

Q51.What are the top 3 most profitable sub-categories, and what is their total sales volume?

select sub_category,
sum(sales) as total_sales,
sum(profit) as total_profit
from orders 
group by sub_category
order by 3 desc
limit 3;

Q52.Which sub-category has the highest volume of returned items?

select 
o.sub_category,
sum(o.quantity) as returned_quantity
from orders o join returns r on
o.order_id = r.order_id
where r.returned = 'Yes'
group by o.sub_category
order by returned_quantity desc;

CUSTOMER ANALYSIS 

Q53.Who are the Top 10 customers based on total sales?

select customer_id,customer_name,
sum(sales)as total_sales
from orders
group by 1,2
order by 3 desc
limit 10;

Q54.Rank customers based on their total sales from highest to lowest.

select customer_id,customer_name,
sum(sales)as total_sales,
rank() over (order by sum(sales) desc) as rnk
from orders
group by 1,2
order by rnk ;

Q55.Find customers whose total sales are greater than ₹10,000.

select customer_id,customer_name,
sum(sales)as total_sales
from orders
group by 1,2
having sum(sales) > 10000
order by 3 desc;

Q56.Classify customers based on their total sales.

Business Rules
 Premium Customer → Total Sales ≥ 15,000
 Regular Customer → Total Sales between 8,000 and 14,999
 Standard Customer → Total Sales < 8,000

select customer_id,customer_name,
sum(sales) as total_sales,
case
when sum(sales) >= 15000 then 'premium customer'
when sum(sales) between 8000 and 14999 then 'regular customer'
else 'standard customer'
end as customer_type
from orders
group by 1,2;

Q57.Who are the top 10 most valuable customers based on lifetime sales, 
and how many separate orders have they placed?

select customer_id,customer_name,
count(distinct order_id) as total_orders,
sum(sales) as total_sales
from orders
group by 1,2
order by 4 desc
limit 10;

Q58.Which customers have an average profit per order of less than $0 across multiple purchases?

select customer_id,customer_name,
count(distinct order_id) as order_count,
(sum(profit) / count(distinct order_id)) as avg_profit
from orders
group by 1,2
having count(distinct order_id) > 1 and (sum(profit) / count(distinct order_id)) < 0;

SHIPPING ANALYSIS

Q59.Which shipping mode generated the highest total sales and total profit?

select ship_mode,
sum(sales) as total_sales,
sum(profit) as total_profit
from orders
group by 1
order by 2 desc, 3 desc;

Q60.Find the average sales for each shipping mode and rank them from highest to lowest.

select ship_mode,
avg(sales) as avg_sales,
rank() over (order by avg(sales) desc) as rnk
from orders
group by 1
order by rnk;

Q61.What is the average fulfillment delay (difference in days between order date and ship date) 
for each shipping mode?

select ship_mode,
round(avg(ship_date - order_date),2) as avg_day
from orders
group by 1;

Q62.Is a faster shipping mode correlated with a lower return rate?

select 
o.ship_mode,
count(distinct o.order_id) as total_orders,
count(distinct r.order_id) as returned_orders,
round((count(distinct r.order_id)::numeric / count(distinct o.order_id)) * 100, 2) AS return_rate_percentage
from orders o
left join returns r on o.order_id = r.order_id
group by o.ship_mode
order by return_rate_percentage desc;