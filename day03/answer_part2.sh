#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
create or replace function slope(int, int) RETURNS bigint AS \$\$
	select count(*) from (
		select
		  id,
		  (id-1) % \$2 = 0,
		  line,
		  ((id-1)*\$1/\$2 % char_length(line)) + 1,
		  substring(line from (((id-1)*\$1/\$2 % char_length(line)) + 1) for 1) pos
		from day3_piste
  		where (id-1) % \$2 = 0
		order by id
	) x
 	where pos = '#'
\$\$ LANGUAGE SQL;

select slope(1,1) * slope(3,1) * slope(5,1) * slope(7,1) * slope(1,2)
"