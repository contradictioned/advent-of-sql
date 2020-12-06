#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
with recursive customs_groups(ids, common, all_answers) as
(
  select ARRAY[o.id], string_to_array(o.line, NULL), o.line from day6_customs o
  where
    o.id = 1 or (select line from day6_customs i where i.id = o.id - 1) = ''
union
  select array_append(c.ids, p.id), ARRAY(select unnest(c.common) intersect select unnest(string_to_array(p.line, NULL))), c.all_answers || ' ' || p.line
  from customs_groups c, day6_customs p
  where
  	p.id = c.ids[array_upper(c.ids,1)] + 1 and
	p.line != ''
)

select sum(array_upper(o.common, 1)) from customs_groups o
where not exists (select * from customs_groups i where o.ids[1] = i.ids[1] and array_upper(i.ids, 1) > array_upper(o.ids, 1))
"