%macro output_pi_stu ( dsn_in = , file_out = ); 

proc sql;
create table hst.output_grad_stu as
select  id, "2019:2021-22" as alt_cohort_year,
		t2.school_beds, t2.school_name, nyssis_id,  
		strip(group_ethnic) || "; " || strip(group_lep)  || "; " || strip(group_swd)  || "; " || strip(group_econ) as acct_subgroups,
		ELA, MTH, SCI, SOC
from &dsn_in as t1
	inner join hst.school_list as t2
	on t1.alt_cohort_dbn = t2.dbn
where alt_cohort_member = 1
order by school_beds, nyssis_id;
quit;

/* Alternative Cohort Year: School Year	BEDS Code	School Name	NYSSIS ID	Acct. Subgroup (Report all subgroups the student belongs too)	ELA Level	Math Level	Science Level	Social Studies Level
*/

%mend;
