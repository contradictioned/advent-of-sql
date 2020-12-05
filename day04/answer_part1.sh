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
    byr is not null and
    iyr is not null and
    eyr is not null and
    hgt is not null and
    hcl is not null and
    ecl is not null and
    pid is not null;
"

