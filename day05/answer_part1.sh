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

select max (decode_row(line) * 8 + decode_column(line)) from day5_seats
"
