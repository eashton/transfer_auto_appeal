%macro create_school_list	(dsn_out = );

proc sql;
create table &dsn_out as
select distinct t1.school_beds, t1.school_name, t3.dbn
from hst.tc_data_from_nysed as t1
	left join oadm_int.location_supertable1 as t2
	on t1.school_beds = t2.system_code and t2.system_id = 'BEDS' and t2.fiscal_year = "&current_year."
	left join spr_int.extract_school_data as t3
	on t2.location_code = t3.bn and t3. year = &current_year.
order by dbn;
quit;

proc sql;
create table hst.tc_data_from_nysed_w_dbn as
select 1 as grad_cohort_member, *
from &dsn_out as t1
	left join hst.Tc_data_from_nysed as t2
	on t1.school_beds = t2.school_beds;
quit;

data &dsn_out;
set &dsn_out;
if school_name = 'NEW VISIONS AIM CHARTER HS I' then dbn = '84K395';
if school_name = 'URBAN DOVE TEAM CHARTER SCHOOL' then dbn = '84K417';
run

%mend;
