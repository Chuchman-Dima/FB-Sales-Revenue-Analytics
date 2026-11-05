drop table if exists analytics.kpi_overview;
create table analytics.kpi_overview as
select sum(sales_value) as revenue, count(*) as baskets, count(distinct household_key) as households,
round(avg(sales_value), 2) as avg_basket, round(avg(items), 1) as avg_items,
round(sum(sales_value) / count(distinct household_key), 2) as revenue_per_household
from analytics.baskets;

drop table if exists analytics.weekly_kpi;
create table analytics.weekly_kpi as
select week_no, sum(sales_value) as revenue, count(*) as baskets, count(distinct household_key) as households,
round(avg(sales_value), 2) as avg_basket
from analytics.baskets
group by week_no
order by week_no;

drop table if exists analytics.department_performance;
create table analytics.department_performance as
select p.department, sum(t.sales_value) as revenue,
round(100 * sum(t.sales_value) / (select sum(sales_value) from analytics.transactions), 2) as revenue_share_pct,
count(distinct t.basket_id) as baskets,
round(100 * sum(t.discount) / (sum(t.sales_value) + sum(t.discount)), 2) as discount_pct
from analytics.transactions t
join raw.product p on t.product_id = p.product_id
group by p.department
order by revenue desc;

drop table if exists analytics.brand_by_department;
create table analytics.brand_by_department as
select p.department, p.brand, sum(t.sales_value) as revenue
from analytics.transactions t
join raw.product p on t.product_id = p.product_id
group by p.department, p.brand
order by p.department, revenue desc;

drop table if exists analytics.top_commodities;
create table analytics.top_commodities as
select p.department, p.commodity_desc, sum(t.sales_value) as revenue, count(distinct t.basket_id) as baskets
from analytics.transactions t
join raw.product p on t.product_id = p.product_id
group by p.department, p.commodity_desc
order by revenue desc
limit 50;

drop table if exists analytics.store_performance;
create table analytics.store_performance as
select store_id, sum(sales_value) as revenue, count(*) as baskets, count(distinct household_key) as households,
round(avg(sales_value), 2) as avg_basket
from analytics.baskets
group by store_id
order by revenue desc;

drop table if exists analytics.time_patterns;
create table analytics.time_patterns as
select weekday, hour_of_day, count(*) as baskets, sum(sales_value) as revenue
from analytics.baskets
group by weekday, hour_of_day
order by weekday, hour_of_day;

drop table if exists analytics.basket_size;
create table analytics.basket_size as
select case when items = 1 then '1' when items <= 5 then '2-5' when items <= 10 then '6-10' when items <= 20 then '11-20' else '21+' end as size_group,
count(*) as baskets, sum(sales_value) as revenue
from analytics.baskets
group by 1
order by min(items);
