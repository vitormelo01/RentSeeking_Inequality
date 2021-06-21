*-------------------------------------------------------------------------------
* Testing Stiglitz: Estimating the Impact of Rent-Seeking on Income Inequality
*             - Vitor Melo and Stephen Miller
* ------------------------------------------------------------------------------

cd "D:\Research\RentSeeking&Inequality\Data"
use "FinalRS.dta", clear

*-------------------------------------------------------------------------------
* Merging Rent-Seeking Data with Controls
* ------------------------------------------------------------------------------

merge 1:1 area_fips year using incomeshares_county.dta

drop if _merge==1
drop if _merge==2
drop _merge

merge 1:1 area_fips year using  income_pct_adj.dta

drop if _merge==1
drop if _merge==2
drop _merge

merge 1:1 area_fips year using unemployment_control.dta

drop if _merge==1
drop if _merge==2
drop _merge

merge 1:1 area_fips year using population_updated.dta

drop if _merge==1
drop if _merge==2
drop _merge

* Renaming Variables
rename income gdppercapita
rename popestimate countypopulation

save "RSCounty_incomeshares_andcontrols.dta", replace

*-------------------------------------------------------------------------------
* Labeling Variables
* ------------------------------------------------------------------------------

label variable top10pct "Income share of top 10%"
label variable top1pct "Income share of top 1%"
label variable area_fips "Area FIPS Code"
label variable RS_law "Rent-Seeking (% of Lawyers)"
label variable RS_LocalGovernment "Rent-Seeking (% of Local Gov. Workers )"
label variable countypopulation "County Population" 
label variable gdppercapita "Income per Capita"
label variable unemp_rate "Unemployment Rate"
label variable Engineering_Percentage "% of Engineers"

*-------------------------------------------------------------------------------
* Sum of Descriptive Statistics 
* ------------------------------------------------------------------------------

sum top10pct top1pct RS_law RS_LocalGovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate
 asdoc sum top10pct top1pct RS_law RS_LocalGovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate, label replace 
 
*-------------------------------------------------------------------------------
* Regression Analaysis with Fixed Effects - Income Shares
* ------------------------------------------------------------------------------

xtset area_fips year, yearly 

* top 10%
xtreg top10pct RS_law RS_LocalGovernment  i.year, fe vce(cluster area_fips)
 outreg2 using 10%_lawyers, replace word label keep(RS_law RS_LocalGovernment) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
 outreg2 using 10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage countypopulation i.year, fe vce(cluster area_fips)
 outreg2 using 10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage countypopulation) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage countypopulation gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using 10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage countypopulation gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top10pct RS_law RS_LocalGovernment Engineering_Percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using 10%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage countypopulation gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 2)
 
* top 1%
xtreg top1pct RS_law RS_LocalGovernment i.year, fe vce(cluster area_fips)
 outreg2 using 1%_lawyers, replace word label keep(RS_law RS_LocalGovernment) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
 outreg2 using 1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage countypopulation i.year, fe vce(cluster area_fips)
 outreg2 using 1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage countypopulation) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage countypopulation gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using 1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage countypopulation gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg top1pct RS_law RS_LocalGovernment Engineering_Percentage  countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using 1%_lawyers, append word label keep(RS_law RS_LocalGovernment Engineering_Percentage countypopulation gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 2)
 
