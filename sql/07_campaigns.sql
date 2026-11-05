drop table if exists analytics.campaign_overview;
create table analytics.campaign_overview as
select d.campaign, d.description as campaign_type, d.start_day, d.end_day, t.households as targeted, r.households as redeemed,
round(100.0 * r.households / t.households, 1) as redemption_pct
from raw.campaign_desc d
left join (select campaign, count(distinct household_key) as households from raw.campaign_table group by campaign) t on d.campaign = t.campaign
left join (select campaign, count(distinct household_key) as households from raw.coupon_redempt group by campaign) r on d.campaign = r.campaign
order by d.campaign;

-- без контрольної групи: це лише зміна витрат цільових домогосподарств
drop table if exists analytics.campaign_effect;
create table analytics.campaign_effect as
select d.campaign, d.description as campaign_type, count(distinct ct.household_key) as households,
round(sum(case when b.day between d.start_day - (d.end_day - d.start_day + 1) and d.start_day - 1 then b.sales_value else 0 end), 2) as spend_before,
round(sum(case when b.day between d.start_day and d.end_day then b.sales_value else 0 end), 2) as spend_during
from raw.campaign_desc d
join raw.campaign_table ct on ct.campaign = d.campaign
join analytics.baskets b on b.household_key = ct.household_key
where d.start_day - (d.end_day - d.start_day + 1) >= 1
group by d.campaign, d.description;

select campaign, campaign_type, households, spend_before, spend_during,
round(100 * (spend_during - spend_before) / spend_before, 1) as growth_pct
from analytics.campaign_effect
where spend_before > 0
order by campaign;

select campaign_type, round(avg(100 * (spend_during - spend_before) / spend_before), 1) as avg_growth_pct
from analytics.campaign_effect
where spend_before > 0
group by campaign_type;

drop table if exists analytics.discount_by_department;
create table analytics.discount_by_department as
select p.department, sum(t.sales_value) as revenue, sum(t.discount) as discount,
round(100 * sum(t.discount) / (sum(t.sales_value) + sum(t.discount)), 2) as discount_pct
from analytics.transactions t
join raw.product p on t.product_id = p.product_id
group by p.department
order by revenue desc;

drop table if exists analytics.coupon_baskets;
create table analytics.coupon_baskets as
select case when coupon_disc < 0 then 'with coupon' else 'without coupon' end as basket_type,
count(*) as baskets, round(avg(sales_value), 2) as avg_basket, round(avg(items), 1) as avg_items
from analytics.baskets
group by 1;

drop table if exists analytics.deal_seekers;
create table analytics.deal_seekers as
select case when discount_pct > (select avg(discount_pct) from analytics.customers) then 'deal seekers' else 'regular' end as customer_type,
count(*) as households, round(avg(revenue), 2) as avg_revenue, round(avg(baskets), 1) as avg_baskets
from analytics.customers
group by 1;
