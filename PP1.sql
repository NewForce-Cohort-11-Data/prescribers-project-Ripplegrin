-- ****a* Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
-- david coffey 4538
-- npi and number of claims
-- select nppes_provider_last_org_name, prescription.npi, total_claim_count 
-- 	from prescription
-- 	left join prescriber
-- 	on prescriber.npi=prescription.npi
-- order by total_claim_count desc
-- limit 1 -- limits it to the top most


-- ****b* Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.
/*
select nppes_provider_first_name, nppes_provider_last_org_name, prescription.npi, specialty_description, total_claim_count 
	from prescription
	left join prescriber
	on prescriber.npi=prescription.npi
order by total_claim_count desc
limit 1
*/

-- ****a*. Which specialty had the most total number of claims (totaled over all drugs)? family practice

-- select specialty_description, sum(total_claim_count) 
-- 	from prescription
-- 	left join prescriber
-- 	on prescriber.npi=prescription.npi
-- group by specialty_description -- combines all the same SD into one row
-- order by sum(total_claim_count) desc

 -- select opioid_drug_flag -- to figure out letters for the flag, safe to ignore
 -- from drug

 
-- ****b*. Which specialty had the most total number of claims for opioids? nurse practitioner
-- select specialty_description, sum(total_claim_count) 
-- 	from prescription
-- 	left join prescriber
-- 	on prescriber.npi=prescription.npi
-- 	left join drug
-- 	on drug.drug_name = prescription.drug_name
-- where opioid_drug_flag = 'Y'
-- group by specialty_description -- combines all the same SD into one row
-- order by sum(total_claim_count) desc


-- c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
-- d. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- ****3A*. Which drug (generic_name) had the highest total drug cost? pirfenidone
-- select generic_name, total_drug_cost
-- 	from prescription
-- 	left join drug
-- 	on drug.drug_name=prescription.drug_name
-- order by total_drug_cost desc

-- ***b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. 
-- Google ROUND to see how this works. PIRFENIDONE


-- select generic_name, round(total_drug_cost/365) as daily_cost
-- 	from prescription
-- 	left join drug
-- 	on drug.drug_name=prescription.drug_name
-- order by daily_cost desc






-- ****4a.* For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 
--'opioid' for drugs which have opioid_drug_flag = 'Y', 
--says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', 
-- says 'neither' for all other drugs. 
--Hint: You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/
-- select drug_name 
-- then ifthenelif for the 3 varities

-- select drug_name,
-- 	Case
-- 		WHEN opioid_drug_flag = 'Y' then 'opioid'
-- 		WHEN antibiotic_drug_flag = 'Y' then 'antibiotic'
-- 		ELSE 'neither'
-- end as drug_type
 
-- from drug
-- select drug_name, drug_type


-- b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics.
-- Hint: Format the total costs as MONEY for easier comparision.
-- select drug_name,
-- 	Case
-- 		WHEN opioid_drug_flag = 'Y' then 'opioid'
-- 		WHEN antibiotic_drug_flag = 'Y' then 'antibiotic'
-- 		ELSE 'neither'
-- end as drug_type

-- from drug







-- ***5a*. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee. 35
-- select count(cbsaname)
-- from cbsa
-- 	left join fips_county 
-- 		on fips_county.fipscounty=cbsa.fipscounty
-- where fips_county.state = 'KY'

-- ***b*. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population. 
--Memphis, TN-MS-AR 937847
-- Nashville-Davidson--Murfreesboro--Franklin, TN 8773
-- select cbsaname, population

-- from cbsa --obviously using this as the base
-- left join population
-- on population.fipscounty= cbsa.fipscounty
-- where population.population is not null
-- group by cbsaname, population.population
-- order by population

-- ***c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population. 
-- shelby? 937847

-- select county, population
-- from fips_county
-- left join population
-- on fips_county.fipscounty = population.fipscounty
-- where population is not null
-- except 
-- (select cbsa, population
-- 	from population
-- 	left join cbsa
-- 		on population.fipscounty = cbsa.fipscounty)
-- order by population desc


-- ***6a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
-- select drug_name, total_claim_count
-- from prescription
-- where total_claim_count >= '3000'

-- ***b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
-- select prescription.drug_name, total_claim_count, opioid_drug_flag as opioid
-- from prescription
-- left join drug 
-- on drug.drug_name = prescription.drug_name
-- where total_claim_count >= '3000'



-- ***c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
-- select prescription.drug_name, total_claim_count, opioid_drug_flag as opioid, nppes_provider_first_name as first_name, nppes_provider_last_org_name as last_name
-- from prescription
-- left join drug 
-- on drug.drug_name = prescription.drug_name
-- left join prescriber
-- on prescription.npi = prescriber.npi
-- where total_claim_count >= '3000'






-- The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. 
--Hint: The results from all 3 parts will have 637 rows.

-- ***a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). 
--Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.
-- select drug.drug_name, specialty_description, nppes_provider_city, drug.opioid_drug_flag
-- 				from drug
-- 				left join prescription --gets opioid flag
-- 					on drug.drug_name = prescription.drug_name
-- 				left join prescriber
-- 					on prescriber.npi = prescription.npi
-- where specialty_description = 'Pain Management' and nppes_provider_city = 'NASHVILLE' and drug.opioid_drug_flag = 'Y'

-- ***b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. 
--You should report the npi, the drug name, and the number of claims (total_claim_count).

-- select 
-- p.npi, 
-- drug.drug_name,
-- total_claim_count as number_of_claims

-- 				from drug
-- 				left join prescription as p --gets opioid flag
-- 					on drug.drug_name = p.drug_name
-- 				left join prescriber --gets provider city
-- 					on prescriber.npi = p.npi
-- where specialty_description = 'Pain Management' and nppes_provider_city = 'NASHVILLE' and drug.opioid_drug_flag = 'Y'
-- order by p.npi desc



-- c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.


-- n/a?


