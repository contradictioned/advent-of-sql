#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day4_raw_passports;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day4_raw_passports(id serial, line varchar);"
psql -U $USER -d $DATABASE -c "\copy day4_raw_passports(line) FROM '`pwd`/input.txt' ;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day4_passports_fields(raw varchar, byr varchar, iyr varchar, eyr varchar, hgt varchar, hcl varchar, ecl varchar, pid varchar, cid varchar);"
