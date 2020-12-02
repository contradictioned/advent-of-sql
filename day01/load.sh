#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day1_expenses;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day1_expenses(expense int);"
psql -U $USER -d $DATABASE -c "\copy day1_expenses(expense) FROM '`pwd`/input.txt';"

