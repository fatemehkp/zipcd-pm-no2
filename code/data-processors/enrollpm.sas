/* Created by Fatemeh K (01-15-2021) (09-08-2022)																*/
/* Focus on 2000 (Jan) to 2008 data                                              					*/
/* Count total numbers and subgroups */
                                                                
libname prcs '/scratch/fatemehkp/projects/Zipcode PM NO2/data/processed';
libname cms '/scratch/fatemehkp/projects/CMS/data/processed';


/*****************************/
/* Total enrollee */
proc sql;
	title 'Total enrollee in the US';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_pm_start;
quit;

/*****************************/
/* Total zipcode */
proc sql;
	title 'Total zipcode in the US';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and ses_zip ne .;
quit;


/*****************************/
/* Total enrollee at each age at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Age at time of enrollement';
	Create table enrollee_age as
	select enrollee_age, count(bene_id) as age_freq
	from prcs.enrollee_pm_start
	group by enrollee_age
	order by enrollee_age;
quit;

proc export	data=enrollee_age
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_age_pm.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee at each age group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Age Group at time of enrollement';
	Create table enrollee_agecat as
	select sum(case when enrollee_age <= 75 then 1 else 0 end) as LE75_freq,
		   sum(case when enrollee_age > 75 then 1 else 0 end) as M75_freq
	from prcs.enrollee_pm_start
quit;

proc export	data=enrollee_agecat
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_agecat_pm.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee at each sex group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Sex at time of enrollement';
	Create table enrollee_sex as
	select sex, count(bene_id) as sex_freq
	from prcs.enrollee_pm_start
	group by sex
	order by sex;
quit;

proc export	data=enrollee_sex
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_sex_pm.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee at each race group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Race at time of enrollement';
	Create table enrollee_race as
	select race, count(bene_id) as race_freq
	from prcs.enrollee_pm_start
	group by race
	order by race;
quit;

proc export	data=enrollee_race
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_race_pm.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee in the US with Urbanicty Data */
proc sql;
	title 'Total enrollee in the US with Urbanicty Data';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_pm_start
	where ruca ne '';
quit;

/*****************************/
/* Total zipcode in the US with Urbanicty Data*/
proc sql;
	title 'Total zipcode in the US with Urbanicty Data';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and ses_zip ne . and ruca ne '';
quit;

/*****************************/
/* Total enrollee at each urbanicity group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Urbanicity at time of enrollement';
	Create table enrollee_ruca as
	select ruca, count(bene_id) as ruca_freq
	from prcs.enrollee_pm_start
	where ruca ne ''
	group by ruca
	order by ruca;
quit;

proc export	data=enrollee_ruca
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_ruca_pm.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee in the Urban areas with ses category Data*/
proc sql;
	title 'Total enrollee in the Urban areas with ses Data';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_pm_start
	where ses_tertile ne .;
quit;

/*****************************/
/* Total zipcode in the Urban areas with ses Data*/
proc sql;
	title 'Total zipcode in the US urban areas with ses Data';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and ses_tertile ne .;
quit;


/*****************************/
/* Total enrollee at each ses group in urban areas at time of enrollment */
proc sql;
	title 'Enrollee Distribution of ses group at time of enrollement';
	Create table enrollee_ses as
	select ses_tertile, count(bene_id) as ses_freq
	from prcs.enrollee_pm_start
	where ses_tertile ne .
	group by ses_tertile
	order by ses_tertile;
quit;

proc export	data=enrollee_ses
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_urban_sescat_pm.csv'
	dbms=csv
	replace;
run;

/*****************************/
/* Total enrollee at each race group in urban areas at time of enrollment */
proc sql;
	title 'Enrollee Distribution of ses group at time of enrollement';
	Create table enrollee_race as
	select race, count(bene_id) as race_freq
	from prcs.enrollee_pm_start
	where ruca = "Urban"
	group by race
	order by race;
quit;

proc export	data=enrollee_race
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_urban_race_pm.csv'
	dbms=csv
	replace;
run;

/*****************************/
/* Total enrollee at each region group at time of enrollment */
proc sql;
	title 'Enrollee Distribution of Region at time of enrollement';
	Create table enrollee_region as
	select region, count(bene_id) as region_freq
	from prcs.enrollee_pm_start
	group by region
	order by region;
quit;

proc export	data=enrollee_region
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/output/table/enrollee_region_pm.csv'
	dbms=csv
	replace;
run;


/*****************************/
/* Total enrollee in the US with BRFSS data */
proc sql;
	title 'Total enrollee in the US with BRFSS data';
	select count(bene_id) as num_enrollee
	from prcs.enrollee_pm_brfss_start;
quit;

/*****************************/
/* Total zipcode in the US with BRFSS data */
proc sql;
	title 'Total zipcode in the US with BRFSS data';
	select count(distinct zip_code) as num_zipcode
	from cms.enrollee65_ndi_0008_clean
	where sex ne 'U' and pm_1yr ne . and ses_zip ne . and X_bmi_mean ne .;
quit;
