drop table if exists analytics.customers cascade;
create table analytics.customers as
select household_key, min(day) as first_day, max(day) as last_day, count(*) as baskets, sum(sales_value) as revenue,
round(sum(sales_value) / count(*), 2) as avg_basket,
round(100 * sum(discount) / (sum(sales_value) + sum(discount)), 2) as discount_pct,
(select max(day) from analytics.baskets) - max(day) as days_since_last_purchase
from analytics.baskets
group by household_key;

drop table if exists analytics.customer_segments;
create table analytics.customer_segments as
select household_key, baskets, revenue, days_since_last_purchase,
case
when days_since_last_purchase <= 56 and revenue >= (select avg(revenue) from analytics.customers) then 'active high value'
when days_since_last_purchase <= 56 then 'active low value'
when revenue >= (select avg(revenue) from analytics.customers) then 'inactive high value'
else 'inactive low value'
end as segment
from analytics.customers;

drop table if exists analytics.segment_summary;
create table analytics.segment_summary as
select segment, count(*) as households,
round(100.0 * count(*) / (select count(*) from analytics.customers), 1) as households_pct,
sum(revenue) as revenue,
round(100 * sum(revenue) / (select sum(revenue) from analytics.customers), 1) as revenue_pct
from analytics.customer_segments
group by segment
order by revenue desc;

drop table if exists analytics.revenue_concentration;
create table analytics.revenue_concentration as
select 'top 1%' as customers, sum(revenue) as revenue,
round(100 * sum(revenue) / (select sum(revenue) from analytics.customers), 1) as revenue_pct
from (select revenue from analytics.customers order by revenue desc limit (select count(*) / 100 from analytics.customers)) t
union all
select 'top 10%', sum(revenue), round(100 * sum(revenue) / (select sum(revenue) from analytics.customers), 1)
from (select revenue from analytics.customers order by revenue desc limit (select count(*) / 10 from analytics.customers)) t
union all
select 'top 20%', sum(revenue), round(100 * sum(revenue) / (select sum(revenue) from analytics.customers), 1)
from (select revenue from analytics.customers order by revenue desc limit (select count(*) / 5 from analytics.customers)) t;

select round(100.0 * count(case when baskets >= 2 then 1 end) / count(*), 1) as repeat_customers_pct from analytics.customers;

select round(avg((last_day - first_day) * 1.0 / (baskets - 1)), 1) as avg_days_between_baskets
from analytics.customers
where baskets > 1;
