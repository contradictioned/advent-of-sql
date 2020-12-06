#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day6_customs;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day6_customs(id serial, line varchar);"
psql -U $USER -d $DATABASE -c "\copy day6_customs(line) FROM '`pwd`/input.txt' ;"
