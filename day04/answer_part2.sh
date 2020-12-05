#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "

truncate day4_passports_fields;

insert into day4_passports_fields 
with recursive combined_passports(ids, concat) as
(
  select ARRAY[o.id], o.line from day4_raw_passports o
  where
    o.id = 1 or (select line from day4_raw_passports i where i.id = o.id - 1) = ''
union
  select array_append(c.ids, p.id), c.concat || ' ' || p.line
  from combined_passports c, day4_raw_passports p
  where
  	p.id = c.ids[array_upper(c.ids,1)] + 1 and
	p.line != ''
)

select concat raw_fields from combined_passports o
where not exists (select * from combined_passports i where o.ids[1] = i.ids[1] and array_upper(i.ids, 1) > array_upper(o.ids, 1));

update day4_passports_fields set byr = substring(raw, 'byr:(\S*)');
update day4_passports_fields set iyr = substring(raw, 'iyr:(\S*)');
update day4_passports_fields set eyr = substring(raw, 'eyr:(\S*)');
update day4_passports_fields set hgt = substring(raw, 'hgt:(\S*)');
update day4_passports_fields set hcl = substring(raw, 'hcl:(\S*)');
update day4_passports_fields set ecl = substring(raw, 'ecl:(\S*)');
update day4_passports_fields set pid = substring(raw, 'pid:(\S*)');
update day4_passports_fields set cid = substring(raw, 'cid:(\S*)');


select count(*) from day4_passports_fields
where
    byr is not null and byr similar to '\d{4}' and byr::int between 1920 and 2002 and -- byr (Birth Year) - four digits; at least 1920 and at most 2002.
    iyr is not null and byr similar to '\d{4}' and iyr::int between 2010 and 2020 and -- iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    eyr is not null and byr similar to '\d{4}' and eyr::int between 2020 and 2030 and -- eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    hgt is not null and (
	  (hgt similar to '\d+in' and substring(hgt, '\d+')::int between 59 and 76) or
	  (hgt similar to '\d+cm' and substring(hgt, '\d+')::int between 150 and 193)
	) and
    hcl is not null and hcl similar to '#(\d|a|b|c|d|e|f|){6}' and -- a # followed by exactly six characters 0-9 or a-f.
    ecl is not null and ecl in ('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth') and -- exactly one of: amb blu brn gry grn hzl oth.
    pid is not null and pid similar to '\d{9}'; --  a nine-digit number, including leading zeroes.
"
