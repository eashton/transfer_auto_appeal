%macro calculate_grad_rates_by_subgroup (dsn_out = , dsn_in = ); 

data grad_input_stu;
set &dsn_in;
where grad_cohort_member = 1;
if grad_discharge ^= ' ' or diploma_type ^= ' ' then grad_pts = 1;
run;

proc sql;
create table grad_sch_all_subgroups as

select 	dbn, 
		'All Students' as subgroup_all, 
		membership_desc, 
		sum(grad_pts) as grad_numerator,
		sum(grad_cohort_member) as grad_denominator,
		sum(grad_pts) / sum(grad_cohort_member) format percent10.1 as grad_rate
from grad_input_stu
group by 1, 2, 3

union all 

select 	dbn, 
		group_ethnic as subgroup_all, 
		membership_desc, 
		sum(grad_pts) as grad_numerator,
		sum(grad_cohort_member) as grad_denominator,
		sum(grad_pts) / sum(grad_cohort_member) format percent10.1 as grad_rate
from grad_input_stu
group by 1, 2, 3

union all 

select 	dbn, 
		group_econ as subgroup_all, 
		membership_desc, 
		sum(grad_pts) as grad_numerator,
		sum(grad_cohort_member) as grad_denominator,
		sum(grad_pts) / sum(grad_cohort_member) format percent10.1 as grad_rate
from grad_input_stu
where group_econ ^= ' ' 
group by 1, 2, 3


union all 

select 	dbn, 
		group_swd as subgroup_all, 
		membership_desc, 
		sum(grad_pts) as grad_numerator,
		sum(grad_cohort_member) as grad_denominator,
		sum(grad_pts) / sum(grad_cohort_member) format percent10.1 as grad_rate
from grad_input_stu
where group_swd ^= ' ' 
group by 1, 2, 3


union all 

select 	dbn, 
		group_lep as subgroup_all, 
		membership_desc, 
		sum(grad_pts) as grad_numerator,
		sum(grad_cohort_member) as grad_denominator,
		sum(grad_pts) / sum(grad_cohort_member) format percent10.1 as grad_rate
from grad_input_stu
where group_lep ^= ' ' 
group by 1, 2, 3
;
quit;

proc sql;
create table include_former_swd_data as
select dbn, subgroup_all, membership_desc, grad_denominator,
		case when grad_denominator >= 30 then 1 else . end as include_former_swd
from Grad_sch_all_subgroups
where subgroup_all = 'Students with Disabilities';
quit;

proc sql;
create table include_former_lep_data as
select t1.dbn, t1.subgroup_all, t1.membership_desc, t1.grad_denominator as current_n,
		t2.grad_denominator as former_n,
		case when t2.grad_denominator < t1.grad_denominator then 1 else . end as include_former_lep
from Grad_sch_all_subgroups as t1
	inner join Grad_sch_all_subgroups as t2
	on t1.subgroup_all = 'Limited English Proficient' and
	t2.subgroup_all = 'Former LEP' and
	t1.dbn = t2.dbn and 
	t1.membership_desc = t2.membership_desc
;
quit;

proc sql; 
create table all_subgrous_with_include_flags as
select  t1.*, t2.include_former_swd, t3.include_former_lep 
from Grad_sch_all_subgroups as t1
	left join include_former_swd_data as t2
	on t1.dbn = t2.dbn and t1.membership_desc = t2.membership_desc
	left join include_former_lep_data as t3
	on t1.dbn = t3.dbn and t1.membership_desc = t3.membership_desc;
quit;

data subgroups_with_supergroups;
set all_subgrous_with_include_flags;
supergroup = subgroup_all;
if subgroup_all = 'Former SWD' then do;
	supergroup = 'Students with Disabilities';
	if include_former_swd = . then do;
		grad_denominator = 0;
		grad_numerator = 0;
		end;
	end;
if subgroup_all = 'Former LEP' then do;
	supergroup = 'Limited English Proficient';
	if include_former_lep = . then do;
		grad_denominator = 0;
		grad_numerator = 0;
		end;
	end;
run;

proc sql;
create table &dsn_out as
select dbn, supergroup, membership_desc,
		sum(grad_numerator) as grad_numerator,
		sum(grad_denominator) as grad_denominator,
		sum(grad_numerator) / sum(grad_denominator) as grad_rate format percent10.1
from subgroups_with_supergroups
group by 1,2, 3;
quit;

%mend;

