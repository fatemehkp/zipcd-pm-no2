/* Created by Fatemeh K (01-02-2021)																*/
/* Create an aggregate data by the zipcode															*/
/* Dataset aggregated number of enrolleess and deaths by zipcode, year, month, age, sex and race    */
/* Focus on 2000 (Jan) to 2008 data                                              					*/
/* Include SES data from IRS                                                                        */
/* Interaction term for age, sex, race																*/

libname cms '/scratch/fatemehkp/projects/CMS/data/processed';
libname prcs '/scratch/fatemehkp/projects/Zipcode PM NO2/data/processed';
libname ses '/scratch/fatemehkp/projects/USA Spatial/data/processed';


data enrollee_pm; 
	set cms.enrollee65_ndi_0008_clean;
	if race='W' then race='W';
		else race='NW';
	if enrollee_age ge 90 then enrollee_age = 90;
	where sex ne 'U' and pm_1yr ne . and ses_zip ne .;
run;


/****************************************************************************/
/* Compute MASTER file                                                      */
/****************************************************************************/
proc sql;
*Count the number of enrollees of age a, sex s and race r by zipcode z at the beginning of the month t ;
	create table master_enrollee_byzip as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_enrollee
	from enrollee_pm
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of all-cause death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip1 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_allcuz
	from enrollee_pm
	where allcuz=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of non-accidental death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip2 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_nacc
	from enrollee_pm
	where nacc=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of accidental death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip3 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_acc
	from enrollee_pm
	where acc=1
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

*Count the number of ARDS death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip12 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ards
	from enrollee_pm
	where ards=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip13 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_canc
	from enrollee_pm
	where canc=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Lung Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip14 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_lungc
	from enrollee_pm
	where lungc=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Sepsis death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip15 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_seps
	from enrollee_pm
	where seps=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Vascular Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip16 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_VaD
	from enrollee_pm
	where VaD=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Alzheimer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip17 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_AD
	from enrollee_pm
	where AD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Neurodegenerative Disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip18 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_NeD
	from enrollee_pm
	where NeD=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Unspecified Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip19 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_UsD
	from enrollee_pm
	where UsD=1
	group by zip_code, year, month, enrollee_age, sex, race;
	
*Count the number of Diabete typeI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip20 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt1
	from enrollee_pm
	where diabt1=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Diabete typeII death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip21 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt2
	from enrollee_pm
	where diabt2=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Diabete death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip22 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diab
	from enrollee_pm
	where diabt1=1 or diabt2=1
	group by zip_code, year, month, enrollee_age, sex, race;

*Count the number of Renal disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip23 as
	select zip_code, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_kidn
	from enrollee_pm
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
								master_death_byzip22 master_death_byzip23;
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
								master_death_byzip22 master_death_byzip23;
run;

/*change . to 0*/
data master_cuz; set master_cuz;
	array change _numeric_;
		do over change;
			if change <0 then change=0;
		end;
run;

proc sql;
	create table master_cuz_pm as
	select *
	from master_cuz a
	inner join prcs.pm_zipcd b
	on a.zip_code=b.zip_code and a.year=b.year and a.month=b.month;
quit;

proc sql;
	create table master_cuz_ses as
	select *
	from master_cuz_pm a
	inner join ses.ses_zipcd b
	on a.zip_code=b.zip_code and a.year=b.year ;
quit;

data master_cuz_ses; 
	set master_cuz_ses;
	if enrollee_age <=75 then agel=0; else agel=1;
	if enrollee_age >75 then agem=0; else agem=1;
	if sex="F" then sexF=0; else sexF=1;
	if sex="M" then sexM=0; else sexM=1;
	if race="W" then raceW=0; else raceW=1;
	if race="N" then raceNW=0; else raceNW=1;
	pmagel=pm_1yr*agel;
	pmagem=pm_1yr*agem;
	pmsexF=pm_1yr*sexF;
	pmsexM=pm_1yr*sexM;
	pmraceW=pm_1yr*raceW;
	pmraceNW=pm_1yr*raceNW;
run;

data master_cuz_ses; 
	length StrID $6.; 
	set master_cuz_ses;
	agec = STRIP(PUT(enrollee_age, z2.));
	StrID = agec || sex || race;
	drop agec enrollee_age sex race year month state
	     pm_1mo pm_6mo pm_2yr pm_3yr pm_4yr pm_5yr;
run;

proc export 
	data=master_cuz_ses
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/analysis/ndi-pm-zipcd-asr.csv'  
	dbms=csv replace;
run;





