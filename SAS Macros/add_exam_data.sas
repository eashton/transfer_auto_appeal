%macro add_exam_data (dsn_out = , dsn_in = ); 

proc sql;
create table all_exams as

select t1.id, t2.mark, t3.exam
from &dsn_in as t1
	inner join spr_int.raw_regent_rct as t2
	on t1.id = t2.id
	inner join  spr_int.lookup_regent_coursecd as t3
	on t2.coursecd = t3.coursecd and t3.exam_type = 'REGENT'

union all

select t1.id, put(t2.level, 1.) as mark, t2.subject as exam
from &dsn_in as t1
	inner join spr_int.raw_state_exam_nysaa as t2
	on t1.id = t2.id
where exam_grade_level = '11';
quit;

data all_exam_levels;
set all_exams;
score = input(mark, best.);
if score = . then delete;
if exam in ('ELA','MTH','SCI','SOC') then do; /*these are NYSAA codes*/
	priority = 2; /* Regents (priority 1) prioritized over NSAA (priority 2) */ 
	level = score; 
	subject = exam; 
	end;
else priority = 1;
if exam in ('esci','phys','livn','chem') then do;
	subject = 'SCI';
	level = 1; if score >= 55 then level = 2; if score >= 65 then level = 3; if score >= 85 then level = 4;
	end;
if exam in ('hist','glob') then do;
	subject = 'SOC';
	level = 1; if score >= 55 then level = 2; if score >= 65 then level = 3; if score >= 85 then level = 4;
	end;
if exam in ('engl') then do;
	subject = 'ELA';
	level = 1; if score >= 65 then level = 2; if score >= 79 then level = 3; if score >= 85 then level = 4;
	end;
if exam in ('inta', 'geom','algt') then do;
	subject = 'MTH';
	level = 1; if score >= 65 then level = 2; if score >= 80 then level = 3; if score >= 85 then level = 4;
	if exam = 'algt' and score in ('79','80') then level = 3;
	end;
run; 

proc sort data = all_exam_levels;
by id subject priority descending level;
run;

proc sort data = all_exam_levels out = best_exam_level_tall nodupkey;
by id subject;
run;

proc transpose data = best_exam_level_tall out = best_exam_level_wide;
var level;
id subject;
by id; 
run;

proc sql;
create table &dsn_out as
select t1.*, t2.ELA, t2.MTH, t2.SCI, t2.SOC
from &dsn_in as t1
	left join best_exam_level_wide as t2
	on t1.id = t2.id;
quit;

%mend;
