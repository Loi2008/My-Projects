##1.	Introduction
This analysis explores a sample international debt dataset using PostgreSQL. The goal is to understand the structure of the data, assess data quality, and generate insights about global debt distribution. The dataset contains information on countries, debt indicators, and debt value. It also includes missing values that must be handled carefully during analysis, if accurate meaning is to be drawn from the dataset.

## 2.	Loading the Dataset 
***Assuming there is an active connected postgresql**.* 
####Steps:
- Open PostgreSQL in Dbeaver
- Create a schema
```sql
create schema international_debt_analysis);
```
Set the search path 
```sql
set search_path to international_debt_analysis);
```

- Right click on tables under your schema
- Import data 

- Select the source file

- Map the table to the schema

- Confirm 

- Proceed

- Open a new script

- Confirm your table is in the right schema

```sql
select * from international_debt_with_missing_values;
```
##3.	SQL Queries and Findings
The data is analysed using SQL queries.  Charts and tables are used for visualization. 
###3.1	The Total Amount of Debt Owed
```sql
select sum(debt) as total_debt 
from international_debt_with_missing_values;
```
se Total Debt** = 2,823,894,600,000**

###3.2	Number of Distinct Countries
```sql
select count(distinct country_name) as distinct_country 
from international_debt_with_missing_values;
```
Distinct Countries = **125**
###3.3	Distinct Types of Debt Indicators
```sql
select distinct indicator_code, indicator_name
from international_debt_with_missing_values
where indicator_name is not null
and indicator_name <> ''
and indicator_code is not null
and indicator_code <> '';
```
#####Table1: Distinct Debt Indicators
| Indicator Code   | Indicator Description |
|------------------|------------------------|
| DT.INT.PRVT.CD   | PPG, private creditors (INT, current US$) |
| DT.AMT.OFFT.CD   | PPG, official creditors (AMT, current US$) |
| DT.INT.DLXF.CD   | Interest payments on external debt, long-term (INT, current US$) |
| DT.INT.DPNG.CD   | Interest payments on external debt, private nonguaranteed (PNG) (INT, current US$) |
| DT.DIS.PCBK.CD   | PPG, commercial banks (DIS, current US$) |
| DT.AMT.PBND.CD   | PPG, bonds (AMT, current US$) |
| DT.DIS.MLAT.CD   | PPG, multilateral (DIS, current US$) |
| DT.DIS.PRVT.CD   | PPG, private creditors (DIS, current US$) |
| DT.INT.MLAT.CD   | PPG, multilateral (INT, current US$) |
| DT.INT.PBND.CD   | PPG, bonds (INT, current US$) |
| DT.INT.PROP.CD   | PPG, other private creditors (INT, current US$) |
| DT.DIS.OFFT.CD   | PPG, official creditors (DIS, current US$) |
| DT.AMT.MLAT.CD   | PPG, multilateral (AMT, current US$) |
| DT.INT.OFFT.CD   | PPG, official creditors (INT, current US$) |
| DT.DIS.PROP.CD   | PPG, other private creditors (DIS, current US$) |
| DT.AMT.PCBK.CD   | PPG, commercial banks (AMT, current US$) |
| DT.DIS.BLAT.CD   | PPG, bilateral (DIS, current US$) |
| DT.AMT.DLXF.CD   | Principal repayments on external debt, long-term (AMT, current US$) |
| DT.AMT.PROP.CD   | PPG, other private creditors (AMT, current US$) |
| DT.AMT.PRVT.CD   | PPG, private creditors (AMT, current US$) |
| DT.AMT.BLAT.CD   | PPG, bilateral (AMT, current US$) |
| DT.INT.PCBK.CD   | PPG, commercial banks (INT, current US$) |
| DT.INT.BLAT.CD   | PPG, bilateral (INT, current US$) |
| DT.DIS.DLXF.CD   | Disbursements on external debt, long-term (DIS, current US$) |
| DT.AMT.DPNG.CD   | Principal repayments on external debt, private nonguaranteed (PNG) (AMT, current US$) |

###3.4	Country with Highest Total Debt, and the Amount
```sql
select country_name, sum(debt) as total_debt
from international_debt_with_missing_values
where country_name is not null
and country_name <> ''
group by country_name
order by total_debt desc
limit 1;
```
The county is China	with the debt of  **266,455,760,000**

###3.5	The Average Debt Across Different Debt Indicators
```sql
select indicator_name, AVG(debt) AS avg_debt
from international_debt_with_missing_values
group by indicator_name
order by avg_debt desc;
```

![Average debt categorized by debt indicators](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/59mzgs5xpdjonux8g4rb.png)
#####Fig1: Average Debt per Indicator Category


###3.6	Country with Highest Principal Repayment
```sql
select country_name, SUM(debt) AS total_principal_repayment
from international_debt_with_missing_values
where indicator_name like '%Principal repayment%' and debt> 0
group by country_name
order by total_principal_repayment desc
limit 1;
```
The county is China with the principal repayment amount of **168,611,610,000**

###3.7	Most Common Debt Indicator 
```sql
select indicator_name, count(*) as frequency
from international_debt_with_missing_values
where indicator_name is not null
and indicator_name <> ''
group by indicator_name
order by frequency desc;
limit 1;
```
the most common debt indicator is PPG, official creditors (INT, current US$) with the frequency of **116**

###3.8	Other Key Debt Trends
####3.8.1	Top 5 countries with the most debt

```sql
select country_name, sum(debt) as total_debt
from international_debt_with_missing_values
group by country_name
order by total_debt desc
limit 5;
```

![Top five countries with the highest debts](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vkpmk0bn7h2ws82i8ygt.png)
#####Fig2: Average Debt per Indicator Category

####3.8.2	Five Countries with the Lowest Debt
*This excludes countries registering 0 debt*****
```sql
select country_name, min(debt) as total_debt
from international_debt_with_missing_values
where debt> 0 
group by country_name
order by total_debt desc
limit 5;
```

![Five countries with the least debt, excluding countries with 0 debt](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/r3gzm7mqj1z942sbkkha.png)
#####Fig:5 Countries with the Lowest Debt

####3.8.3	Number of countries with missing debt values
```sql
select count(debt) as missing_records
from international_debt_with_missing_values
where debt= 0;
```
Total number of countries where debt is 0 are **52**

##Conclusion
Overall, the data suggests a significant dependence on external financing, with repayment pressures concentrated in a few major economies and vulnerable groups. This underlines the importance of careful debt management policies, diversification of financing sources, and sustainable borrowing strategies to reduce long-term risks.

