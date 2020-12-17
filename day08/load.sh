#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day8_instructions;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day8_instructions(pc serial, instr varchar, arg int);"
psql -U $USER -d $DATABASE -c "\copy day8_instructions(instr, arg) FROM '`pwd`/input.txt' delimiter ' ';"
