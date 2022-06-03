/* Created by Fatemeh K (01-02-2021)																*/
/* Create an aggregate data by the site																*/
/* Dataset aggregated number of enrolleess and deaths by site, year, month, age, sex and race    	*/
/* Focus on 2000 (Dec) to 2008 (Dec) data                                              				*/
/* Include SES data from IRS                                                                        */

libname prcs '/scratch/fatemehkp/projects/data/processed';

proc sql;
	create table enrollee_pmc as
	select a.*
	from prcs.enrollee65_ndi_0008_clean a 
	inner join prcs.comp_site_zip_bz12 b
	on a.zip_code=b.zip_code and a.year=b.year and a.month=b.month
	where sex ne 'U';
quit;

data enrollee_pmc; 
	set enrollee_pmc;
	if race='W' then race='W';
		else race='N';
run;

/****************************************************************************/
/* Compute MASTER file                                                      */
/****************************************************************************/
proc sql;
*Count the number of enrollees of age a, sex s and race r by zipcode z at the beginning of the month t ;
	create table master_enrollee_byzip as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_enrollee
	from enrollee_pmc
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of all-cause death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip1 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_allcuz
	from enrollee_pmc
	where allcuz=1
	group by site_id, year, month, enrollee_age, sex, race;
	
*Count the number of non-accidental death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip2 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_nacc
	from enrollee_pmc
	where nacc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of accidental death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip3 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_acc
	from enrollee_pmc
	where acc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of CVD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip4 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cvd
	from enrollee_pmc
	where cvd=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip5 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cvd_t
	from enrollee_pmc
	where cvd=1 or cvd_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of IHD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip6 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ihd
	from enrollee_pmc
	where ihd=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip7 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ihd_t
	from enrollee_pmc
	where ihd=1 or ihd_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of CHF death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip8 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_chf
	from enrollee_pmc
	where chf=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip9 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_chf_t
	from enrollee_pmc
	where chf=1 or chf_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of CBV death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip10 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cbv
	from enrollee_pmc
	where cbv=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip11 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_cbv_t
	from enrollee_pmc
	where cbv=1 or cbv_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Respiratory death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip12 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_resp
	from enrollee_pmc
	where resp=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip13 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_resp_t
	from enrollee_pmc
	where resp=1 or resp_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of COPD death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip14 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_copd
	from enrollee_pmc
	where copd=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip15 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_copd_t
	from enrollee_pmc
	where copd=1 or copd_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Pneumonia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip16 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_pneu
	from enrollee_pmc
	where pneu=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip17 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_pneu_t
	from enrollee_pmc
	where pneu=1 or pneu_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of URI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip18 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_uri
	from enrollee_pmc
	where uri=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip19 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_uri_t
	from enrollee_pmc
	where uri=1 or uri_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of ARDS death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip20 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ards
	from enrollee_pmc
	where ards=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip21 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_ards_t
	from enrollee_pmc
	where ards=1 or ards_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip22 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_canc
	from enrollee_pmc
	where canc=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip23 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_canc_t
	from enrollee_pmc
	where canc=1 or canc_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Lung Cancer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip24 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_lungc
	from enrollee_pmc
	where lungc=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip25 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_lungc_t
	from enrollee_pmc
	where lungc=1 or lungc_rc=1
	group by site_id, year, month, enrollee_age, sex, race;
	
*Count the number of Sepsis death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip26 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_seps
	from enrollee_pmc
	where seps=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip27 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_seps_t
	from enrollee_pmc
	where seps=1 or seps_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Vascular Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip28 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_VaD
	from enrollee_pmc
	where VaD=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip29 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_VaD_t
	from enrollee_pmc
	where VaD=1 or VaD_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Alzheimer death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip30 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_AD
	from enrollee_pmc
	where AD=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip31 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_AD_t
	from enrollee_pmc
	where AD=1 or AD_rc=1
	group by site_id, year, month, enrollee_age, sex, race;
	
*Count the number of Neurodegenerative Disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip32 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_NeD
	from enrollee_pmc
	where NeD=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip33 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_NeD_t
	from enrollee_pmc
	where NeD=1 or NeD_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Unspecified Dementia death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip34 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_UsD
	from enrollee_pmc
	where UsD=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip35 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_UsD_t
	from enrollee_pmc
	where UsD=1 or UsD_rc=1
	group by site_id, year, month, enrollee_age, sex, race;
	
*Count the number of Diabete typeI death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip36 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt1
	from enrollee_pmc
	where diabt1=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip37 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt1_t
	from enrollee_pmc
	where diabt1=1 or diabt1_rc=1
	group by site_id, year, month, enrollee_age, sex, race;


*Count the number of Diabete typeII death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip38 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt2
	from enrollee_pmc
	where diabt2=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip39 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diabt2_t
	from enrollee_pmc
	where diabt2=1 or diabt2_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Diabete death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip40 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diab
	from enrollee_pmc
	where diabt1=1 or diabt2=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip41 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_diab_t
	from enrollee_pmc
	where diabt1=1 or diabt2=1 or diabt1_rc=1 or diabt2_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

*Count the number of Renal disease death among enrollees of age a, sex s and race r by zipcode c during month t ;
/* ICD CODE */
	create table master_death_byzip42 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_kidn
	from enrollee_pmc
	where kidn=1
	group by site_id, year, month, enrollee_age, sex, race;

/* ICD CODE or 1-8 Underlying Cause of Death*/
	create table master_death_byzip43 as
	select site_id, year, month, enrollee_age, sex, race, count(distinct BENE_ID) as no_death_kidn_t
	from enrollee_pmc
	where kidn=1 or kidn_rc=1
	group by site_id, year, month, enrollee_age, sex, race;

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
								master_death_byzip25 master_death_byzip26 master_death_byzip27
								master_death_byzip28 master_death_byzip29 master_death_byzip30
								master_death_byzip31 master_death_byzip32 master_death_byzip33
								master_death_byzip34 master_death_byzip35 master_death_byzip36
								master_death_byzip37 master_death_byzip38 master_death_byzip39
								master_death_byzip40 master_death_byzip41 master_death_byzip42
								master_death_byzip43;
	by site_id year month enrollee_age sex race;
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
								master_death_byzip25 master_death_byzip26 master_death_byzip27
								master_death_byzip28 master_death_byzip29 master_death_byzip30
								master_death_byzip31 master_death_byzip32 master_death_byzip33
								master_death_byzip34 master_death_byzip35 master_death_byzip36
								master_death_byzip37 master_death_byzip38 master_death_byzip39
								master_death_byzip40 master_death_byzip41 master_death_byzip42
								master_death_byzip43;
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
	on a.site_id=b.site_id and a.year=b.year and a.month=b.month;
quit;

proc sql;
	create table master_cuz_ses as
	select *
	from master_cuz_pm a
	inner join prcs.ses_zipcd b
	on a.site_id=b.site_id and a.year=b.year ;
quit;

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
	outfile='/scratch/fatemehkp/projects/data/csv/master_ndi_pmc_bz12.csv'  
	dbms=csv replace;
run;

proc sort data = master_cuz_ses nodupkey out = prcs.site_ndi_pmc_bz12 (keep site_id);
	by site_id;
run;




