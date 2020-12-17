#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "

with recursive rules as
(select
  substring(line, '(.*) bags contain') container,
  substring(unnest(string_to_array(substring(line, 'bags contain (.*)\.'), ', ')), '(\d+ .*) bags?') containee
from day7_bags_raw),
amount_rules as (
  select
	container,
	substring(containee, ('\d+')) times,
	substring(containee, ('\d+ (.*)')) bag
  from rules
),
containments as(
select container, times::int, bag from amount_rules where container = 'shiny gold'
union all
select c.container, c.times * r.times::int, r.bag from containments c, amount_rules r
	where r.container = c.bag
)

select sum(times) from containments

"