#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "DROP TABLE IF EXISTS day2_passwords;"
psql -U $USER -d $DATABASE -c "CREATE TABLE IF NOT EXISTS day2_passwords(policy varchar, password varchar, pmin int, pmax int, letter char);"
psql -U $USER -d $DATABASE -c "\copy day2_passwords(policy, password) FROM '`pwd`/input.txt' delimiter ':';"
psql -U $USER -d $DATABASE -c "UPDATE day2_passwords SET password = trim(password), pmin = substring(policy from '(\d+)-')::int, pmax = substring(policy from '-(\d+)')::int, letter = substring(policy from ' (.)');"
