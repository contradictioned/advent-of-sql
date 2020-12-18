#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
create or replace function invalid_number() returns bigint as \$\$
select number from (
	select position, number from day9_numbers where position >= 26
	except
	select nsum.position, nsum.number
	from day9_numbers n1, day9_numbers n2, day9_numbers nsum
	where nsum.position >= 26
	  and n1.position between nsum.position - 26 and nsum.position -1
	  and n2.position between nsum.position - 26 and nsum.position -1
	  and n1.position < n2.position
	  and n1.number + n2.number = nsum.number
) x
order by position
limit 1;
\$\$ language SQL;

with recursive count_up as (
select position, 1 length, number sum, i from day9_numbers, invalid_number() i
union
select c.position, c.length + 1, c.sum + d.number, i
from day9_numbers d, count_up c
where d.position = c.position + c.length
  and c.sum + d.number <= i
)
select min(d.number) + max(d.number)
from count_up c, day9_numbers d
where c.sum = c.i and c.length > 1 and d.position between c.position and c.position + c.length - 1
"



# drop function if exists invalid_number();
# create or replace function invalid_number() returns bigint as $$
# select number from (
# 	select position, number from day9_numbers where position >= 26
# 	except
# 	select nsum.position, nsum.number
# 	from day9_numbers n1, day9_numbers n2, day9_numbers nsum
# 	where nsum.position >= 26
# 	  and n1.position between nsum.position - 26 and nsum.position -1
# 	  and n2.position between nsum.position - 26 and nsum.position -1
# 	  and n1.position < n2.position
# 	  and n1.number + n2.number = nsum.number
# ) x
# order by position
# limit 1;
# $$ language SQL;

# select invalid_number()

# select range_start, range_end
# from  day9_numbers num,
# generate_series(1, (select count(*) from day9_numbers)) range_start,
# generate_series(1, (select count(*) from day9_numbers)) range_end
# where range_start < range_end
#   and num.position between range_start and range_end
# group by range_start, range_end
# having sum(num.number) = invalid_number()