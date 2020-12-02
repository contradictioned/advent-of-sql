#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "select e1.expense * e2.expense from day1_expenses e1, day1_expenses e2 where e1.expense < e2.expense and e1.expense + e2.expense = 2020;"

