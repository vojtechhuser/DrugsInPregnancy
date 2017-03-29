{DEFAULT @cdm_database_schema = 'mdcr_v5'}
{DEFAULT @person_limit = 10}

drop table @work_database_schema.fcohort;
create table @work_database_schema.fcohort as
select * from @cdm_database_schema.procedure_occurrence 
where procedure_concept_id  in 
(2110307,2110308,2110309,2110320,2110321,2110319,2110322,2110323,2110324,2110315,2110318,2110316,2110317)
and procedure_date <= '2014-12-31'
and procedure_date >= '2003-12-30'

--limit @person_limit
;

--join age
drop table @work_database_schema.fcohort2;
create table @work_database_schema.fcohort2 as
select cast(a.person_id as varchar)+substring(cast(a.procedure_date as varchar),1,7) as preg_id
 ,datepart(y,procedure_date)-p.year_of_birth as preg_age, a.*,p.year_of_birth, p.gender_concept_id 
from @work_database_schema.fcohort a 
join @cdm_database_schema.person p on a.person_id = p.person_id
where datepart(y,procedure_date)-p.year_of_birth between 12 and 55
;
--create study tables
drop table @work_database_schema.fout1;

create table @work_database_schema.fout1 as
select a.drug_exposure_start_date - c.procedure_date as rel_time, a.*
,c.preg_id,c.procedure_date,c.year_of_birth
from @cdm_database_schema.drug_exposure a join @work_database_schema.fcohort2 c on a.person_id = c.person_id
where a.drug_exposure_start_date - c.procedure_date between -363 and  0;
