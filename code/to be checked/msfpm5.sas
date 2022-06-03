/* Created by Fatemeh K (05-29-2020)																*/
/* Create an aggregate data by the zipcode															*/
/* Dataset aggregated number of enrolleess and deaths by zipcode, year, month, age, sex and race    */
/* Focus on 2000 (Jan) to 2008 data                                              					*/
/* Include SES data from IRS                                                                        */

libname cms  '/scratch/fatemehkp/Utah/CMS_Merged';
libname jeff '/scratch/fatemehkp/Utah/Jeff';
libname ses  '/scratch/fatemehkp/Utah/SES';
libname epa  '/scratch/fatemehkp/Utah/EPAAQS';
libname bech '/scratch/fatemehkp/Utah/Bechle';


data enrollee_ndi_pm; length races $2.; set cms.enrollee_ndi_pm_0;
if race='W' then races='W';
	else races='NW';
run;

/****************************************************************************/
/* Compute MASTER file                                                      */
/****************************************************************************/
proc sql;
*Count the number of enrollees of age a, sex s and race r by zipcode m at the beginning of the month t ;
create table master_enrollee_byzip as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_enrollee
from enrollee_ndi_pm
group by zip_code, year, month, enrollee_age, sex, races;

*Count the number of sepsis death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
create table master_death_byzip1 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_seps
from enrollee_ndi_pm
where seps=1
group by zip_code, year, month, enrollee_age, sex, races;

/* ICD CODE or 1-8 Underlying Cause of Death*/
create table master_death_byzip10 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_seps_t
from enrollee_ndi_pm
where seps=1 or seps_rc=1
group by zip_code, year, month, enrollee_age, sex, races;


*Count the number of diabete typeI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
create table master_death_byzip2 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_diabt1
from enrollee_ndi_pm
where diabt1=1
group by zip_code, year, month, enrollee_age, sex, races;

/* ICD CODE or 1-8 Underlying Cause of Death*/
create table master_death_byzip20 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_diabt1_t
from enrollee_ndi_pm
where diabt1=1 or diabt1_rc=1
group by zip_code, year, month, enrollee_age, sex, races;


*Count the number of diabete typeII death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
create table master_death_byzip3 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_diabt2
from enrollee_ndi_pm
where diabt2=1
group by zip_code, year, month, enrollee_age, sex, races;

/* ICD CODE or 1-8 Underlying Cause of Death*/
create table master_death_byzip30 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_diabt2_t
from enrollee_ndi_pm
where diabt2=1 or diabt2_rc=1
group by zip_code, year, month, enrollee_age, sex, races;

*Count the number of diabete death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
create table master_death_byzip4 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_diab
from enrollee_ndi_pm
where diabt1=1 or diabt2=1
group by zip_code, year, month, enrollee_age, sex, races;

/* ICD CODE or 1-8 Underlying Cause of Death*/
create table master_death_byzip40 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_diab_t
from enrollee_ndi_pm
where diabt1=1 or diabt2=1 or diabt1_rc=1 or diabt2_rc=1
group by zip_code, year, month, enrollee_age, sex, races;


*Count the number of renal disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
create table master_death_byzip5 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_kidn
from enrollee_ndi_pm
where kidn=1
group by zip_code, year, month, enrollee_age, sex, races;

/* ICD CODE or 1-8 Underlying Cause of Death*/
create table master_death_byzip50 as
select zip_code, year, month, enrollee_age, sex, races, count(distinct BENE_ID) as no_death_kidn_t
from enrollee_ndi_pm
where kidn=1 or kidn_rc=1
group by zip_code, year, month, enrollee_age, sex, races;

quit;

data master_cuz;
	merge master_enrollee_byzip master_death_byzip1 master_death_byzip10
								master_death_byzip2 master_death_byzip20
								master_death_byzip3 master_death_byzip30
								master_death_byzip4 master_death_byzip40
								master_death_byzip5 master_death_byzip50;
	by zip_code year month enrollee_age sex races;
run;

proc datasets nolist;
	delete master_enrollee_byzip master_death_byzip1 master_death_byzip10
								 master_death_byzip2 master_death_byzip20
								 master_death_byzip3 master_death_byzip30
								 master_death_byzip4 master_death_byzip40
								 master_death_byzip5 master_death_byzip50;
run;


/*change . to 0*/
data master_cuz; set master_cuz;
	array change _numeric_;
		do over change;
			if change <0 then change=0;
		end;
run;

proc sql;
create table master_cuz as
select *
from master_cuz a
inner join jeff.pm_zipcd b
on a.zip_code=b.zip_code and a.year=b.year and a.month=b.month
where pm_5yr is not null;
quit;

proc sql;
create table master_cuz_ses as
select *
from master_cuz a
inner join ses.ses b
on a.zip_code=b.zip_code and a.year=b.year ;
quit;

data master_cuz_ses; length StrID $6.; 
set master_cuz_ses;
	agec = STRIP(PUT(enrollee_age, z2.));
	StrID= agec || sex || races;
drop agec enrollee_age sex races year month state
	 pm_1mo pm_6mo;
run;


proc export data=master_cuz_ses
outfile='/scratch/fatemehkp/Utah/Data_Center/master_group1_pm5.csv'  
dbms=csv replace;
run;


