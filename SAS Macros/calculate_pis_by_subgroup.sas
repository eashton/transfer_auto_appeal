%macro calculate_pis_by_subgroup (dsn_out = , dsn_in = ); 

data pi_stu_with_points; 
set &dsn_in; 
where alt_cohort_member = 1 and alt_cohort_dbn ^= ' ';
if ELA = 1 then ELA_pts = 0;
if ELA = 2 then ELA_pts = 100;
if ELA = 3 then ELA_pts = 200;
if ELA = 4 then ELA_pts = 250;
if MTH = 1 then MTH_pts = 0;
if MTH = 2 then MTH_pts = 100;
if MTH = 3 then MTH_pts = 200;
if MTH = 4 then MTH_pts = 250;
if SCI = 1 then SCI_pts = 0;
if SCI = 2 then SCI_pts = 100;
if SCI = 3 then SCI_pts = 200;
if SCI = 4 then SCI_pts = 250;
if SOC = 1 then SOC_pts = 0;
if SOC = 2 then SOC_pts = 100;
if SOC = 3 then SOC_pts = 200;
if SOC = 4 then SOC_pts = 250;
run;

proc sql;
create table pi_school_all_subgroups as

select 	alt_cohort_dbn, 
		'All Students' as subgroup_all,
		sum(ELA = 1) as ELA_1,
		sum(ELA = 2) as ELA_2,
		sum(ELA = 3) as ELA_3,
		sum(ELA = 4) as ELA_4,
		sum(MTH = 1) as MTH_1,
		sum(MTH = 2) as MTH_2,
		sum(MTH = 3) as MTH_3,
		sum(MTH = 4) as MTH_4,
		sum(SCI = 1) as SCI_1,
		sum(SCI = 2) as SCI_2,
		sum(SCI = 3) as SCI_3,
		sum(SCI = 4) as SCI_4,
		sum(SOC = 1) as SOC_1,
		sum(SOC = 2) as SOC_2,
		sum(SOC = 3) as SOC_3,
		sum(SOC = 4) as SOC_4
from pi_stu_with_points
group by 1, 2

union all 

select 	alt_cohort_dbn, 
		group_ethnic as subgroup_all, 
		count(ELA) as ELA_total_members ,
		sum(ELA = 1) as ELA_1,
		sum(ELA = 2) as ELA_2,
		sum(ELA = 3) as ELA_3,
		sum(ELA = 4) as ELA_4,
		sum(MTH = 1) as MTH_1,
		sum(MTH = 2) as MTH_2,
		sum(MTH = 3) as MTH_3,
		sum(MTH = 4) as MTH_4,
		sum(SCI = 1) as SCI_1,
		sum(SCI = 2) as SCI_2,
		sum(SCI = 3) as SCI_3,
		sum(SCI = 4) as SCI_4,
		sum(SOC = 1) as SOC_1,
		sum(SOC = 2) as SOC_2,
		sum(SOC = 3) as SOC_3,
		sum(SOC = 4) as SOC_4
from pi_stu_with_points
group by 1, 2

union all 

select 	alt_cohort_dbn, 
		group_econ as subgroup_all, 
		sum(ELA = 1) as ELA_1,
		sum(ELA = 2) as ELA_2,
		sum(ELA = 3) as ELA_3,
		sum(ELA = 4) as ELA_4,
		sum(MTH = 1) as MTH_1,
		sum(MTH = 2) as MTH_2,
		sum(MTH = 3) as MTH_3,
		sum(MTH = 4) as MTH_4,
		sum(SCI = 1) as SCI_1,
		sum(SCI = 2) as SCI_2,
		sum(SCI = 3) as SCI_3,
		sum(SCI = 4) as SCI_4,
		sum(SOC = 1) as SOC_1,
		sum(SOC = 2) as SOC_2,
		sum(SOC = 3) as SOC_3,
		sum(SOC = 4) as SOC_4
from pi_stu_with_points
where group_econ ^= ' '
group by 1, 2


union all 

select 	alt_cohort_dbn, 
		group_swd as subgroup_all, 
		sum(ELA = 1) as ELA_1,
		sum(ELA = 2) as ELA_2,
		sum(ELA = 3) as ELA_3,
		sum(ELA = 4) as ELA_4,
		sum(MTH = 1) as MTH_1,
		sum(MTH = 2) as MTH_2,
		sum(MTH = 3) as MTH_3,
		sum(MTH = 4) as MTH_4,
		sum(SCI = 1) as SCI_1,
		sum(SCI = 2) as SCI_2,
		sum(SCI = 3) as SCI_3,
		sum(SCI = 4) as SCI_4,
		sum(SOC = 1) as SOC_1,
		sum(SOC = 2) as SOC_2,
		sum(SOC = 3) as SOC_3,
		sum(SOC = 4) as SOC_4
from pi_stu_with_points
where group_swd ^= ' '
group by 1, 2


union all 

select 	alt_cohort_dbn, 
		group_lep as subgroup_all, 
		sum(ELA = 1) as ELA_1,
		sum(ELA = 2) as ELA_2,
		sum(ELA = 3) as ELA_3,
		sum(ELA = 4) as ELA_4,
		sum(MTH = 1) as MTH_1,
		sum(MTH = 2) as MTH_2,
		sum(MTH = 3) as MTH_3,
		sum(MTH = 4) as MTH_4,
		sum(SCI = 1) as SCI_1,
		sum(SCI = 2) as SCI_2,
		sum(SCI = 3) as SCI_3,
		sum(SCI = 4) as SCI_4,
		sum(SOC = 1) as SOC_1,
		sum(SOC = 2) as SOC_2,
		sum(SOC = 3) as SOC_3,
		sum(SOC = 4) as SOC_4
from pi_stu_with_points
where group_lep ^= ' '
group by 1, 2

;
quit;

proc sql;
create table include_former_swd_data_pi as
select alt_cohort_dbn, subgroup_all, 
		case when (ELA_1+ELA_2+ELA_3+ELA_4) >= 30 then 1 else . end as inc_former_swd_ELA,
		case when (MTH_1+MTH_2+MTH_3+MTH_4) >= 30 then 1 else . end as inc_former_swd_MTH,
		case when (SCI_1+SCI_2+SCI_3+SCI_4) >= 30 then 1 else . end as inc_former_swd_SCI,
		case when (SOC_1+SOC_2+SOC_3+SOC_4) >= 30 then 1 else . end as inc_former_swd_SOC,
		(ELA_1+ELA_2+ELA_3+ELA_4) as ela_swd_n
from Pi_school_all_subgroups
where subgroup_all = 'Students with Disabilities';
quit;

proc sql;
create table include_former_lep_data_pi as
select t1.alt_cohort_dbn, t1.subgroup_all, 
		case when (t2.ELA_1+t2.ELA_2+t2.ELA_3+t2.ELA_4) < (t1.ELA_1+t1.ELA_2+t1.ELA_3+t1.ELA_4)  then 1 else . end as inc_former_lep_ELA,
		case when (t2.MTH_1+t2.MTH_2+t2.MTH_3+t2.MTH_4) < (t1.MTH_1+t1.MTH_2+t1.MTH_3+t1.MTH_4) then 1 else . end as inc_former_lep_MTH,
		case when (t2.SCI_1+t2.SCI_2+t2.SCI_3+t2.SCI_4) < (t1.SCI_1+t1.SCI_2+t1.SCI_3+t1.SCI_4)  then 1 else . end as inc_former_lep_SCI,
		case when (t2.SOC_1+t2.SOC_2+t2.SOC_3+t2.SOC_4) < (t1.SOC_1+t1.SOC_2+t1.SOC_3+t1.SOC_4) then 1 else . end as inc_former_lep_SOC,
		(t2.ELA_1+t2.ELA_2+t2.ELA_3+t2.ELA_4) as ela_former_n,
		(t1.ELA_1+t1.ELA_2+t1.ELA_3+t1.ELA_4) as ela_current_n
from Pi_school_all_subgroups as t1
	inner join Pi_school_all_subgroups as t2
	on t1.subgroup_all = 'Limited English Proficient' and
	t2.subgroup_all = 'Former LEP' and
	t1.alt_cohort_dbn = t2.alt_cohort_dbn ;
quit;

proc sql; 
create table pi_all_sub_with_include_flags as
select  t1.*, t2.inc_former_lep_ELA, t2.inc_former_lep_MTH, t2.inc_former_lep_SCI, t2.inc_former_lep_SOC,
			inc_former_swd_ELA, inc_former_swd_MTH, inc_former_swd_SCI, inc_former_swd_SOC
from pi_school_all_subgroups as t1
	left join include_former_lep_data_pi as t2
	on t1.alt_cohort_dbn = t2.alt_cohort_dbn
	left join include_former_swd_data_pi as t3
	on t1.alt_cohort_dbn = t3.alt_cohort_dbn;
quit;

data pi_subgroups_with_super_v01;
set pi_all_sub_with_include_flags;
supergroup = subgroup_all;
if subgroup_all = 'Former LEP' then do;
	supergroup = 'Limited English Proficient';
	if inc_former_lep_ELA = . then do;
		ELA_numerator = 0;
		ELA_denominator = 0;
		end;
	if inc_former_lep_MTH = . then do;
		MTH_numerator = 0;
		MTH_denominator = 0;
		end;
	if inc_former_lep_SOC = . then do;
		SOC_numerator = 0;
		SOC_denominator = 0;
		end;
	if inc_former_lep_SCI = . then do;
		SCI_numerator = 0;
		SCI_denominator = 0;
		end;
	end;
if subgroup_all = 'Former SWD' then do;
	supergroup = 'Students with Disabilities';
	if inc_former_swd_ELA = . then do;
		ELA_numerator = 0;
		ELA_denominator = 0;
		end;
	if inc_former_swd_MTH = . then do;
		MTH_numerator = 0;
		MTH_denominator = 0;
		end;
	if inc_former_swd_SOC = . then do;
		SOC_numerator = 0;
		SOC_denominator = 0;
		end;
	if inc_former_swd_SCI = . then do;
		SCI_numerator = 0;
		SCI_denominator = 0;
		end;
	end;
run;

data pi_subgroups_with_super_v02;
set pi_subgroups_with_super_v01;
if alt_cohort_dbn in ('12X446','03M479','10X351','09X403','11X265','13K439','15K448','02M560','07X427','01M450','14K685','02M294','21K572','02M303','12X682','13K594','02M534','02M605','02M407','29Q243','07X334','24Q530','02M313','18K569','07X223','02M419','14K586','02M459','24Q520','28Q338','02M570','01M458','02M413','07X495','02M565','02M449','09X564','10X524','10X397','25Q263','21K337','02M438','24Q236','24Q296','12X388','17K524')
	then do;
		SOC_1 = .; SOC_2 = .; SOC_3 = .; SOC_4 = .;
		SCI_1 = .; SCI_2 = .; SCI_3 = .; SCI_4 = .;
		end;
If alt_cohort_dbn in ('12X446','03M479','10X351','09X403','11X265','13K439','15K448','02M560','07X427','01M450','14K685','02M294','21K572','02M303','12X682','13K594','02M534','02M605','02M407','29Q243','07X334','24Q530','02M313','18K569','07X223','02M419','14K586','02M459','24Q520','28Q338','02M570','01M458','02M413','07X495','02M565','02M449')
	then do;
		MTH_1 = .; MTH_2 = .; MTH_3 = .; MTH_4 = .;
		end;
run;
		

proc sql;
create table &dsn_out as
select  "2019:2021-22" as alt_cohort_year,
		school_beds,
		school_name,
		supergroup as acct_subgroup,
		(ELA_1 + ELA_2 + ELA_3 + ELA_4) as ELA_total_members,
		ELA_1,
		ELA_2,
		ELA_3,
		ELA_4,
		(100 * ELA_2 + 200 * ELA_3 + 250 * ELA_4) / (ELA_1 + ELA_2 + ELA_3 + ELA_4) as ELA_PI format 10.1,
		(MTH_1 + MTH_2 + MTH_3 + MTH_4) as MTH_total_members,
		MTH_1,
		MTH_2,
		MTH_3,
		MTH_4,
		(100 * MTH_2 + 200 * MTH_3 + 250 * MTH_4) / (MTH_1 + MTH_2 + MTH_3 + MTH_4) as MTH_PI format 10.1,
		(SCI_1 + SCI_2 + SCI_3 + SCI_4) as SCI_total_members,
		SCI_1,
		SCI_2,
		SCI_3,
		SCI_4,
		(100 * SCI_2 + 200 * SCI_3 + 250 * SCI_4) /  (SCI_1 + SCI_2 + SCI_3 + SCI_4) as SCI_PI format 10.1,
		(SOC_1 + SOC_2 + SOC_3 + SOC_4) as SOC_total_members,
		SOC_1,
		SOC_2,
		SOC_3,
		SOC_4,
		(100 * SOC_2 + 200 * SOC_3 + 250 * SOC_4) / (SOC_1 + SOC_2 + SOC_3 + SOC_4) as SOC_PI format 10.1
from pi_subgroups_with_super_v02 as t1
	inner join hst.school_list as t2
	on t1.alt_cohort_dbn = t2.dbn;
quit;

%mend;

/*
Alternative Cohort Year: School Year	Beds Code	School Name	Acct. Subgroup	ELA Total Members	ELA Acct Level 1	ELA Acct Level 2	ELA Acct Level 3	ELA Acct Level 4	ELA PI	Math Total Members	Math Acct Level 1	Math Acct Level 2	Math Acct Level 3	Math Acct Level 4	Math PI	Science Total Members	Science Acct Level 1	Science Acct Level 2	Science Acct Level 3	Science Acct Level 4	Science PI	Social Studies Total Members	Social Studies Acct Level 1	Social Studies Acct Level 2	Social Studies Acct Level 3	Social Studies Acct Level 4	Social Studies PI

		case when (ELA_1+ELA_2+ELA_3+ELA_4) >= 30 then 1 else . end as inc_former_swd_ELA,
		case when (MTH_1+MTH_2+MTH_3+MTH_4) >= 30 then 1 else . end as inc_former_swd_MTH,
		case when (SCI_1+SCI_2+SCI_3+SCI_4) >= 30 then 1 else . end as inc_former_swd_SCI,
		case when (SOC_1+SOC_2+SOC_3+SOC_4) >= 30 then 1 else . end as inc_former_swd_SOC,

*/ 
