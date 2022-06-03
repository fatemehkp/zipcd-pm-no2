/* Created by Vivian C. Pun on 10/1/2017 to create new daily PM2.5 Jeff dataset */
/* Adopted from pm_j_merge2b.sas and pm_j_merge2c.sas programs */
/* Use key.pm_j_mvavgs to create a merged daily PM data  */


ods html close; ods listing;

libname zip '/scratch/mouse84/mycmsdata/data/jeff/allocations';
libname jeff '/scratch/mouse84/mycmsdata/data/jeff/pm';
libname ccw '/scratch/mouse84/mycmsdata/data/ab_summary';
libname key '/gss_gpfs_scratch/mouse84/suhgroup/jeff/dailypm25';
libname sample '/scratch/mouse84/mycmsdata/data/jeff/sample';


/* To merge the new region_zip_census data from Ilana (from Dec 2015 files) */

* Written by R;
*  write.foreign(df = zip_region05, datafile = "/Users/vivian/Dropbox (linweit)/Vpun/Northeastern/research/Medicare/data/jeff_grids/zip_region05.csv",  ;
DATA  rdata05 ;
LENGTH
 zip_code $ 5
 St $ 2
 st_FIPS $ 2
 Region $ 9
 Name $ 26
 ObjectID $ 6
;

INFILE  "/scratch/mouse84/mycmsdata/data/jeff/allocations/zip_region05.csv"
     DSD
     LRECL= 201 ;
INPUT
 zip_code
 St
 st_FIPS
 Region
 TotalPop
 Pop25over
 HSover
 Urban
 Black
 Hispanic
 MedianIncome
 Distance_Result
 Name
 ObjectID
 Xinkm
 Yinkm
 Y_m
 X_m
;
RUN;

* Written by R;
*  write.foreign(df = zip_region10, datafile = "/Users/vivian/Dropbox (linweit)/Vpun/Northeastern/research/Medicare/data/jeff_grids/zip_region10.csv",  ;
DATA  rdata10 ;
LENGTH
 zip_code $ 5
 St $ 2
 st_FIPS $ 2
 Region $ 9
 Name $ 14
 ObjectID $ 6
;

INFILE  "/scratch/mouse84/mycmsdata/data/jeff/allocations/zip_region10.csv"
     DSD
     LRECL= 180 ;
INPUT
 zip_code
 St
 st_FIPS
 Region
 TotalPop
 Pop25over
 HSover
 Black
 Hispanic
 MedianIncome
 Distance_Result
 Name
 ObjectID
 Xinkm
 Yinkm
 Y_m
 X_m
;
RUN;

data zip2005; set rdata05;
  format xinmeter 19.0 yinmeter 19.0;
  xinmeter=x_m; yinmeter=y_m;
  drop Name ObjectID; run;

data zip2010; set rdata10;
  format xinmeter 19.0 yinmeter 19.0;
  xinmeter=x_m; yinmeter=y_m;
  drop Name ObjectID; run;

/* Break pm file into 2*/
data pm_j_dailyA pm_j_dailyB; set key.pm_j_mvavgs;
if yr le 2005 then output pm_j_dailyA;
else if yr gt 2005 then output pm_j_dailyB;
run;


proc sql;
create table pm_j_daily_zipA as
select *
from zip2005 as a , pm_j_dailyA as b
where a.xinmeter=b.xinmeter and
      a.yinmeter=b.yinmeter
order by zip_code, yr, mo, day;


create table pm_j_daily_zipB as
select *
from zip2010 as a , pm_j_dailyB as b
where a.xinmeter=b.xinmeter and
      a.yinmeter=b.yinmeter
order by zip_code, yr, mo, day;
quit;


data jeff.pm_j_daily_zip2;
set pm_j_daily_zipA pm_j_daily_zipB;
run;


proc sql;
select count(distinct zip_code) as zip_dailyzip2
from jeff.pm_j_daily_zip2;

select count(distinct zip_code) as zip_mvavgszipC
from jeff.pm_j_mvavgs_zipC;
quit;


/* Add additional vintage zip codes from  Becky (Zip_Allocations_Merge_2000-2011.txt) */
data WORK.ZIP0011    ;
             %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
             infile '/scratch/mouse84/mycmsdata/data/jeff/allocations/Zip_Allocations_Merge_2000-2011.txt' delimiter = '|'
        MISSOVER DSD lrecl=32767 firstobs=2 ;
                informat year $6. ;
                informat ZIP $7. ;
                informat Distance_Result best32. ;
                informat Name $17. ;
                informat State $4. ;
                informat Objectid $8. ;
                informat Xinkm best32. ;
                informat Yinkm best32. ;
                informat X_m best32. ;
                informat Y_m best32. ;
                format year $6. ;
                format ZIP $7. ;
                format Distance_Result best12. ;
                format Name $17. ;
                format State $4. ;
                format Objectid $8. ;
                format Xinkm 19.0 ;
                format Yinkm 19.0 ;
                format X_m 19.0 ;
                format Y_m 19.0 ;
             input
                         year $
                         ZIP $
                         Distance_Result
                         Name $
                         State $
                         Objectid $
                         Xinkm
                         Yinkm
                         X_m
                         Y_m
             ;
             if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
             run;


data zip0011b; set zip0011;
  format xinmeter 19.0 yinmeter 19.0 ;
  xinmeter=x_m; yinmeter=y_m;
  yr =input(year,4.0);
  rename zip=zip_code;
  drop Name Objectid y_m x_m year; run;



data zip0011b; set zip0011;
  format xinmeter 19.0 yinmeter 19.0 ;
  xinmeter=x_m; yinmeter=y_m;
  yr =input(year,4.0);
  rename zip=zip_code;
  drop Name Objectid y_m x_m year; run;


proc sql;
create table pm_j_daily_zipC as
select *
from zip0011b as a , key.pm_j_mvavgs as b
where a.xinmeter=b.xinmeter and
      a.yinmeter=b.yinmeter and
      a.yr=b.yr
order by zip_code, yr, mo, day;

data jeff.pm_j_daily_zip2;
set jeff.pm_j_daily_zip2 pm_j_daily_zipC;
run;

proc sql;
create table jeff.pm_j_daily_zip2 as
select distinct *
from jeff.pm_j_daily_zip2; 

select count(distinct zip_code)
from jeff.pm_j_daily_zip2;

select count(distinct zip_code)
from jeff.pm_j_mvavgs_zipD;
quit;


endsas;

proc sql;
create table jeff.pm_j_daily_zip as 
select distinct *
from jeff.pm_j_daily_zip;

select count(distinct zip_code)
from jeff.pm_j_daily_zip;

quit;


/* Merging and matching */
/*
data pm_zip; set jeff.pm_j_daily_zip;
rename yr = bene_enrollmt_ref_yr mo=month ; 
drop day;
run;

%macro key(dat,year);
data enrollee; set key.&dat ; 
format year 8.0 ;
year = bene_enrollmt_ref_yr;
drop bene_enrollmt_ref_yr bene_enrollmt__ref_yr;
rename year = bene_enrollmt_ref_yr;
run;

proc sql;
create table key.enrollee65_jpm_&year_daily as 
select * 
from enrollee as a, pm_zip as b
where a.zip_code = b.zip_code and a.bene_enrollmt_ref_yr = b.bene_enrollmt_ref_yr and a.month = b.month and a.day = b.day; 
quit;
%mend;


%key(enrollee65_0012, 0011);
*%key(enrollee65_ndi_0008, ndi_0008);




