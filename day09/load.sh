#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day9_numbers;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day9_numbers(position serial, number bigint);"
psql -U $USER -d $DATABASE -c "\copy day9_numbers(number) FROM '`pwd`/input.txt';"
