#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
with recursive rules as
(select
  substring(line, '(.*) bags contain') container,
  substring(unnest(string_to_array(substring(line, 'bags contain (.*)\.'), ', ')), '\d+ (.*) bags?') containee
from day7_bags_raw),
containments as(
select container, containee from rules where containee = 'shiny gold'
union all
select r.container, c.containee from containments c, rules r
	where r.containee = c.container
)

select count(distinct container) from containments;
"
