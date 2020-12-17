#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day7_bags_raw;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day7_bags_raw(line varchar);"
psql -U $USER -d $DATABASE -c "\copy day7_bags_raw(line) FROM '`pwd`/input.txt' ;"
