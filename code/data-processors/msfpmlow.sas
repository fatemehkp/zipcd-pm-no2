/* Created by Fatemeh K (01-02-2021)																*/
/* Create an aggregate data by the zipcode															*/
/* Dataset aggregated number of enrolleess and deaths by zipcode, year, month, age, sex and race    */
/* Focus on 2000 (Jan) to 2008 data                                              					*/
/* Include SES data from IRS                                                                        */
/* Avg of 1yrmvavg PM < 8 , 10 and 12																*/

libname prcs '/scratch/fatemehkp/projects/Zipcode PM NO2/data/processed';

proc import datafile= '/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-pm-zipcd.csv' 
	out= master_cuz_ses
	dbms=csv 
	REPLACE;
	getnames=YES;
	datarow=2;
run;

data master_cuz_ses; length zip $5.;
	set master_cuz_ses;
	zip=strip(put(zip_code, z5.));
	drop zip_code;
run;

data master_cuz_ses;
	set master_cuz_ses;
	zip_code = zip;
	drop zip;
run;



* PM < 12;
proc sql;
	create table master_cuz_ses_12 as
	select *
	from master_cuz_ses a
	inner join prcs.PM_ZIPCD_pm1yrcat b
	on a.zip_code=b.zip_code
	where pm12 = 1;
quit;

proc export 
	data=master_cuz_ses_12
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-pm-zipcd-pm12.csv'  
	dbms=csv replace;
run;


* PM < 10;
proc sql;
	create table master_cuz_ses_10 as
	select *
	from master_cuz_ses a
	inner join prcs.PM_ZIPCD_pm1yrcat b
	on a.zip_code=b.zip_code
	where pm10 = 1;
quit;

proc export 
	data=master_cuz_ses_10
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-pm-zipcd-pm10.csv'  
	dbms=csv replace;
run;


* PM < 8;
proc sql;
	create table master_cuz_ses_8 as
	select *
	from master_cuz_ses a
	inner join prcs.PM_ZIPCD_pm1yrcat b
	on a.zip_code=b.zip_code
	where pm8 = 1;
quit;

proc export 
	data=master_cuz_ses_8
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-pm-zipcd-pm8.csv'  
	dbms=csv replace;
run;




proc import datafile= '/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-no2-zipcd.csv' 
	out= master_cuz_ses
	dbms=csv 
	REPLACE;
	getnames=YES;
	datarow=2;
run;



data master_cuz_ses; length zip $5.;
	set master_cuz_ses;
	zip=strip(put(zip_code, z5.));
	drop zip_code;
run;

data master_cuz_ses;
	set master_cuz_ses;
	zip_code = zip;
	drop zip;
run;



* pm < 12;
proc sql;
	create table master_cuz_ses_12 as
	select *
	from master_cuz_ses a
	inner join prcs.pm_ZIPCD_pm1yrcat b
	on a.zip_code=b.zip_code
	where pm12 = 1;
quit;

proc export 
	data=master_cuz_ses_12
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-no2-zipcd-pm12.csv'  
	dbms=csv replace;
run;



* pm < 10;
proc sql;
	create table master_cuz_ses_10 as
	select *
	from master_cuz_ses a
	inner join prcs.pm_ZIPCD_pm1yrcat b
	on a.zip_code=b.zip_code
	where pm10 = 1;
quit;

proc export 
	data=master_cuz_ses_10
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-no2-zipcd-pm10.csv'  
	dbms=csv replace;
run;



* pm < 8;
proc sql;
	create table master_cuz_ses_8 as
	select *
	from master_cuz_ses a
	inner join prcs.pm_ZIPCD_pm1yrcat b
	on a.zip_code=b.zip_code
	where pm8 = 1;
quit;

proc export 
	data=master_cuz_ses_8
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-no2-zipcd-pm8.csv'  
	dbms=csv replace;
run;

