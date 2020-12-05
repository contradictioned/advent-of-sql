#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "

create or replace function decode_row(varchar) returns int as \$\$
  select replace(
	  replace(
	  	substring(\$1 from 1 for 7),
		'F', '0'),
	  'B', '1')::bit(7)::integer
\$\$ language SQL;

create or replace function decode_column(varchar) returns int as \$\$
  select replace(
	  replace(
	  	substring(\$1 from 8 for 3),
		'L', '0'),
	  'R', '1')::bit(3)::integer
\$\$ language SQL;

create or replace function seat_id(day5_seats) returns int as \$\$
  select decode_row(\$1.line) * 8 + decode_column(\$1.line)
\$\$ language SQL;

select seat_id(predecessor) + 1
from day5_seats predecessor
where not exists(
	select * from day5_seats myone where seat_id(myone) = seat_id(predecessor) + 1
) and exists (
	select * from day5_seats successor where seat_id(successor) = seat_id(predecessor) + 2
)
"