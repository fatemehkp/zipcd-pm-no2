/* PM data by zipcode - source: Jeff Yanosky */

libname raw '/scratch/fatemehkp/projects/Zipcode PM NO2/data/raw';
libname prcs '/scratch/fatemehkp/projects/Zipcode PM NO2/data/processed';

proc univariate data=raw.pm_j_daily_zip2;
	var yr pm_j_365dmvavg; *1999-2011;
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


data pm_zipcd2; 
	retain zip_code state_name year month day chardate pm_daily pm_1mo pm_6mo;
	set raw.pm_j_daily_zip2;
	year=yr;
	month=mo;
	pm_daily = pm_jeff;
	pm_1mo= pm_j_30dmvavg;
	pm_6mo= pm_j_180dmvavg;
	pm_1yr= pm_j_365dmvavg;
	pm_2yr= pm_j_2ymvavg;
	pm_3yr= pm_j_3ymvavg;
	pm_4yr= pm_j_4ymvavg;
	pm_5yr= pm_j_5ymvavg;
	where 1999 < yr < 2009;
	keep zip_code state_name year month day chardate pm_daily pm_1mo pm_6mo pm_1yr pm_2yr pm_3yr pm_4yr pm_5yr;
run; 
	
proc sql;
	create table pm_zipcd_avg as
	select zip_code, year
	avg(pm_daily) as pm_daily_avg,
	avg(pm_1mo) as pm_1mo_avg,
	avg(pm_6mo) as pm_6mo_avg,
	avg(pm_1yr) as pm_1yr_avg,
	avg(pm_2yr) as pm_2yr_avg,
	avg(pm_3yr) as pm_3yr_avg,
	avg(pm_4yr) as pm_4yr_avg,
	avg(pm_5yr) as pm_5yr_avg
	from pm_zipcd2
	group by zip_code, year
	order by zip_code, year;
quit;

data prcs.PM_ZIPCD_pm1yrcat;
	set PM_ZIPCD_avg;
	if pm_1yr_avg < 8 then pm8 = 1; else pm8 = 0;
	if pm_1yr_avg < 10 then pm10 = 1; else pm10 = 0;
	if pm_1yr_avg < 12 then pm12 = 1; else pm12 = 0;
	keep zip_code pm8 pm10 pm12;
run;

data test;
	set PM_ZIPCD_avg;
	diff = pm_1yr_avg - pm_daily_avg;
	keep zip_code pm_daily_avg pm_1yr_avg diff;
run;

proc univariate data = test;
run;
	

	
	
	
	
	
	
	
	
	
	
