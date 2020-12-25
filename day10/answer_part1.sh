#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
select
	((select count(*) from (select (select min(rating) from day10_ratings where rating > r.rating) - rating as rating from day10_ratings r) x where x.rating = 1) + 1)
  * ((select count(*) from (select (select min(rating) from day10_ratings where rating > r.rating) - rating as rating from day10_ratings r) x where x.rating = 3) + 1)
"
