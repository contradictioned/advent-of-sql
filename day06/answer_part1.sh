#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
with recursive customs_groups(ids, answered) as
(
  select ARRAY[o.id], o.line from day6_customs o
  where
    o.id = 1 or (select line from day6_customs i where i.id = o.id - 1) = ''
union
  select array_append(c.ids, p.id), c.answered || ' ' || p.line
  from customs_groups c, day6_customs p
  where
  	p.id = c.ids[array_upper(c.ids,1)] + 1 and
	p.line != ''
)

select sum(unique_choices) from (
	select id, count(distinct choices) unique_choices from (
		select o.ids[1] id, unnest(string_to_array(replace(answered, ' ', ''), NULL)) choices from customs_groups o
		where not exists (select * from customs_groups i where o.ids[1] = i.ids[1] and array_upper(i.ids, 1) > array_upper(o.ids, 1))
	) x
	group by id
) y
"
