#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day3_piste;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day3_piste(id serial, line varchar);"
psql -U $USER -d $DATABASE -c "\copy day3_piste(line) FROM '`pwd`/input.txt';"

