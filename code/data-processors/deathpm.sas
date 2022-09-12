/* Created by Fatemeh K (01-15-2021) (09-08-2022)																*/
/* Focus on 2000 (Jan) to 2008 data                                              					*/
/* Count total numbers and subgroups */
                                    
libname cms '/scratch/fatemehkp/projects/CMS/data/processed';                                   
libname prcs '/scratch/fatemehkp/projects/Zipcode PM NO2/data/processed';


data master0;
	set cms.enrollee65_ndi_0008_clean;
	where sex ne 'U' and pm_1yr ne . and ses_zip ne .;
run;

/* beneficiries at time of death */
data prcs.enrollee_pm_dead;
	set master0;
	where allcuz = 1 or nacc =1 or acc =1 or cvd = 1 or ihd =1 or chf =1 or cbv =1 or 
	resp =1 or copd =1 or pneu =1 or uri =1 or lri =1 or ards =1 or canc =1 or lungc = 1 or seps =1 or
	VaD =1 or UsD =1 or demn =1 or PD =1 or AD =1 or NeD = 1 or MS =1 or diabt1 = 1 or diabt2 =1 or kidn=1;
run;

/*****************************/
/* Total zipcode with dead enrollee */
proc sql;
	title 'Total zipcode with dead enrollee in the US';
	select count(distinct zip_code) as num_zipcode
	from prcs.enrollee_pm_dead;
quit;


data enrollee_pm_dead;
	set prcs.enrollee_pm_dead;
	bene_code + 1;
	drop bene_id zip_code;
run;


proc export
	data= enrollee_pm_dead
	outfile='/scratch/fatemehkp/projects/Zipcode PM NO2/data/processed/enrollee_pm_dead.csv'
	dbms=csv
	replace;
run;



