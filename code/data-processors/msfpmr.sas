/* Created by Fatemeh K (08-28-2022) (08-19-2022)																*/
/* Create an aggregate data by the zipcode															*/
/* Dataset aggregated number of enrolleess and deaths by zipcode, year, month, age, sex and race    */
/* Focus on 2000 (Jan) to 2008 data                                              					*/
/* Include SES data from IRS                                                                        */
/* Interaction term for race	  		   													        */

libname cms '/scratch/fatemehkp/projects/CMS/data/processed';

data enrollee_pm; 
	set cms.enrollee65_ndi_0008_clean;
	if enrollee_age ge 90 then enrollee_age = 90;
	where sex ne 'U' and pm_1yr ne . and ses_zip ne .;
run;

	
/****************************************************************************/
/* Compute MASTER file                                                      */
/****************************************************************************/
proc sql;
*Count the number of enrollees of age a, sex s and race r by zipcode z at the beginning of the month t ;
	create table master_enrollee_byzip as
	select zip_code, year, month, enrollee_age, sex, race, pm_1yr, state, ses_zip, ses_stt, count(distinct BENE_ID) as no_enrollee
	from enrollee_pm
	group by zip_code, year, month, enrollee_age, sex, race, pm_1yr, state, ses_zip, ses_stt;

*Count the number of all-cause death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip1 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_allcuz
	from enrollee_pm
	where allcuz=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of CVD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip4 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cvd
	from enrollee_pm
	where cvd=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of IHD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip5 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ihd
	from enrollee_pm
	where ihd=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of CHF death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip6 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_chf
	from enrollee_pm
	where chf=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of CBV death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip7 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cbv
	from enrollee_pm
	where cbv=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Respiratory death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip8 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_resp
	from enrollee_pm
	where resp=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of COPD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip9 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_copd
	from enrollee_pm
	where copd=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Pneumonia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip10 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_pneu
	from enrollee_pm
	where pneu=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of URI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip11 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_uri
	from enrollee_pm
	where uri=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of LRI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip12 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_lri
	from enrollee_pm
	where lri=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of ARDS death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip13 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ards
	from enrollee_pm
	where ards=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip14 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_canc
	from enrollee_pm
	where canc=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Lung Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip15 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_lungc
	from enrollee_pm
	where lungc=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Sepsis death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip16 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_seps
	from enrollee_pm
	where seps=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Vascular Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip17 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_VaD
	from enrollee_pm
	where VaD=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Unspecified Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip18 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_UsD
	from enrollee_pm
	where UsD=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip19 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_demn
	from enrollee_pm
	where demn=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Parkinson death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip20 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_PD
	from enrollee_pm
	where PD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Alzheimer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip21 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_AD
	from enrollee_pm
	where AD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Neurodegenerative Disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip22 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_NeD
	from enrollee_pm
	where NeD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Multiple Sclerosis death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip23 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_MS
	from enrollee_pm
	where MS=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Diabete typeI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip24 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt1
	from enrollee_pm
	where diabt1=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Diabete typeII death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip25 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt2
	from enrollee_pm
	where diabt2=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Diabete death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip26 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diab
	from enrollee_pm
	where diabt1=1 or diabt2=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Renal disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip27 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_kidn
	from enrollee_pm
	where kidn=1
	group by zip_code, year, month, enrollee_age, sex, race;

quit;

data master_cuz;
	merge master_enrollee_byzip master_death_byzip1 
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
	delete master_enrollee_byzip master_death_byzip1 
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
	set master_cuz;
	if race="A" then raceA=0; else raceA=1;
	if race="B" then raceB=0; else raceB=1;
	if race="H" then raceH=0; else raceH=1;
	if race="N" then raceN=0; else raceN=1;
	if race="W" then raceW=0; else raceW=1;
/*	if race="O" then raceO=0; else raceO=1;*/
	pmraceA=pm_1yr*raceA;
	pmraceB=pm_1yr*raceB;
	pmraceH=pm_1yr*raceH;
	pmraceN=pm_1yr*raceN;
	pmraceW=pm_1yr*raceW;
/*	pmraceO=pm_1yr*raceO;*/
run;

data master_cuz; 
	length StrID $6.; 
	set master_cuz;
	agec = STRIP(PUT(enrollee_age, z2.));
	StrID = agec || sex || race;
	drop agec enrollee_age sex race year month;
run;

proc export 
	data=master_cuz
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-pm-zipcd-race.csv'  
	dbms=csv replace;
run;





