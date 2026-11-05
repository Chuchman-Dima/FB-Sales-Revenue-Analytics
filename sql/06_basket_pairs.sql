drop table if exists analytics.basket_departments cascade;
create table analytics.basket_departments as
select distinct t.basket_id, p.department
from analytics.transactions t
join raw.product p on t.product_id = p.product_id;

create index on analytics.basket_departments (basket_id);

drop table if exists analytics.department_pairs;
create table analytics.department_pairs as
select a.department as department_a, b.department as department_b, count(*) as baskets,
round(100.0 * count(*) / (select count(*) from analytics.baskets), 2) as pct_of_baskets
from analytics.basket_departments a
join analytics.basket_departments b on a.basket_id = b.basket_id and a.department < b.department
group by a.department, b.department
order by baskets desc;
