-- cohort 1 = клієнти, які вже купували до початку даних
drop table if exists analytics.first_purchase cascade;
create table analytics.first_purchase as
select household_key, (min(week_no) - 1) / 4 + 1 as cohort
from analytics.baskets
group by household_key;

drop table if exists analytics.cohort_activity cascade;
create table analytics.cohort_activity as
select distinct f.cohort, (b.week_no - 1) / 4 + 1 - f.cohort as period, b.household_key
from analytics.baskets b
join analytics.first_purchase f on b.household_key = f.household_key;

drop table if exists analytics.cohort_retention;
create table analytics.cohort_retention as
select a.cohort, a.period, count(*) as active_households, s.cohort_size,
round(100.0 * count(*) / s.cohort_size, 1) as retention_pct
from analytics.cohort_activity a
join (select cohort, count(*) as cohort_size from analytics.first_purchase group by cohort) s on a.cohort = s.cohort
group by a.cohort, a.period, s.cohort_size
order by a.cohort, a.period;
