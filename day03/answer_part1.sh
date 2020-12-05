#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
select count(*) from (
	select
	  id, line, ((id-1)*3 % char_length(line)) + 1,
	  substring(line from (((id-1)*3 % char_length(line)) + 1) for 1) pos
	from day3_piste
	order by id
) x
where pos = '#'
"

