select count(*) from raw.transaction_data;

select min(day), max(day), min(week_no), max(week_no) from raw.transaction_data;

select count(distinct household_key) as households, count(distinct basket_id) as baskets, count(distinct product_id) as products, count(distinct store_id) as stores
from raw.transaction_data;

select count(*) as zero_sales from raw.transaction_data where sales_value = 0;

select count(*) as negative_sales from raw.transaction_data where sales_value < 0;

select count(*) as zero_quantity from raw.transaction_data where quantity = 0;

select count(*) as negative_quantity from raw.transaction_data where quantity < 0;

select count(*) as positive_discounts from raw.transaction_data
where retail_disc > 0 or coupon_disc > 0 or coupon_match_disc > 0;

select count(*) as week_mismatch from raw.transaction_data where week_no <> (day - 1) / 7 + 1;

select count(*) as no_product
from raw.transaction_data t
left join raw.product p on t.product_id = p.product_id
where p.product_id is null;

select count(distinct t.household_key) as households_without_demographics
from raw.transaction_data t
left join raw.hh_demographic d on t.household_key = d.household_key
where d.household_key is null;

select count(distinct household_key) as households_in_coupon_redempt from raw.coupon_redempt;

select count(distinct household_key) as households_with_coupon_discount
from raw.transaction_data
where coupon_disc <> 0;

select count(*) as duplicate_groups from (
select 1 from raw.transaction_data
group by household_key, basket_id, day, product_id, quantity, sales_value, store_id, retail_disc, trans_time, week_no, coupon_disc, coupon_match_disc
having count(*) > 1
) d;
