create schema if not exists analytics;

drop table if exists analytics.transactions cascade;
create table analytics.transactions as
select household_key, basket_id, day, week_no, store_id, product_id, quantity, sales_value, retail_disc, coupon_disc, coupon_match_disc,
trans_time / 100 as hour_of_day,
(day - 1) % 7 + 1 as weekday,
-- припущення: sales_value вже зменшена на retail_disc і coupon_match_disc
-(retail_disc + coupon_match_disc) as discount
from raw.transaction_data
where quantity > 0 and sales_value > 0;

create index on analytics.transactions (household_key);
create index on analytics.transactions (basket_id);
create index on analytics.transactions (product_id);

drop table if exists analytics.baskets cascade;
create table analytics.baskets as
select basket_id, min(household_key) as household_key, min(store_id) as store_id, min(day) as day, min(week_no) as week_no,
min(hour_of_day) as hour_of_day, min(weekday) as weekday, count(*) as items, sum(sales_value) as sales_value,
sum(discount) as discount, sum(coupon_disc) as coupon_disc
from analytics.transactions
group by basket_id;

create index on analytics.baskets (household_key);
create index on analytics.baskets (week_no);

select count(*) as raw_rows from raw.transaction_data;
select count(*) as clean_rows from analytics.transactions;
