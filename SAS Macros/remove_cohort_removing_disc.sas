%macro remove_cohort_removing_disc 	(dsn_in = , dsn_out = );

proc sql;
create table all_discharges as
select t1.id, coalesce(t1.grad_dbn, t1.alt_cohort_dbn) as acc_dbn, t2.dbn as disc_dbn, t1.grad_discharge, datepart(t2.disc_date) as disc_date format mmddyy10.,
t2.disc_code, t2.disc_document_code, t3.dbn as transfer_dbn
from &dsn_in as t1
	inner join spr_int.raw_biog_prog_union as t2
	on t1.id = t2.id and 
		mdy(9, 1, %eval(&current_year - 3)) <= datepart(t2.disc_date) <= mdy(6, 30, %eval(&current_year))
	left join spr_int.raw_biog_prog_union as t3 
	on t2.id = t3.id and datepart(t2.disc_date) = datepart(t3.admission_date) and t2.dbn ^= t3.dbn;
quit;

proc sql;
create table discharges_with_school_type as
select t1.*, t2.univ_flag as ndpl
from all_discharges as t1
	left join spr_int.raw_nondiploma_granting_school as t2
	on t1.transfer_dbn = t2.dbn;
quit;

data discharge_evaluation;
set discharges_with_school_type;
/* non-public transfer, deceased, incarceration without DOE program */
if disc_code in ('08','15','10') then cohort_removing = 1;

/* transfer outside NYC with documentation */
if disc_code = '11' and disc_document_code ^= 'X' then cohort_removing = 1;

/* transfer to diploma-granting public school in NYC */
if transfer_dbn ^= ' ' and ndpl ^= 'NDPL' and transfer_dbn ^= acc_dbn then cohort_removing = 1;

/* DOE incarceration programs */ 
if transfer_dbn in ('79X695', '79Q344', '79M921', '79M973') then cohort_removing = 1;

/* transfer to state approved HSE program and no HSE earned */ 
if transfer_dbn in ('79Q950', '79M331') and grad_discharge ^= '30' then cohort_removing = 1;

/* a grad discharge itself can never be cohort-removing */
if disc_code in ('26','27','28','30','47','62') then cohort_removing = .; 

run;

proc sql;
create table cohort_removing_discharges as
select distinct id, cohort_removing
from discharge_evaluation
where cohort_removing = 1;
quit;

proc sql;
create table stu_with_cohort_removing as
select t1.*, t2.cohort_removing
from &dsn_in as t1
	left join cohort_removing_discharges as t2
	on t1.id = t2.id;
quit;

data &dsn_out;
set stu_with_cohort_removing;
if cohort_removing = 1 then alt_cohort_member = .;
if alt_cohort_member = . and grad_cohort_member = . then delete;
run;

%mend;
