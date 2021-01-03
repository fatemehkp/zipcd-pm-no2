libname raw '/scratch/fatemehkp/projects/data/raw';
libname prcs '/scratch/fatemehkp/projects/data/processed';

proc univariate data=raw.pm_j_daily_zip2;
	var yr; *1999-2011;
run;

proc sql; *42,297;
	select count(distinct zip_code)
	from raw.pm_j_daily_zip2;
quit;

proc sql; *42,265;
	select count(distinct zip_code)
	from raw.pm_j_daily_zip2
	where 1999<yr<2009;
quit;

/* *Done;
data raw.pm_j_daily_zip2; 
	set raw.pm_j_daily_zip2;
	if St ne '' then state_name=St;
		else state_name=state;
run;
*/

proc sql;
	select count(distinct state_name) 
	from raw.pm_j_daily_zip2;
quit;

proc sql;
	select count(distinct state_name)
	from raw.pm_j_daily_zip2
	where 1999<yr<2009;
quit;

/*
proc sort data=raw.pm_j_daily_zip2 nodupkey out=raw.states_pm 
(keep=st st_fips state state_name);
 	by state_name; 
run;
*/

data pm_zipcd1; 
	retain zip_code state_name year month day chardate pm_1mo pm_6mo;
	set raw.pm_j_daily_zip2;
	year=yr;
	month=mo;
	pm_1mo= pm_j_30dmvavg;
	pm_6mo= pm_j_180dmvavg;
	pm_1yr= pm_j_365dmvavg;
	pm_2yr= pm_j_2ymvavg;
	pm_3yr= pm_j_3ymvavg;
	pm_4yr= pm_j_4ymvavg;
	pm_5yr= pm_j_5ymvavg;
	keep zip_code state_name year month day chardate pm_1mo pm_6mo pm_1yr pm_2yr pm_3yr pm_4yr pm_5yr;
run;

*Keep CONUS in dataset: 48 adjoining U.S. states (plus the District of Columbia); 
data pm_zipcd2; 
	set pm_zipcd1;
	where 1999<year<2009;
	if state_name in ('AK','HI','PR','VI') then delete;
run;

*Keep last day of each month;
proc sort data= pm_zipcd2; 
	by zip_code descending chardate; 
run;

proc sort data=pm_zipcd2 nodupkey out=pm_zipcd3; 
	by zip_code year month;
run;

data prcs.PM_ZIPCD; 
	set pm_zipcd3;
	rename state_name=state;
	drop day chardate;
run;


proc sql; *49;
	select count(distinct state)
	from prcs.pm_zipcd;
quit;


proc sql; *41667;
	select count(distinct zip_code)
	from prcs.pm_zipcd;
quit;

proc univariate data=prcs.pm_zipcd;
	var pm_1mo pm_6mo pm_1yr pm_2yr pm_3yr pm_4yr pm_5yr;
run;

* 124,218 missing obs for pm_5yr;


