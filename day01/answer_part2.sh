#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
select e1.expense * e2.expense * e3.expense
from day1_expenses e1, day1_expenses e2, day1_expenses e3
where e1.expense < e2.expense and e2.expense < e3.expense
  and e1.expense + e2.expense + e3.expense = 2020
  and e1.expense + e2.expense <= 2020
  and e1.expense + e3.expense <= 2020
  and e2.expense + e3.expense <= 2020
"

