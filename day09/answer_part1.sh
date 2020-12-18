#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
select * from (
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
limit 1
"
