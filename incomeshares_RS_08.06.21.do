cd "D:\Research\RentSeeking&Inequality\Data"

* getting data ready 

use "FinalRS.dta", clear

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

rename income gdppercapita
rename popestimate countypopulation

save "RSCounty_incomeshares_andcontrols.dta", replace
gen EngRelated = (EngineeringRelated_employment/total_employment)*100
gen ln_RS_law = ln(RS_law)
gen ln_RS_LocalGovernment = ln(RS_LocalGovernment)
gen ln_RS_lawandgovernment = ln(RS_lawandgovernment) 
gen ln_RS_Lobbying = ln(RS_LobbyingEmployment_percentage)
gen ln_Financial = ln(FinancialEmployment_percentage) 
gen ln_Engineering = ln(Engineering_Percentage)
gen ln_top10pct = ln(top10pct)
gen ln_top5pct = ln(top5pct)
gen ln_top1pct = ln(top1pct)
gen ln_top01pct = ln(top01pct)
gen ln_top001pct = ln(top001pct)
gen ln_Engrelated = ln(EngRelated)
gen ln_gdp = ln(gdppercapita)
* -------------------------------------------------------------------------------------------------------------

xtset area_fips year, yearly 

* globals: 
global controls Engineering_Percentage FinancialEmployment_percentage countypopulation gdppercapita unemp_rate
global controls2 EngRelated FinancialEmployment_percentage countypopulation gdppercapita unemp_rate
global ln_controls ln_Engineering countypopulation gdppercapita unemp_rate
global ln_controls2 ln_Engrelated countypopulation gdppercapita unemp_rate
global controls3 countypopulation gdppercapita unemp_rate
global controls4 EngRelated FinancialEmployment_percentage unemp_rate
global ln_controls4 ln_Engineering unemp_rate

* ---------------------------------------------------------------------------------
replace ln_RS_lawandgovernment = 0 if ln_RS_lawandgovernment==.
replace ln_Engineering = 0 if ln_Engineering==.




*-----------------------------------------------------------------------------
* Sum of Descriptive Statistics 

sum top10pct top5pct top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate
 asdoc sum top10pct top5pct top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate, label replace 


* ------------------------------------------------------------------------------------------
* final regressions income shares and rent seeking 

label variable area_fips "Area FIPS Code"
label variable ln_RS_lawandgovernment "Rent Seeking (Ln)"
label variable ln_Engineering "Engineering (Ln)"
label variable countypopulation "Population"
label variable gdppercapita "GDP Per Capita"
label variable unemp_rate "Unemployment Rate"
label variable top10pct "Income share of top 10%"
label variable top5pct "Income share of top 5%"
label variable top1pct "Income share of top 1%"
label variable top01pct "Income share of top  0.1%"
label variable top001pct "Income share of top 0.01%"
label variable ln_top10pct "Ln of 'income share of top 10%''"
label variable ln_top5pct "Ln of 'income share of top 5%''"
label variable ln_top1pct "Ln of 'income share of top 1%''"
label variable ln_top01pct "Ln of 'income share of top  0.1%''"
label variable ln_top001pct "Ln of 'income share of top 0.01%''"
label variable area_fips "Counties"

* -------------------------------------------------------------------------------------------
* Regressions with Income shares 

* top 10%
xtreg top10pct RS_lawandgovernment i.year, fe vce(cluster area_fips)
 outreg2 using top10pct_clustered, replace word label keep(RS_lawandgovernment) addtext(County FE, YES, Year FE, YES) title(Table 3)
xtreg top10pct RS_lawandgovernment EngineeringServices_employment i.year, fe vce(cluster area_fips)
 outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment) addtext(County FE, YES, Year FE, YES) title(Table 3)
xtreg top10pct RS_lawandgovernment EngineeringServices_employment countypopulation i.year, fe vce(cluster area_fips)
 outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation) addtext(County FE, YES, Year FE, YES) title(Table 3)
xtreg top10pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 3)
xtreg top10pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using top10pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 3)

* top 5%
xtreg top5pct RS_lawandgovernment i.year, fe vce(cluster area_fips)
 outreg2 using top5pct_clustered, replace word label keep(RS_lawandgovernment) addtext(County FE, YES, Year FE, YES) title(Table 4)
xtreg top5pct RS_lawandgovernment EngineeringServices_employment i.year, fe vce(cluster area_fips)
 outreg2 using top5pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment) addtext(County FE, YES, Year FE, YES) title(Table 4)
xtreg top5pct RS_lawandgovernment EngineeringServices_employment countypopulation i.year, fe vce(cluster area_fips)
 outreg2 using top5pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation) addtext(County FE, YES, Year FE, YES) title(Table 4)
xtreg top5pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using top5pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 4)
xtreg top5pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using top5pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 4)
 
* top 1%
xtreg top1pct RS_lawandgovernment i.year, fe vce(cluster area_fips)
 outreg2 using top1pct_clustered, replace word label keep(RS_lawandgovernment) addtext(County FE, YES, Year FE, YES) title(Table 5)
xtreg top1pct RS_lawandgovernment EngineeringServices_employment i.year, fe vce(cluster area_fips)
 outreg2 using top1pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment) addtext(County FE, YES, Year FE, YES) title(Table 5)
xtreg top1pct RS_lawandgovernment EngineeringServices_employment countypopulation i.year, fe vce(cluster area_fips)
 outreg2 using top1pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation) addtext(County FE, YES, Year FE, YES) title(Table 5)
xtreg top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using top1pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 5)
xtreg top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using top1pct_clustered, append word label keep(RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 5)
 
 
* ------------------------------------------------------------------------------------------------------------------

 
 
 
 
 
 
 
 /*

xtreg top10pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top5pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top01pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top001pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 
xtreg top10pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(bootstrap, reps(1000) seed(123))
xtreg top5pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(bootstrap, reps(1000) seed(123))
xtreg top1pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(bootstrap, reps(1000) seed(123))
xtreg top01pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(bootstrap, reps(1000) seed(123))
xtreg top001pct RS_lawandgovernment EngineeringServices_employment countypopulation gdppercapita unemp_rate i.year, fe vce(bootstrap, reps(1000) seed(123))

xtreg top10pct RS_lawandgovernment EngRelated FinancialEmployment_percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top5pct RS_lawandgovernment EngRelated FinancialEmployment_percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top1pct RS_lawandgovernment EngRelated FinancialEmployment_percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top01pct RS_lawandgovernment EngRelated FinancialEmployment_percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
xtreg top001pct RS_lawandgovernment EngRelated FinancialEmployment_percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 
 
 