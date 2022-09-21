%macro create_server_libraries ( username = );

%let cats = 	ATS_SUPPORT
				ATS_DEMO
				SIF
				SIF
				OADM_INT
				SPR_INT;

%let libnames = ats_sup
				ats_dem
				sif
				sif_star
				oadm_int
				spr_int;

%let schemas = 	dbo
				dbo
				dbo
				stars
				dbo
				prl;

%let servers =  "ES00vPADOSQL110,51433"
			    "ES00vPADOSQL110,51433"
			    "ES00vPADOSQL110,51433"
				"ES00vPADOSQL150,51433"
			    "ES00VADOSQL001"
				"ES00VADOSQL001";

%let source = 10.2.54.6; 

%do i = 1 %to 6;
	%let cat = %scan (&cats, &i);
	%let lib_nam = %scan (&libnames, &i);
	%let schema = %scan (&schemas, &i);
	%let server = %scan (&servers, &i, %str( ));

	libname &lib_nam oledb 
           provider = sqloledb 
           properties = ( "user id" = &username 
           "Persist Security Info" = True 
           "Integrated Security" = SSPI 
           "Initial Catalog" = &cat ) 
           datasource = &server
           bcp = yes
           schema = &schema;
%end;

%mend create_server_libraries;

%create_server_libraries (username = none);

libname f2021 'R:\DAAR\Sch_Perf\PR\Projects\Framework Reports (survey, QR, misc)\2021\Framework Report\Output\SAS Datasets\';

libname f2020 'R:\DAAR\Sch_Perf\PR\Projects\Framework Reports (survey, QR, misc)\2020\Framework Report\Output\SAS Datasets\';

libname f2019 'R:\DAAR\Sch_Perf\PR\Projects\Framework Reports (survey, QR, misc)\2019\Framework Report\Output\SAS Datasets\';

libname f2018 'R:\DAAR\Sch_Perf\PR\Projects\Framework Reports (survey, QR, misc)\2018\Framework Report\Output\SAS Datasets\';

libname f2017 'R:\DAAR\Sch_Perf\PR\Projects\Framework Reports (survey, QR, misc)\2017\Framework Report\Output\SAS Datasets\';

libname f2016 'R:\DAAR\Sch_Perf\PR\Projects\Framework Reports (survey, QR, misc)\2016\Framework Report\Output\SAS Datasets\';

libname f2015 'R:\DAAR\Sch_Perf\PR\Projects\Framework Reports (survey, QR, misc)\2015\Framework Report\Output\SAS Datasets\';

libname final '\\LMJ086E5X\PR_DATA\FINAL';


