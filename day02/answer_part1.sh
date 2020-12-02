#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
select count(*)
from day2_passwords
where char_length(regexp_replace(password, '[^'||letter||']', '', 'g')) >= pmin
  and char_length(regexp_replace(password, '[^'||letter||']', '', 'g')) <= pmax
"

