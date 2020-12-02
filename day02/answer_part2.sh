#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
select count(*)
from day2_passwords
where (substring(password from pmin for 1) = letter
  and substring(password from pmax for 1) != letter)
  or (substring(password from pmin for 1) != letter
  and substring(password from pmax for 1) = letter)
"

