#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day10_ratings;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day10_ratings(rating int);"
psql -U $USER -d $DATABASE -c "\copy day10_ratings(rating) FROM '`pwd`/input.txt';"
