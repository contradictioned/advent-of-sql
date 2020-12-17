#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
create or replace function next_instr(pc int, instr varchar, arg int) returns int as \$\$
  select \$1 + (case when \$2 = 'jmp' then \$3 else 1 end)
\$\$ language SQL;

with recursive run as(
  select pc, instr, arg, next_instr(pc, instr, arg)
  from day8_instructions
  where pc=1
  
  union
  
  select i.pc, i.instr, i.arg, next_instr(i.pc, i.instr, i.arg)
  from run r, day8_instructions i
	  where i.pc = next_instr(r.pc, r.instr, r.arg)
)
select sum(arg)
from run
where instr = 'acc'
"
