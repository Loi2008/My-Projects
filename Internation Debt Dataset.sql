set search_path to international_debt;
select * from international_debt_with_missing_values;

--The total amount of debt owed by all countries in the dataset ( assuming indicators with "AMT" in the indicator_code are principle debt repayments)
select sum(debt) as total_debt from international_debt_with_missing_values;
-- Total Debt = 2,823,894,600,000


--Distinct countries recorded in the dataset
select count(distinct country_name) as distinct_country from international_debt_with_missing_values;
--distinct Countries = 125


--Distinct types of debt indicators, and what they represent
-- omitted empty rows from both columns
select distinct indicator_code, indicator_name
from international_debt_with_missing_values
where indicator_name is not null
and indicator_name <> ''
and indicator_code is not null
and indicator_code <> '';
-- Distinct Indicators

--Country with the highest total debt, and the amount owed
select country_name, sum(debt) as total_debt
from international_debt_with_missing_values
where country_name is not null
and country_name <> ''
group by country_name
order by total_debt desc
limit 1;
-- the county is China	with the debt of  266,455,760,000

--Average debt across different debt indicators?
select indicator_name, AVG(debt) AS avg_debt
from international_debt_with_missing_values
group by indicator_name
order by avg_debt desc;


--The country that has made the highest amount of principal repayments
-- assuming Principal repayments are recorded in indicators with "principal repayment" in the indicator name and the rows with null under debt colum omitted.
select country_name, SUM(debt) AS total_principal_repayment
from international_debt_with_missing_values
where indicator_name like '%Principal repayment%' and debt> 0
group by country_name
order by total_principal_repayment desc
limit 1;
--The county is China with the principal repayment amount of 168,611,610,00

--The most common debt indicator across all countries (the unknown indicators not included)
select indicator_name, count(*) as frequency
from international_debt_with_missing_values
where indicator_name is not null
and indicator_name <> ''
group by indicator_name
order by frequency desc;
limit 1;
-- the most common debt indicator is PPG, official creditors (INT, current US$)	with the frequency of 116


-- The Key debt trends across all countries
--Top 5 countries with the most debt
select country_name, sum(debt) as total_debt
from international_debt_with_missing_values
group by country_name
order by total_debt desc
limit 5;

-- 5 countries with the Least debt ( countries with 0 debts omitted)
select country_name, min(debt) as total_debt
from international_debt_with_missing_values
where debt> 0 
group by country_name
order by total_debt desc
limit 5;


--Number of countries with missing debt values
select count(debt) as missing_records
from international_debt_with_missing_values
where debt= 0;
-- Total number of countries where debt is 0 are 52


