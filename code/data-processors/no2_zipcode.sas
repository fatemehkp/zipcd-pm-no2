libname raw '/scratch/fatemehkp/projects/data/raw';
libname prcs '/scratch/fatemehkp/projects/data/processed';

proc univariate data=raw.no2_track_monthly_zip_longenmean;
	var bene_enrollmt_ref_yr; *2000-2010;
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






