drop table if exists analytics.demographic_profile;
create table analytics.demographic_profile as
select 'income' as dimension, d.income_desc as category, count(*) as households, round(avg(c.revenue), 2) as avg_revenue, round(avg(c.baskets), 1) as avg_baskets
from raw.hh_demographic d
join analytics.customers c on d.household_key = c.household_key
group by d.income_desc
union all
select 'age', d.age_desc, count(*), round(avg(c.revenue), 2), round(avg(c.baskets), 1)
from raw.hh_demographic d
join analytics.customers c on d.household_key = c.household_key
group by d.age_desc
union all
select 'household size', d.household_size_desc, count(*), round(avg(c.revenue), 2), round(avg(c.baskets), 1)
from raw.hh_demographic d
join analytics.customers c on d.household_key = c.household_key
group by d.household_size_desc
union all
select 'kids', d.kid_category_desc, count(*), round(avg(c.revenue), 2), round(avg(c.baskets), 1)
from raw.hh_demographic d
join analytics.customers c on d.household_key = c.household_key
group by d.kid_category_desc;
