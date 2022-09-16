%macro output_grad_rate_stu ( dsn_in = , file_out = ); 

proc sql;
create table output_grad_stu as
select id, nyssis_id, school_beds, school_name,
		substr(membership_desc,21,6) as cohort,
		strip(group_ethnic) || "; " || strip(group_lep)  || "; " || strip(group_swd)  || "; " || strip(group_econ) as acct_subgroups,
		"yes" as HSE_earned
from &dsn_in
where grad_cohort_member = 1 and (diploma_type = 'High School Equivalency (HSE) Diploma' or grad_discharge = '30');
quit;

%mend;

/*
NYSSIS ID	BEDS Code	School Name	Cohort (4,5,6 Yr)	Acct. Subgroup (Report all subgroups the student belongs too)	HSE Earned (Yes)
