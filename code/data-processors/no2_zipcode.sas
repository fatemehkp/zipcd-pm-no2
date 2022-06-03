/* NO2 data by zipcode - source: Bechle */

libname raw '/scratch/fatemehkp/projects/Zipcode no2 NO2/data/raw';
libname prcs '/scratch/fatemehkp/projects/Zipcode no2 NO2/data/processed';


proc univariate data=raw.no2_track_monthly_zip_longenmean;
	var bene_enrollmt_ref_yr no2_1yr; *2000-2010;
run;

proc sql;
	create table no2 as
	select *
	from raw.no2_track_monthly_zip_longenmean a
	inner join raw.zipcoden_zipcoder b
		on a.zipcoder=b.zipcoder
	where 1999<bene_enrollmt_ref_yr <2009 and no2_1yr is not null;
quit;


data prcs.NO2_ZIPCD;
	retain zip_code year month no2_1yr; 
	set no2; 
	year = bene_enrollmt_ref_yr;
	keep zip_code year month no2_1yr;
run;

proc sort data=prcs.NO2_ZIPCD nodupkey; 
	by zip_code year month; 
run;

proc sql; *19,878;
	select count(distinct zip_code)
	from prcs.no2_zipcd;
quit;



proc sql;
	create table no2_zipcd_avg as
	select zip_code,
	avg(no2_1yr) as no2_1yr_avg
	from prcs.no2_zipcd
	group by zip_code
	order by zip_code;
quit;

data prcs.no2_ZIPCD_no21yrcat;
	set no2_ZIPCD_avg;
	if no2_1yr_avg < 7 then no27 = 1; else no27 = 0;
	if no2_1yr_avg < 12 then no212 = 1; else no212 = 0;
	keep zip_code no27 no212;
run;

proc univariate data = no2_zipcd_avg;
run;
	
