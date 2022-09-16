%macro add_demographic_flags (dsn_out = , dsn_in = ); 

proc sql;
create table stu_with_doe_dem as
select t1.*, im.ethnic_code, 	y1.iep as y1_iep, 
								y2.iep as y2_iep, 
								y3.iep as y3_iep,
								y1.ell as y1_ell,
								y2.ell as y2_ell,
								y3.ell as y3_ell,
								y3.meal_code
from &dsn_in as t1
	left join hst.demimmutableforstu as im
	on t1.id = im.id
	left join hst.demmutableforstu as y3
	on t1.id = y3.id and y3.year = &current_year
	left join hst.demmutableforstu as y2
	on t1.id = y2.id and y2.year = %eval (&current_year - 1)
	left join hst.demmutableforstu as y1
	on t1.id = y1.id and y1.year = %eval (&current_year - 2);
quit;

data &dsn_out;
set stu_with_doe_dem;
drop student_id local_id distrct_beds district_name; 
length group_ethnic $40 group_lep $30 group_swd $30 group_econ $30  ;
if ethnic_code in ('C','D','2') then group_ethnic = 'Asian or Pacific Islander';
if ethnic_code in ('A','3') then group_ethnic = 'Hispanic or Latino';
if ethnic_code in ('4','E') then group_ethnic = 'Black or African American';
if ethnic_code in ('5','F') then group_ethnic = 'White';
if ethnic_code in ('1','B') then group_ethnic = 'American Indian or Alaska Native';
if ethnic_code in ('G','6',' ') then group_ethnic = 'Multiracial';
if ethnic_desc ^= ' ' then group_ethnic = ethnic_desc;  /*SED ethnic data overwrites DOE data*/
if former_swd = 'YES' or y1_iep = 1 or y2_iep = 1 then group_swd = 'Former SWD';
if swd ^= ' ' or y3_iep = 1 then group_swd = 'Students with Disabilities'; /*current SWD overwrites former */
if former_lep = 'YES' or y1_ell = 1 or y2_ell = 1 then group_lep = 'Former LEP';
if lep_eligibility = 'YES' or y3_ell = 1 then group_lep = 'Limited English Proficient'; /*current LEP overwrites former */
if poverty = 'YES' or meal_code in ('A','1','2') then group_econ = 'Economic Disadvantage';
run;



%mend;
