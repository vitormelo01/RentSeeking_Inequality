*-------------------------------------------------------------------------------
* Testing Stiglitz: Estimating the Impact of Rent-Seeking on Income Inequality
*             - Vitor Melo and Stephen Miller
* ------------------------------------------------------------------------------

clear 
cd "C:\Users\vitor\OneDrive\Research_Resources\RentSeeking_Resources\Data"

*-------------------------------------------------------------------------------
* Loading cleaned state level rent seeking data
* ------------------------------------------------------------------------------

use StateLevelRS.dta
gen id =.
replace id=area_fips/1000
drop if year==2018
save RS_States, replace

*-------------------------------------------------------------------------------
* Loading population data and merging it with Rent-Seeking Data
* ------------------------------------------------------------------------------

clear 
insheet using "PopulationStates.csv"
reshape long pop, i(year) j(id)

* Saving Population data
save PopulationStates, replace

merge 1:1 id year using RS_States.dta
drop if _merge==1
drop if _merge==2
drop _merge 

save RS_States, replace

*-------------------------------------------------------------------------------
* Merging with Income per Capita Data
* ------------------------------------------------------------------------------

clear 
insheet using "income_pcp.csv"

*clean up
keep if linecode==3
gen id=geofips/1000
drop geofips
drop geoname
drop linecode
drop description 

*Reshaping and saving income per capita data
reshape long i, i(id) j(year)
rename i income_pcp
save income_pct, replace

* Loading CPI and adjusting income per capita for inflation (2015 prices)
clear 
insheet using "CPI_2015Prices.csv"

* Merging data with Exp. per capita data
merge 1:m year using income_pct.dta
drop if _merge==2
       
* Creating  income per capita adjusted for inflation (2015 prices)
gen income_pcp_adj = .
replace income_pcp_adj = income_pcp/cpi*100

* Clean Up
drop income_pcp
drop _merge 
sort year id

merge 1:m year id using RS_States.dta
drop if _merge==1
drop _merge
save RS_States, replace

* ------------------------------------------------------------------------------
* Merging with Gini Coefficients Data
* ------------------------------------------------------------------------------
clear 
insheet using "Gini.csv"

* Creating Fips id
{
	gen id = .
replace id = 1 if state=="Alabama"
replace id = 2 if state=="Alaska"
replace id = 4 if state=="Arizona"
replace id = 5 if state=="Arkansas"
replace id = 6 if state=="California"
replace id = 8 if state=="Colorado"
replace id = 9 if state=="Connecticut"
replace id = 10 if state=="Delaware"
replace id = 11 if state=="District of Columbia"
replace id = 12 if state=="Florida"
replace id = 13 if state=="Georgia"
replace id = 15 if state=="Hawaii"
replace id = 16 if state=="Idaho"
replace id = 17 if state=="Illinois"
replace id = 18 if state=="Indiana"
replace id = 19 if state=="Iowa"
replace id = 20 if state=="Kansas"
replace id = 21 if state=="Kentucky"
replace id = 22 if state=="Louisiana"
replace id = 23 if state=="Maine"
replace id = 24 if state=="Maryland"
replace id = 25 if state=="Massachusetts"
replace id = 26 if state=="Michigan"
replace id = 27 if state=="Minnesota"
replace id = 28 if state=="Mississippi"
replace id = 29 if state=="Missouri"
replace id = 30 if state=="Montana"
replace id = 31 if state=="Nebraska"
replace id = 32 if state=="Nevada"
replace id = 33 if state=="New Hampshire"
replace id = 34 if state=="New Jersey"
replace id = 35 if state=="New Mexico"
replace id = 36 if state=="New York"
replace id = 37 if state=="North Carolina"
replace id = 38 if state=="North Dakota"
replace id = 39 if state=="Ohio"
replace id = 40 if state=="Oklahoma"
replace id = 41 if state=="Oregon"
replace id = 42 if state=="Pennsylvania"
replace id = 44 if state=="Rhode Island"
replace id = 45 if state=="South Carolina"
replace id = 46 if state=="South Dakota"
replace id = 47 if state=="Tennessee"
replace id = 48 if state=="Texas"
replace id = 49 if state=="Utah"
replace id = 50 if state=="Vermont"
replace id = 51 if state=="Virginia"
replace id = 53 if state=="Washington"
replace id = 54 if state=="West Virginia"
replace id = 55 if state=="Wisconsin"
replace id = 56 if state=="Wyoming"
}

* Clean Up 
drop if id==.
rename Year year
keep year id gini

* Merging with current data
merge 1:m year id using RS_States.dta
drop if _merge==1
drop _merge

save RS_States.dta, replace

* ------------------------------------------------------------------------------
* Merging with Income Shares Data
* ------------------------------------------------------------------------------

clear 
insheet using "IncomeShares.csv"

* Creating Fips id
{
	gen id = .
replace id = 1 if state=="Alabama"
replace id = 2 if state=="Alaska"
replace id = 4 if state=="Arizona"
replace id = 5 if state=="Arkansas"
replace id = 6 if state=="California"
replace id = 8 if state=="Colorado"
replace id = 9 if state=="Connecticut"
replace id = 10 if state=="Delaware"
replace id = 11 if state=="District of Columbia"
replace id = 12 if state=="Florida"
replace id = 13 if state=="Georgia"
replace id = 15 if state=="Hawaii"
replace id = 16 if state=="Idaho"
replace id = 17 if state=="Illinois"
replace id = 18 if state=="Indiana"
replace id = 19 if state=="Iowa"
replace id = 20 if state=="Kansas"
replace id = 21 if state=="Kentucky"
replace id = 22 if state=="Louisiana"
replace id = 23 if state=="Maine"
replace id = 24 if state=="Maryland"
replace id = 25 if state=="Massachusetts"
replace id = 26 if state=="Michigan"
replace id = 27 if state=="Minnesota"
replace id = 28 if state=="Mississippi"
replace id = 29 if state=="Missouri"
replace id = 30 if state=="Montana"
replace id = 31 if state=="Nebraska"
replace id = 32 if state=="Nevada"
replace id = 33 if state=="New Hampshire"
replace id = 34 if state=="New Jersey"
replace id = 35 if state=="New Mexico"
replace id = 36 if state=="New York"
replace id = 37 if state=="North Carolina"
replace id = 38 if state=="North Dakota"
replace id = 39 if state=="Ohio"
replace id = 40 if state=="Oklahoma"
replace id = 41 if state=="Oregon"
replace id = 42 if state=="Pennsylvania"
replace id = 44 if state=="Rhode Island"
replace id = 45 if state=="South Carolina"
replace id = 46 if state=="South Dakota"
replace id = 47 if state=="Tennessee"
replace id = 48 if state=="Texas"
replace id = 49 if state=="Utah"
replace id = 50 if state=="Vermont"
replace id = 51 if state=="Virginia"
replace id = 53 if state=="Washington"
replace id = 54 if state=="West Virginia"
replace id = 55 if state=="Wisconsin"
replace id = 56 if state=="Wyoming"
}

* Clean Up 
drop if id==.
rename Year year
drop number state

* Merging with current data
merge 1:m year id using RS_States.dta
drop if _merge==1
drop _merge

save RS_States.dta, replace

* ------------------------------------------------------------------------------
* Merging with Unemployment Rate data
* ------------------------------------------------------------------------------

clear 
insheet using "Unemployment_states.csv"

* Clean up and Reshape
replace id = id/1000
drop area
reshape long u, i(id) j(year)
rename u unemp_rate
drop if id==0

* Merging with current data
merge 1:m year id using RS_States.dta
drop if _merge==1
drop _merge

save RS_States.dta, replace

clear
use ASEC_1980-2020_State.dta 

rename state area_fips
replace area_fips = area_fips*1000

merge 1:m  year area_fips using RS_States.dta
drop if _merge==1
drop if _merge==2
drop _merge

save RS_withEducation.dta, replace 


*-------------------------------------------------------------------------------
* Adding Updated Gini Data
* ------------------------------------------------------------------------------

clear
insheet using "gini_updated.csv"
rename v2 v2006
rename v3 v2007
rename v4 v2008
rename v5 v2009
rename v6 v2010
rename v7 v2011
rename v8 v2012
rename v9 v2013
rename v10 v2014
rename v11 v2015
rename v12 v2016
rename v13 v2017
rename v14 v2018

reshape long v, i(state) j(year)
drop gini
rename v gini_updated

* Creating Fips id
{
	gen id = .
replace id = 1 if state=="Alabama"
replace id = 2 if state=="Alaska"
replace id = 4 if state=="Arizona"
replace id = 5 if state=="Arkansas"
replace id = 6 if state=="California"
replace id = 8 if state=="Colorado"
replace id = 9 if state=="Connecticut"
replace id = 10 if state=="Delaware"
replace id = 11 if state=="District of Columbia"
replace id = 12 if state=="Florida"
replace id = 13 if state=="Georgia"
replace id = 15 if state=="Hawaii"
replace id = 16 if state=="Idaho"
replace id = 17 if state=="Illinois"
replace id = 18 if state=="Indiana"
replace id = 19 if state=="Iowa"
replace id = 20 if state=="Kansas"
replace id = 21 if state=="Kentucky"
replace id = 22 if state=="Louisiana"
replace id = 23 if state=="Maine"
replace id = 24 if state=="Maryland"
replace id = 25 if state=="Massachusetts"
replace id = 26 if state=="Michigan"
replace id = 27 if state=="Minnesota"
replace id = 28 if state=="Mississippi"
replace id = 29 if state=="Missouri"
replace id = 30 if state=="Montana"
replace id = 31 if state=="Nebraska"
replace id = 32 if state=="Nevada"
replace id = 33 if state=="New Hampshire"
replace id = 34 if state=="New Jersey"
replace id = 35 if state=="New Mexico"
replace id = 36 if state=="New York"
replace id = 37 if state=="North Carolina"
replace id = 38 if state=="North Dakota"
replace id = 39 if state=="Ohio"
replace id = 40 if state=="Oklahoma"
replace id = 41 if state=="Oregon"
replace id = 42 if state=="Pennsylvania"
replace id = 44 if state=="Rhode Island"
replace id = 45 if state=="South Carolina"
replace id = 46 if state=="South Dakota"
replace id = 47 if state=="Tennessee"
replace id = 48 if state=="Texas"
replace id = 49 if state=="Utah"
replace id = 50 if state=="Vermont"
replace id = 51 if state=="Virginia"
replace id = 53 if state=="Washington"
replace id = 54 if state=="West Virginia"
replace id = 55 if state=="Wisconsin"
replace id = 56 if state=="Wyoming"
}

save gini_updated, replace 

*-------------------------------------------------------------------------------
* Aanalysis on updated Gini at state level
* ------------------------------------------------------------------------------
clear
use RS_withEducation.dta
merge 1:m year id using gini_updated.dta
drop if _merge==1
drop if _merge==2
drop _merge

save RS_updated.dta, replace


* ------------------------------------------------------------------------------
* Renaming Variables
* ------------------------------------------------------------------------------
clear 
use RS_updated.dta

rename top10_adj top10pct
rename top5_adj top5pct
rename top1_adj top1pct
rename top01_adj top01pct
rename top001_adj top001pct
rename income_pcp_adj gdppercapita

*-------------------------------------------------------------------------------
* Labeling Variables
* ------------------------------------------------------------------------------
replace pop = pop/1000
replace gdppercapita = gdppercapita/1000
replace prop_bach_degree_bsy = prop_bach_degree_bsy*100
* Population is in thousands, gdp per capita is in thousands, education variable is in percentages


label variable id "Area FIPS Code"
label variable pop "Population"
label variable unemp_rate "Unemployment Rate"
label variable top10pct "Income share of top 10%"
label variable top1pct "Income share of top 1%"
label variable area_fips "Area FIPS Code"
label variable RS_law "Rent-Seeking (% of Lawyers)"
label variable RS_LocalGovernment "Rent-Seeking (% of Local Gov. Workers)"
label variable gdppercapita "Income per Capita"
label variable unemp_rate "Unemployment Rate"
label variable Engineering_Percentage "% of Engineers"
label variable prop_bach_degree_bsy "% of Population with Bachelor's Degree"
label variable gini_updated "Gini"




*-------------------------------------------------------------------------------
* Regression Analaysis with Fixed Effects - Gini Coefficient
* ------------------------------------------------------------------------------

xtset id year, yearly 
ssc install outreg2

 * Regressions on Gini Coefficient 
xtreg gini RS_law RS_LocalGovernment i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, replace word label keep(RS_law RS_LocalGovernment) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini RS_law RS_LocalGovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini RS_law RS_LocalGovernment Engineering_Percentage pop i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita ) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
  
*-------------------------------------------------------------------------------
* Regression Analaysis with Fixed Effects - Income Shares
* ------------------------------------------------------------------------------

* top 10%
xtreg top10pct RS_law RS_LocalGovernment  i.year, fe vce(cluster area_fips)
 outreg2 using state_10%_lawyers, replace word label keep(RS_law RS_LocalGovernment) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
 outreg2 using state_10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage pop i.year, fe vce(cluster area_fips)
 outreg2 using state_10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using state_10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using state_10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy i.year, fe vce(cluster area_fips)
 outreg2 using state_10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
 
* top 1%
xtreg top1pct RS_law RS_LocalGovernment i.year, fe vce(cluster area_fips)
 outreg2 using state_1%_lawyers, replace word label keep(RS_law RS_LocalGovernment) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
 outreg2 using state_1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage pop i.year, fe vce(cluster area_fips)
 outreg2 using state_1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using state_1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using state_1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy i.year, fe vce(cluster area_fips)
 outreg2 using state_1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
 


*-------------------------------------------------------------------------------
* Regression Analaysis Updated Gini Coefficient
* ------------------------------------------------------------------------------

xtset id year, yearly 
*ssc install outreg2

 * Regressions on Gini Coefficient 
xtreg gini_updated RS_law RS_LocalGovernment i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, replace word label keep(RS_law RS_LocalGovernment) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini_updated RS_law RS_LocalGovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini_updated RS_law RS_LocalGovernment Engineering_Percentage pop i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini_updated RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita ) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini_updated RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
xtreg gini_updated RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy i.year, fe vce(cluster area_fips)
 outreg2 using state_gini_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy) addtext(County FE, YES, Year FE, YES) title(Table 2) nocons
 
 
 *-------------------------------------------------------------------------------
* Sum of Descriptive Statistics 
* ------------------------------------------------------------------------------
*ssc install asdoc

sum gini_updated top10pct top1pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy if e(sample)
 asdoc sum gini_updated top10pct top1pct RS_law RS_LocalGovernment Engineering_Percentage pop gdppercapita unemp_rate prop_bach_degree_bsy if e(sample), label replace 

