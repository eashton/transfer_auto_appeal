%macro add_graduation_data 	(dsn_in = , dsn_out = );

proc sql;
create table all_graduation_discharges as
select t1.id, datepart(t2.disc_date) as disc_date format mmddyy10., t2.disc_code
from &dsn_in as t1
	inner join spr_int.raw_biog_prog_union as t2
	on t1.id = t2.id and t2.disc_code in ('26','27','28','30','47','62') and datepart(disc_date) <= &current_FDOS
order by id, disc_date desc;
quit;

proc sort data = all_graduation_discharges out = latest_grad_discharge nodupkey;
by id;
run;

proc sql;
create table &dsn_out as
select t1.*, t2.disc_code as grad_discharge
from &dsn_in as t1
	left join latest_grad_discharge as t2
	on t1.id = t2.id;
quit;

%mend;
