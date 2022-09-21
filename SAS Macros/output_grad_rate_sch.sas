%macro output_grad_rate_sch ( dsn_in = ); 

proc sql;
create table school_subgroup_list as
select 	distinct 	t1.dbn,
					t1.school_beds as beds,
					t1.school_name,
					t2.supergroup as acct_subgroup
from hst.school_list as t1
	left join &dsn_in as t2
	on t1.dbn = t2.dbn;
quit;

proc sql;
create table hst.output_grad_sch as
select 		t1.*, 
			y4.grad_denominator as denominator_4ygr,
			y4.grad_numerator as numerator_4ygr,
			y4.grad_rate as grad_rate_y4,
			y5.grad_denominator as denominator_5ygr,
			y5.grad_numerator as numerator_5ygr,
			y5.grad_rate as grad_rate_y5,
			y6.grad_denominator as denominator_6ygr,
			y6.grad_numerator as numerator_6ygr,
			y6.grad_rate as grad_rate_y6
from school_subgroup_list as t1
	left join &dsn_in as y4
	on t1.dbn = y4.dbn and t1.acct_subgroup = y4.supergroup and y4.MEMBERSHIP_DESC = '2018 Total Cohort - 4 Year Outcome'
	left join &dsn_in as y5
	on t1.dbn = y5.dbn and t1.acct_subgroup = y5.supergroup and y5.MEMBERSHIP_DESC = '2017 Total Cohort - 5 Year Outcome'
	left join &dsn_in as y6
	on t1.dbn = y6.dbn and t1.acct_subgroup = y6.supergroup and y6.MEMBERSHIP_DESC = '2016 Total Cohort - 6 Year Outcome'
order by beds, acct_subgroup;
quit;

	

%mend;
