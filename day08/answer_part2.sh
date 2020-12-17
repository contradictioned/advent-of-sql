#!/bin/sh

source ../vars

psql -U $USER -d $DATABASE -c "
create or replace function next_instr(pc int, instr varchar, arg int) returns int as \$\$
  select \$1 + (case when \$2 = 'jmp' then \$3 else 1 end)
\$\$ language SQL;

create or replace function swapped_instr(current_pc int, swap_pc int, instr varchar) returns varchar as \$\$
  select case when current_pc = swap_pc and instr = 'jmp' then 'nop'
              when current_pc = swap_pc and instr = 'nop' then 'jmp'
			  else instr end
\$\$ language SQL;

create or replace function holds(swap_pc int) returns bool as \$\$
with recursive run as (
select pc, swapped_instr(pc, \$1, instr) instr, arg, next_instr(pc, swapped_instr(pc, \$1, instr), arg) from day8_instructions where pc=1
union
select i.pc, swapped_instr(i.pc, \$1, i.instr), i.arg, next_instr(i.pc, swapped_instr(i.pc, \$1, i.instr), i.arg) from run r, day8_instructions i
	  where i.pc = next_instr(r.pc, r.instr, r.arg)
)
select true from run where next_instr = (select max(pc)+1 from day8_instructions)
\$\$ language SQL;

create or replace function final_acc(swap_pc int) returns int as \$\$
with recursive run as(
  select pc, swapped_instr(pc, \$1, instr) instr, arg, next_instr(pc, swapped_instr(pc, \$1, instr), arg)
  from day8_instructions
  where pc=1
  
  union
  
  select i.pc, swapped_instr(i.pc, \$1, i.instr), i.arg, next_instr(i.pc, swapped_instr(i.pc, \$1, i.instr), i.arg)
  from run r, day8_instructions i
	  where i.pc = next_instr(r.pc, r.instr, r.arg)
)
select sum(arg)
from run
where instr = 'acc'
\$\$ language SQL;

select holds(s), final_acc(s)
from generate_series(1, (select max(pc) from day8_instructions)) s
where holds(s)
"