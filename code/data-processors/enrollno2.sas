/* Created by Fatemeh K (01-15-2021)																*/
/* Focus on 2000 (Jan) to 2008 data                                              					*/
/* Count total numbers and subgroups */
                                                                
libname prcs '/scratch/fatemehkp/projects/Zipcode PM NO2/data/processed';
libname cms '/scratch/fatemehkp/projects/CMS/data/processed';


/*****************************/
/* Total enrollee */
proc sql;
	title 'Total enrollee in the US';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_no2_start;
quit;

/*****************************/
/* Total zipcode */
proc sql;
	title 'Total zipcode in the US';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and no2_1yr ne . and ses_zip ne .;
quit;


/*****************************/
/* Total enrollee at each age group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Age at time of enrollement';
	Create table enrollee_age as
	select enrollee_age, count(bene_id) as age_freq
	from prcs.enrollee_no2_start
	group by enrollee_age
	order by enrollee_age;
quit;

proc export	data=enrollee_age
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_age_no2.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee at each sex group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Sex at time of enrollement';
	Create table enrollee_sex as
	select sex, count(bene_id) as sex_freq
	from prcs.enrollee_no2_start
	group by sex
	order by sex;
quit;

proc export	data=enrollee_sex
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_sex_no2.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee at each race group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Race at time of enrollement';
	Create table enrollee_race as
	select race, count(bene_id) as race_freq
	from prcs.enrollee_no2_start
	group by race
	order by race;
quit;

proc export	data=enrollee_race
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_race_no2.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee in the US with BRFSS data */
proc sql;
	title 'Total enrollee in the US with BRFSS data';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_no2_brfss_start;
quit;

/*****************************/
/* Total zipcode in the US with BRFSS data */
proc sql;
	title 'Total zipcode in the US with BRFSS data';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and no2_1yr ne . and ses_zip ne . and X_bmi_mean ne .;
quit;


/*****************************/
/* Total enrollee in the US with Urbanicty Data */
proc sql;
	title 'Total enrollee in the US with Urbanicty Data';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_no2_start
	where urban ne .;
quit;

/*****************************/
/* Total zipcode in the US with Urbanicty Data*/
proc sql;
	title 'Total zipcode in the US with Urbanicty Data';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and no2_1yr ne . and ses_zip ne . and urban ne .;
quit;


/*****************************/
/* Total enrollee at each urbanicity group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Urbanicity at time of enrollement';
	Create table enrollee_urban as
	select urban, count(bene_id) as urb_freq
	from prcs.enrollee_no2_start
	where urban ne .
	group by urban
	order by urban;
quit;

proc export	data=enrollee_urban
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_urban_no2.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee in the Urban areas with ses category Data*/
proc sql;
	title 'Total enrollee in the Urban areas with ses Data';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_no2_start
	where ses_tertile ne .;
quit;

/*****************************/
/* Total zipcode in the Urban areas with ses Data*/
proc sql;
	title 'Total zipcode in the US urban areas with ses Data';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and no2_1yr ne . and ses_tertile ne .;
quit;


/*****************************/
/* Total enrollee at each ses group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of ses group at time of enrollement';
	Create table enrollee_sescat as
	select ses_tertile, count(bene_id) as ses_freq
	from prcs.enrollee_no2_start
	where ses_tertile ne .
	group by ses_tertile
	order by ses_tertile;
quit;

proc export	data=enrollee_sescat
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_urban_sescat_no2.csv'
	dbms=csv
	replace;
run;
