#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day5_seats;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day5_seats(line varchar);"
psql -U $USER -d $DATABASE -c "\copy day5_seats(line) FROM '`pwd`/input.txt' ;"
