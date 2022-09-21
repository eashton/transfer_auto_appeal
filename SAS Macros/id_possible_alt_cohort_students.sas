%macro id_possible_alt_cohort_students 	(dsn_out = );

proc sql;
create table all_admits_in_year1 as
select t1.id, t1.dbn, datepart(t1.admission_date) format mmddyy10. as admission_date
from spr_int.raw_biog_prog_union as t1
	inner join hst.school_list as t2
	on t1.dbn = t2.dbn
where mdy(7, 1, %eval(&current_year - 3)) <= datepart(t1.admission_date) <= mdy(6, 30, %eval(&current_year - 2));
quit;

proc sql;
create table all_admits_anytime as
select t1.id, t1.dbn, datepart(t2.admission_date) format mmddyy10. as admission_date
from all_admits_in_year1 as t1
	inner join spr_int.raw_biog_prog_union as t2
	on t1.id = t2.id and t1.dbn = t2.dbn
order by id, dbn, admission_date desc;
quit;

proc sort data = all_admits_anytime out = earliest_admit nodupkey;
by id;
run; 


data earliest_admit_in_year1;
set earliest_admit;
drop dbn admission_date;
alt_cohort_dbn = dbn;
format alt_cohort_admit_date mmddyy10.;
alt_cohort_admit_date = admission_date;
if admission_date < mdy(7, 1, %eval(&current_year - 3)) then delete;
alt_cohort_member = 1;
run;

proc sql;
create table int_all_stu_w_alt as
select coalesce (t1.id, put(t2.local_id, 9.)) as id, t2.dbn as grad_dbn,  *
from earliest_admit_in_year1 as t1 
	full outer join hst.Tc_data_from_nysed_w_dbn as t2
	on t1.id = put(t2.local_id, 9.)
order by id;
quit;

proc sql;
create table &dsn_out as
select coalesce (input(t1.nyssis_id, best.), t2.nyssis_id) as nyssis_id, *
from int_all_stu_w_alt as t1 
	left join hst.nysis_osis_crosswalk as t2
	on input(t1.id, best.) = t2.student_id;
quit;

data &dsn_out;
set &dsn_out;
if school_name = 'NEW VISIONS AIM CHARTER HS I' then grad_dbn = '84K395';
if school_name = 'URBAN DOVE TEAM CHARTER SCHOOL' then grad_dbn = '84K417';
run;


%mend;
