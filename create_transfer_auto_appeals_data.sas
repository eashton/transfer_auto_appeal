libname hst 'C:\My Docs Live\Projects\Transfer School Data for SED\Data';
libname final '\\LMJ086E5X\PR_DATA\FINAL';

options nolabel spool mautosource mprint
		sasautos = ("C:\My Docs Live\Projects\Transfer School Data for SED\SAS Macros" sasautos);

%global current_year current_FDOS data_path;
%let current_year = 2022;
%let current_FDOS = '08SEP2022'd;
%let data_path = C:\My Docs Live\Projects\Transfer School Data for SED\Data\;

%create_server_libraries 					(username = none);

%create_school_list							(dsn_out = hst.school_list);

%id_possible_alt_cohort_students 			(dsn_out = hst.auto_appeal_stu_v01);

%add_graduation_data						(dsn_in = hst.auto_appeal_stu_v01,
											dsn_out = hst.auto_appeal_stu_v02);

%remove_cohort_removing_disc				(dsn_in = hst.auto_appeal_stu_v02,
											dsn_out = hst.auto_appeal_stu_v03);

%add_demographic_flags						(dsn_in = hst.auto_appeal_stu_v03,
											dsn_out = hst.auto_appeal_stu_v04);

%add_exam_data								(dsn_in = hst.auto_appeal_stu_v04,
											dsn_out = hst.auto_appeal_stu_v05);
	
%calculate_grad_rates_by_subgroup  			(dsn_in = hst.auto_appeal_stu_v05,
											dsn_out = hst.grad_rate_by_subgroup);

%calculate_pis_by_subgroup					(dsn_in = hst.auto_appeal_stu_v05,
											dsn_out = hst.pi_by_subgroup);

%output_grad_rate_sch						(dsn_in = hst.grad_rate_by_subgroup,
											file_out = grad_rate_sch.csv);

%output_grad_rate_stu						(dsn_in = hst.auto_appeal_stu_v05,
											file_out = grad_rate_stu.csv);

%output_pi_stu								(dsn_in = hst.auto_appeal_stu_v05,
											file_out = pi_stu.csv);







