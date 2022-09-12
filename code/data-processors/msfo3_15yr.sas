/* Created by Fatemeh K (08-29-2022) 																*/
/* Create an aggregate data by the zipcode															*/
/* Dataset aggregated number of enrolleess and deaths by zipcode, year, month, age, sex and race    */
/* Focus on 2004 (Jan) to 2008 data                                              					*/
/* Include SES data from IRS                                                                        */

libname cms '/scratch/fatemehkp/projects/CMS/data/processed';
libname air '/scratch/fatemehkp/projects/Zipcode Ozone PM/data/processed';

proc sql;
	create table enrollee65_ndi_0008_clean as
	select *
	from cms.enrollee65_ndi_0008_clean a 
	inner join air.o3max8h_15yr_zipcd b
	on a.zip_code=b.zip_code and a.year=b.year
	where sex ne 'U' and pm_5yr ne . and o3max8h_warm_5yr ne . and ses_zip ne .;
quit;

data enrollee_o3; 
	set enrollee65_ndi_0008_clean;
	if race='W' then race='W';
		else race='NW';
	if enrollee_age ge 90 then enrollee_age = 90;
run;

/****************************************************************************/
/* Compute MASTER file                                                      */
/****************************************************************************/
proc sql;
*Count the number of enrollees of age a, sex s and race r by zipcode z at the beginning of the month t ;
	create table master_enrollee_byzip as
	select zip_code, year, month, enrollee_age, sex, race, o3max8h_warm_1yr, o3max8h_warm_2yr, o3max8h_warm_3yr, o3max8h_warm_4yr, o3max8h_warm_5yr, pm_1yr, pm_2yr, pm_3yr, pm_4yr, pm_5yr, state, ses_zip, ses_stt, count(distinct BENE_ID) as no_enrollee
	from enrollee_o3
	group by zip_code, year, month, enrollee_age, sex, race, o3max8h_warm_1yr, o3max8h_warm_2yr, o3max8h_warm_3yr, o3max8h_warm_4yr, o3max8h_warm_5yr, pm_1yr, pm_2yr, pm_3yr, pm_4yr, pm_5yr, state, ses_zip, ses_stt;

*Count the number of all-cause death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip1 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_allcuz
	from enrollee_o3
	where allcuz=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of non-accidental death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip2 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_nacc
	from enrollee_o3
	where nacc=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of accidental death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip3 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_acc
	from enrollee_o3
	where acc=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of CVD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip4 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cvd
	from enrollee_o3
	where cvd=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of IHD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip5 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ihd
	from enrollee_o3
	where ihd=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of CHF death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip6 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_chf
	from enrollee_o3
	where chf=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of CBV death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip7 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cbv
	from enrollee_o3
	where cbv=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Respiratory death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip8 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_resp
	from enrollee_o3
	where resp=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of COPD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip9 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_copd
	from enrollee_o3
	where copd=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Pneumonia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip10 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_pneu
	from enrollee_o3
	where pneu=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of URI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip11 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_uri
	from enrollee_o3
	where uri=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of LRI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip12 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_lri
	from enrollee_o3
	where lri=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of ARDS death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip13 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ards
	from enrollee_o3
	where ards=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip14 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_canc
	from enrollee_o3
	where canc=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Lung Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip15 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_lungc
	from enrollee_o3
	where lungc=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Sepsis death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip16 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_seps
	from enrollee_o3
	where seps=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Vascular Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip17 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_VaD
	from enrollee_o3
	where VaD=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Unspecified Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip18 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_UsD
	from enrollee_o3
	where UsD=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip19 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_demn
	from enrollee_o3
	where demn=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Parkinson death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip20 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_PD
	from enrollee_o3
	where PD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Alzheimer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip21 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_AD
	from enrollee_o3
	where AD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Neurodegenerative Disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip22 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_NeD
	from enrollee_o3
	where NeD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Multiple Sclerosis death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip23 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_MS
	from enrollee_o3
	where MS=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Diabete typeI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip24 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt1
	from enrollee_o3
	where diabt1=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Diabete typeII death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip25 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt2
	from enrollee_o3
	where diabt2=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Diabete death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip26 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diab
	from enrollee_o3
	where diabt1=1 or diabt2=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Renal disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip27 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_kidn
	from enrollee_o3
	where kidn=1
	group by zip_code, year, month, enrollee_age, sex, race;

quit;

data master_cuz;
	merge master_enrollee_byzip master_death_byzip1 master_death_byzip2 master_death_byzip3
								master_death_byzip4 master_death_byzip5 master_death_byzip6
								master_death_byzip7 master_death_byzip8 master_death_byzip9
								master_death_byzip10 master_death_byzip11 master_death_byzip12
								master_death_byzip13 master_death_byzip14 master_death_byzip15
								master_death_byzip16 master_death_byzip17 master_death_byzip18
								master_death_byzip19 master_death_byzip20 master_death_byzip21
								master_death_byzip22 master_death_byzip23 master_death_byzip24
								master_death_byzip25 master_death_byzip26 master_death_byzip27;
	by zip_code year month enrollee_age sex race;
run;

proc datasets nolist;
	delete master_enrollee_byzip master_death_byzip1 master_death_byzip2 master_death_byzip3
								master_death_byzip4 master_death_byzip5 master_death_byzip6
								master_death_byzip7 master_death_byzip8 master_death_byzip9
								master_death_byzip10 master_death_byzip11 master_death_byzip12
								master_death_byzip13 master_death_byzip14 master_death_byzip15
								master_death_byzip16 master_death_byzip17 master_death_byzip18
								master_death_byzip19 master_death_byzip20 master_death_byzip21
								master_death_byzip22 master_death_byzip23 master_death_byzip24
								master_death_byzip25 master_death_byzip26 master_death_byzip27;
run;

/*change . to 0*/
data master_cuz; set master_cuz;
	array change _numeric_;
		do over change;
			if change <0 then change=0;
		end;
run;

data master_cuz; 
	length StrID $6.; 
	set master_cuz;
	agec = STRIP(PUT(enrollee_age, z2.));
	StrID = agec || sex || race;
	drop agec enrollee_age sex race year month zip_code;
run;

proc export 
	data=master_cuz
	outfile='/scratch/fatemehkp/projects/Zipcode Ozone PM/data/analysis/ndi-o3-15yr-zipcd.csv'  
	dbms=csv replace;
run;





