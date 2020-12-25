#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
drop table if exists day10_counted_ratings;
create table day10_counted_ratings as select rating, NULL::bigint count from day10_ratings;

create or replace function adapter_combos() returns bigint as \$\$
declare
  next_rating int;
  new_count bigint;
begin
  insert into day10_counted_ratings(rating, count) values (0,1);
  next_rating := (select min(rating) from day10_counted_ratings where count is null);
  
  while next_rating is not null loop
    new_count := (select sum(count) from day10_counted_ratings where rating between next_rating - 3 and next_rating - 1);
    update day10_counted_ratings r set count = new_count where r.rating = next_rating;
    next_rating := (select min(rating) from day10_counted_ratings where count is null);
  end loop;
  
  return (select count from day10_counted_ratings order by rating desc limit 1);
end;
\$\$ language plpgsql;

select adapter_combos();
"
