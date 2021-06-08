clear 
cd "D:\Research\RentSeeking&Inequality\Data\State_Level"

*-------------------------------------------------------------------------------
* Loading cleaned state level rent seeking data
* ------------------------------------------------------------------------------

use StateLevelRS.dta
gen id =.
replace id=area_fips/1000
drop if year==2018
save StateLevelRS1, replace
*-------------------------------------------------------------------------------
* Loading population data and merging it with health exp data
* ------------------------------------------------------------------------------

clear 
insheet using "PopulationStates.csv"
reshape long pop, i(year) j(id)

* Saving Population data
save PopulationStates, replace

merge 1:1 id year using StateLevelRS1.dta
drop if _merge==1
drop if _merge==2
drop _merge 

save RS_States1, replace

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

merge 1:m year id using RS_States1.dta
drop if _merge==1
drop _merge
save RS_States2, replace

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
merge 1:m year id using RS_States2.dta
drop if _merge==1
drop _merge

save RS_States3.dta, replace

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
merge 1:m year id using RS_States3.dta
drop if _merge==1
drop _merge

save RS_States4.dta, replace

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
merge 1:m year id using RS_States4.dta
drop if _merge==1
drop _merge

save RS_States5.dta, replace


* ------------------------------------------------------------------------------
* Merging with Population Density
* ------------------------------------------------------------------------------

clear 
insheet using "Area_States.csv"

* Creating Fips id

{
	rename State state
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

keep id landarea
merge 1:m id using RS_States5.dta
drop _merge

gen pop_density = pop/landarea

save RS_States6.dta, replace

* ------------------------------------------------------------------------------
* Regression Analysis
* ------------------------------------------------------------------------------

rename top10_adj top10pct
rename top5_adj top5pct
rename top1_adj top1pct
rename top01_adj top01pct
rename top001_adj top001pct





*-----------------------------------------------------------------------------
* Sum of Descriptive Statistics 

sum top10pct top5pct top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate
 asdoc sum top10pct top5pct top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate, label replace 


* ------------------------------------------------------------------------------------------
* Creating LabelsLabels

label variable id "Area FIPS Code"
label variable pop "Population"
label variable gdppercapita "GDP Per Capita"
label variable unemp_rate "Unemployment Rate"
label variable top10pct "Income share of top 10%"
label variable top5pct "Income share of top 5%"
label variable top1pct "Income share of top 1%"
label variable top01pct "Income share of top  0.1%"
label variable top001pct "Income share of top 0.01%"


* -------------------------------------------------------------------------------------------
* Regressions with Income shares 

xtset id year, yearly 

* top 10%
xtreg top10pct RS_lawandgovernment i.year, fe vce(cluster area_fips)
* outreg2 using top10pct_clustered, replace word label keep(RS_lawandgovernment) addtext(County FE, YES, Year FE, YES) title(Table 3)
xtreg top10pct RS_lawandgovernment EngineeringServices_employment i.year, fe vce(cluster area_fips)
 *outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment) addtext(County FE, YES, Year FE, YES) title(Table 3)
xtreg top10pct RS_lawandgovernment EngineeringServices_employment pop i.year, fe vce(cluster area_fips)
 *outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation) addtext(County FE, YES, Year FE, YES) title(Table 3)
xtreg top5pct RS_LobbyingEmployment_percentage EngineeringServices_employment pop income_pcp_adj i.year, fe vce(cluster area_fips)
 *outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 3)
 
 
 
 
 
xtreg top5pct RS_law EngineeringRelated_employment pop_density income_pcp_adj unemp_rate i.year, fe vce(cluster area_fips)
* outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 3)

