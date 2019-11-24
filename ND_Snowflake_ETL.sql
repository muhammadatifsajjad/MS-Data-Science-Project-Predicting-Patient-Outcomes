drop table if exists DB_UNIMELB_STAGE.STAGE.temp_pbs_nhs_code_disease_group;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_pbs_nhs_code_disease_group as
select  nhs_dispensed_code
	  , disease_group
from
(
	select  nhs_dispensed_code
		  , disease_group
	  	  , row_number() over (partition by nhs_dispensed_code order by disease_count desc) rn
	from 
	(
		select distinct nhs_dispensed_code
					  , disease_group
				      , count(*) disease_count
		from PPO.PBSCODETODISEASECONDITIONMAPPING
		group by nhs_dispensed_code, disease_group
	) a
) b
where rn <= 5;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date as
select 	MASTERPATIENTID
	  , DISPENSECALENDARDATE
	  , lag(DISPENSECALENDARDATE, 1)  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) PREVDISPENSEDATE
from
(
	select distinct 
			 MASTERPATIENTID
		   , DISPENSECALENDARDATE
	 from PPO.FACTSCRIPT a
) a;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history as 
select 
      MASTERPATIENTID
    , DISPENSECALENDARDATE
	, DAYSLAG_DISP_PRESC
    , DAYSLAG_MED_PREVMED
    , PBSDISEASEGROUP
    , BATCHID
    , GENERICINGREDIENTNAME
	, ATCLEVEL3CODE
	, ATCLEVEL4CODE
    , ATCLEVEL5CODE
from
	(
     select 	  
             a.MASTERPATIENTID
           , a.DISPENSECALENDARDATE
		   , ifnull(datediff(day, A.PRESCRIPTIONDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_DISP_PRESC
           , ifnull(datediff(day, e.PREVDISPENSEDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_MED_PREVMED
           , d.disease_group PBSDISEASEGROUP
           , c.BATCHID
           , b.GENERICINGREDIENTNAME
		   , b.ATCLEVEL3CODE
		   , b.ATCLEVEL4CODE
           , b.ATCLEVEL5CODE
     from 
	 (
		select distinct
			    MASTERPATIENTID
			  , PRESCRIPTIONDATE
			  , DISPENSECALENDARDATE
			  , MASTERPRODUCTID
		      , NHSDISPENSEDCODE
		from PPO.FACTSCRIPT
	 ) a 
     left join 
	 (
		 select distinct 
			   MASTERPRODUCTID
			 , GENERICINGREDIENTNAME
			 , ATCLEVEL3CODE
			 , ATCLEVEL4CODE
			 , ATCLEVEL5CODE
		from PPO.DIMPRODUCTMASTER
	 ) b
     on a.MASTERPRODUCTID = b.MASTERPRODUCTID
     left join 
	 (
	 	select MASTERPRODUCTID, MIN(ISRDBATCHID) BATCHID
		from PPO.ISRD	
		group by MASTERPRODUCTID
	 ) c
     on a.MASTERPRODUCTID = c.MASTERPRODUCTID
     left join DB_UNIMELB_STAGE.STAGE.temp_pbs_nhs_code_disease_group d
     on a.NHSDISPENSEDCODE = d.NHS_DISPENSED_CODE
     left join DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date e
     on a.MASTERPATIENTID = e.MASTERPATIENTID and a.DISPENSECALENDARDATE = e.DISPENSECALENDARDATE
	) a;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_split_intermediate;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_split_intermediate as 
select MASTERPATIENTID
	 , FROM_DATE
 	 , TO_DATE
  	 , PATIENT_TIME_SERIES
from
(
	select MASTERPATIENTID
		 , lag(DISPENSECALENDARDATE, 1, '1900-01-01')  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) FROM_DATE
		 , dateadd(day, -1, DISPENSECALENDARDATE) TO_DATE
	     , PATIENT_TIME_SERIES
	from
	(
		select MASTERPATIENTID
			 , DISPENSECALENDARDATE
			 , PATIENT_TIME_SERIES
			 , row_number() over (partition by MASTERPATIENTID, PATIENT_TIME_SERIES order by DISPENSECALENDARDATE asc) rn
		from
		(
			select  MASTERPATIENTID
		          , GENERICINGREDIENTNAME
	              , DISPENSECALENDARDATE
	              , DAYSLAG_MED_PREVMED
				  , case when PATIENT_CASE = 0
			   			 then 0 
			   			 else dense_rank() over (partition by MASTERPATIENTID, PATIENT_CASE order by DISPENSECALENDARDATE asc) end PATIENT_TIME_SERIES
			from
			(
				select  MASTERPATIENTID
			          , GENERICINGREDIENTNAME
		              , DISPENSECALENDARDATE
	                  , DAYSLAG_MED_PREVMED
	                  , case when DAYSLAG_MED_PREVMED >= 180 then 1 else 0 end PATIENT_CASE
				from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history
			) a
		) b
	) c
	where rn = 1
) d;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_split;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_split as
select  MASTERPATIENTID
      , FROM_DATE
      , TO_DATE
      , PATIENT_TIME_SERIES
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_split_intermediate
UNION
select  MASTERPATIENTID
      , dateadd(DAY, 1, max(to_date)) FROM_DATE
      , '3000-01-01' TO_DATE
      , max(PATIENT_TIME_SERIES) + 1 PATIENT_TIME_SERIES
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_split_intermediate
group by MASTERPATIENTID;

drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_split;
create temporary table DB_UNIMELB_STAGE.STAGE.nd_patient_history_split as 
select  a.MASTERPATIENTID ORIGINALMASTERPATIENTID
	  , CONCAT(a.MASTERPATIENTID, '_', b.PATIENT_TIME_SERIES) MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , a.DAYSLAG_DISP_PRESC
      , a.DAYSLAG_MED_PREVMED
      , a.PBSDISEASEGROUP
      , a.BATCHID
      , a.GENERICINGREDIENTNAME
	  , a.ATCLEVEL3CODE
	  , a.ATCLEVEL4CODE
      , a.ATCLEVEL5CODE
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history a
left join DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_split b
on a.MASTERPATIENTID = b.MASTERPATIENTID
and a.DISPENSECALENDARDATE between b.FROM_DATE and b.TO_DATE;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases as 
select  ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
      , DISPENSECALENDARDATE
	  , PBSDISEASEGROUP
	  , row_number() over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) seq_no
	  , dense_rank() over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) seq_no_1
from 
( 
	select  row_number() over (partition by MASTERPATIENTID, PBSDISEASEGROUP order by DISPENSECALENDARDATE asc) rn
		  , ORIGINALMASTERPATIENTID
	      , MASTERPATIENTID
		  , DISPENSECALENDARDATE
		  , PBSDISEASEGROUP
	from DB_UNIMELB_STAGE.STAGE.nd_patient_history_split
	where PBSDISEASEGROUP is not NULL 
) a 
where rn = 1;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_diseases;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_diseases as
select 	ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
	  , DISPENSECALENDARDATE
	  , lag(DISPENSECALENDARDATE, 1)  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) PREVDISPENSEDATE
from
(
	select distinct 
			 ORIGINALMASTERPATIENTID
		   , MASTERPATIENTID
		   , DISPENSECALENDARDATE
	 from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases a
) a;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases_intermediate;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases_intermediate as 
select  a.ORIGINALMASTERPATIENTID
	  , a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , ifnull(datediff(day, b.PREVDISPENSEDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_DIS_PREVDIS
	  , a.PBSDISEASEGROUP
	  , seq_no
	  , seq_no_1
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases a
left join DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_diseases b
on a.MASTERPATIENTID = b.MASTERPATIENTID and a.DISPENSECALENDARDATE = b.DISPENSECALENDARDATE;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_filter;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_filter as 
select MASTERPATIENTID 
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases_intermediate 
group by MASTERPATIENTID
having COUNT(distinct DISPENSECALENDARDATE) > 2;
	
drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_diseases_final;
create table DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_diseases_final as 
select  a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , a.DAYSLAG_DIS_PREVDIS
	  , a.PBSDISEASEGROUP
	  , a.seq_no
	  , a.seq_no_1
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_diseases_intermediate a
inner join DB_UNIMELB_STAGE.STAGE.temp_nd_patient_filter b
on a.MASTERPATIENTID = b.MASTERPATIENTID;

drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_split_final;
create table DB_UNIMELB_STAGE.STAGE.nd_patient_history_split_final as 
select  a.ORIGINALMASTERPATIENTID
	  , a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , a.DAYSLAG_DISP_PRESC
      , a.DAYSLAG_MED_PREVMED
      , a.PBSDISEASEGROUP
      , a.BATCHID
      , a.GENERICINGREDIENTNAME
	  , a.ATCLEVEL3CODE
	  , a.ATCLEVEL4CODE
      , a.ATCLEVEL5CODE
from DB_UNIMELB_STAGE.STAGE.nd_patient_history_split a
inner join DB_UNIMELB_STAGE.STAGE.temp_nd_patient_filter b
on a.MASTERPATIENTID = b.MASTERPATIENTID;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_medicines;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_medicines as 
select  ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
      , DISPENSECALENDARDATE
	  , GENERICINGREDIENTNAME
	  , PBSDISEASEGROUP
	  , row_number() over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) seq_no
from 
( 
	select  row_number() over (partition by MASTERPATIENTID, GENERICINGREDIENTNAME order by DISPENSECALENDARDATE asc) rn
	      , ORIGINALMASTERPATIENTID
		  , MASTERPATIENTID
		  , DISPENSECALENDARDATE
		  , GENERICINGREDIENTNAME
		  , PBSDISEASEGROUP
	from DB_UNIMELB_STAGE.STAGE.nd_patient_history_split_final
) a 
where rn = 1;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_medicines;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_medicines as
select 	ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
	  , DISPENSECALENDARDATE
	  , lag(DISPENSECALENDARDATE, 1)  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) PREVDISPENSEDATE
from
(
	select distinct 
			 ORIGINALMASTERPATIENTID
		   , MASTERPATIENTID
		   , DISPENSECALENDARDATE
	 from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_medicines a
) a;

drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_medicines_final;
create table DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_medicines_final as 
select  a.ORIGINALMASTERPATIENTID
	  , a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , ifnull(datediff(day, b.PREVDISPENSEDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_MED_PREVMED
	  , A.GENERICINGREDIENTNAME
	  , a.PBSDISEASEGROUP
	  , seq_no
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_medicines a
left join DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_medicines b
on a.MASTERPATIENTID = b.MASTERPATIENTID and a.DISPENSECALENDARDATE = b.DISPENSECALENDARDATE;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel3code;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel3code as 
select  ORIGINALMASTERPATIENTID
	  ,	MASTERPATIENTID
      , DISPENSECALENDARDATE
	  , ATCLEVEL3CODE
	  , row_number() over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) seq_no
from 
( 
	select  row_number() over (partition by MASTERPATIENTID, ATCLEVEL3CODE order by DISPENSECALENDARDATE asc) rn
		  , ORIGINALMASTERPATIENTID
	      , MASTERPATIENTID
		  , DISPENSECALENDARDATE
		  , ATCLEVEL3CODE
	from DB_UNIMELB_STAGE.STAGE.nd_patient_history_split_final
) a 
where rn = 1;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel3code;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel3code as
select 	ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
	  , DISPENSECALENDARDATE
	  , lag(DISPENSECALENDARDATE, 1)  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) PREVDISPENSEDATE
from
(
	select distinct 
			 ORIGINALMASTERPATIENTID
		   , MASTERPATIENTID
		   , DISPENSECALENDARDATE
	 from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel3code a
) a;

drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_atclevel3code_final;
create table DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_atclevel3code_final as 
select  a.ORIGINALMASTERPATIENTID
	  , a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , ifnull(datediff(day, b.PREVDISPENSEDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_ATC_PREVATC
	  , A.ATCLEVEL3CODE
	  , seq_no
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel3code a
left join DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel3code b
on a.MASTERPATIENTID = b.MASTERPATIENTID and a.DISPENSECALENDARDATE = b.DISPENSECALENDARDATE;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel4code;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel4code as 
select  ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
      , DISPENSECALENDARDATE
	  , ATCLEVEL4CODE
	  , row_number() over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) seq_no
from 
( 
	select  row_number() over (partition by MASTERPATIENTID, ATCLEVEL4CODE order by DISPENSECALENDARDATE asc) rn
	      , ORIGINALMASTERPATIENTID
		  , MASTERPATIENTID
		  , DISPENSECALENDARDATE
		  , ATCLEVEL4CODE
	from DB_UNIMELB_STAGE.STAGE.nd_patient_history_split_final
) a 
where rn = 1;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel4code;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel4code as
select 	ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
	  , DISPENSECALENDARDATE
	  , lag(DISPENSECALENDARDATE, 1)  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) PREVDISPENSEDATE
from
(
	select distinct 
			 ORIGINALMASTERPATIENTID
		   , MASTERPATIENTID
		   , DISPENSECALENDARDATE
	 from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel4code a
) a;
	
drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_atclevel4code_final;
create table DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_atclevel4code_final as 
select  a.ORIGINALMASTERPATIENTID
	  , a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , ifnull(datediff(day, b.PREVDISPENSEDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_ATC_PREVATC
	  , A.ATCLEVEL4CODE
	  , seq_no
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel4code a
left join DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel4code b
on a.MASTERPATIENTID = b.MASTERPATIENTID and a.DISPENSECALENDARDATE = b.DISPENSECALENDARDATE;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel5code;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel5code as 
select  ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
      , DISPENSECALENDARDATE
	  , ATCLEVEL5CODE
	  , row_number() over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) seq_no
from 
( 
	select  row_number() over (partition by MASTERPATIENTID, ATCLEVEL5CODE order by DISPENSECALENDARDATE asc) rn
	      , ORIGINALMASTERPATIENTID
		  , MASTERPATIENTID
		  , DISPENSECALENDARDATE
		  , ATCLEVEL5CODE
	from DB_UNIMELB_STAGE.STAGE.nd_patient_history_split_final
) a 
where rn = 1;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel5code;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel5code as
select 	ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
	  , DISPENSECALENDARDATE
	  , lag(DISPENSECALENDARDATE, 1)  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) PREVDISPENSEDATE
from
(
	select distinct 
			 ORIGINALMASTERPATIENTID
		   , MASTERPATIENTID
		   , DISPENSECALENDARDATE
	 from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel5code a
) a;

drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_atclevel5code_final;
create table DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_atclevel5code_final as 
select  a.ORIGINALMASTERPATIENTID
	  , a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , ifnull(datediff(day, b.PREVDISPENSEDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_ATC_PREVATC
	  , A.ATCLEVEL5CODE
	  , seq_no
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_atclevel5code a
left join DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_atclevel5code b
on a.MASTERPATIENTID = b.MASTERPATIENTID and a.DISPENSECALENDARDATE = b.DISPENSECALENDARDATE;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_batchid;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_batchid as 
select  ORIGINALMASTERPATIENTID
      , MASTERPATIENTID
      , DISPENSECALENDARDATE
	  , BATCHID
	  , row_number() over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) seq_no
from 
( 
	select  row_number() over(partition by MASTERPATIENTID, BATCHID order by DISPENSECALENDARDATE asc) rn
	      , ORIGINALMASTERPATIENTID
		  , MASTERPATIENTID
		  , DISPENSECALENDARDATE
		  , BATCHID
	from DB_UNIMELB_STAGE.STAGE.nd_patient_history_split_final
) a 
where rn = 1;

drop table if exists DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_batchid;
create temporary table DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_batchid as
select  ORIGINALMASTERPATIENTID
	  , MASTERPATIENTID
	  , DISPENSECALENDARDATE
	  , lag(DISPENSECALENDARDATE, 1)  over (partition by MASTERPATIENTID order by DISPENSECALENDARDATE asc) PREVDISPENSEDATE
from
(
	select distinct 
			 ORIGINALMASTERPATIENTID
		   , MASTERPATIENTID
		   , DISPENSECALENDARDATE
	 from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_batchid a
) a;

drop table if exists DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_batchid_final;
create table DB_UNIMELB_STAGE.STAGE.nd_patient_history_distinct_batchid_final as 
select  a.ORIGINALMASTERPATIENTID
	  , a.MASTERPATIENTID
      , a.DISPENSECALENDARDATE
	  , ifnull(datediff(day, b.PREVDISPENSEDATE, a.DISPENSECALENDARDATE), 0) DAYSLAG_BATCHID_PREVBATCHID
	  , A.BATCHID
	  , seq_no
from DB_UNIMELB_STAGE.STAGE.temp_nd_patient_history_distinct_batchid a
left join DB_UNIMELB_STAGE.STAGE.temp_prev_dispense_date_batchid b
on a.MASTERPATIENTID = b.MASTERPATIENTID and a.DISPENSECALENDARDATE = b.DISPENSECALENDARDATE;