cd "D:\Research\RentSeeking&Inequality\Data"

* getting data ready 

use "FinalRS.dta", clear

merge 1:1 area_fips year using county_gini_2010_2018.dta

drop if _merge==1
drop if _merge==2
drop _merge

merge 1:1 area_fips year using  income_pct_adj.dta

drop if _merge==1
drop if _merge==2
drop _merge


merge 1:1 area_fips year using population_updated.dta

drop if _merge==1
drop if _merge==2
drop _merge

merge 1:1 area_fips year using unemployment_control.dta

drop if _merge==1
drop if _merge==2
drop _merge

rename income gdppercapita
rename popestimate countypopulation

save "RSCountywithControls.dta", replace

* merge m:1 area_fips year using education_controls.dta

gen EngRelated = (EngineeringRelated_employment/total_employment)*100
gen ln_gini = log(gini)
gen ln_RS_law = ln(RS_law)
gen ln_RS_LocalGovernment = ln(RS_LocalGovernment)
gen ln_RS_lawandgovernment = ln(RS_lawandgovernment) 
gen ln_RS_Lobbying = ln(RS_LobbyingEmployment_percentage)
gen ln_Financial = ln(FinancialEmployment_percentage) 
gen ln_Engineering = ln(Engineering_Percentage)
gen ln_Engrelated = ln(EngRelated)

xtset area_fips year, yearly 

* globals: 
global controls FinancialEmployment_percentage Engineering_Percentage countypopulation gdppercapita unemp_rate
global ln_controls ln_Engrelated countypopulation gdppercapita unemp_rate
global ln_controls2 ln_Engineering countypopulation gdppercapita unemp_rate
global controls3 countypopulation gdppercapita unemp_rate
global controls4 EngRelated FinancialEmployment_percentage unemp_rate

* ---------------------------------------------
* Labeling bariables
label variable area_fips "Area FIPS Code"
label variable ln_RS_lawandgovernment "Rent-Seeking (Ln)"
label variable ln_Engineering "Engineering (Ln)"
label variable countypopulation "County Population" 
label variable gdppercapita "GDP per Capita"
label variable unemp_rate "Unemployment Rate"

*-----------------------------------------------------------------------------
* Sum of Descriptive Statistics 
/*
sum gini 
ln_RS_lawandgovernment ln_Engineering countypopulation gdppercapita unemp_rate
*asdoc sum gini ln_RS_lawandgovernment ln_Engineering countypopulation gdppercapita unemp_rate, label replace */

*-----------------------------------------------------------------------------
* Regressions on Gini Coefficient 
xtreg gini RS_lawandgovernment i.year, fe vce(cluster area_fips)
 outreg2 using gini_clustered, replace word label keep(RS_lawandgovernment) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg gini RS_lawandgovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
 outreg2 using gini_clustered, append word label keep(RS_lawandgovernment Engineering_Percentage) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg gini RS_lawandgovernment Engineering_Percentage countypopulation i.year, fe vce(cluster area_fips)
 outreg2 using gini_clustered, append word label keep(RS_lawandgovernment Engineering_Percentage countypopulation) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg gini RS_lawandgovernment Engineering_Percentage countypopulation gdppercapita i.year, fe vce(cluster area_fips)
 outreg2 using gini_clustered, append word label keep(RS_lawandgovernment Engineering_Percentage countypopulation gdppercapita) addtext(County FE, YES, Year FE, YES) title(Table 2)
xtreg gini RS_lawandgovernment Engineering_Percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)
 outreg2 using gini_clustered, append word label keep(RS_lawandgovernment Engineering_Percentage countypopulation gdppercapita unemp_rate) addtext(County FE, YES, Year FE, YES) title(Table 2)

*-----------------------------------------------------------------------------
* Regressions with bootstrap
* xtreg gini ln_RS_lawandgovernment $ln_controls2 i.year, fe vce(bootstrap, reps(1000) seed(123))

/*  
xtreg gini RS_lawandgovernment i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment Engineering_Percentage i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment Engineering_Percentage countypopulation i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment Engineering_Percentage countypopulation gdppercapita i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment Engineering_Percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)

xtreg gini RS_lawandgovernment i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment EngRelated i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment EngRelated countypopulation i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment EngRelated countypopulation gdppercapita i.year, fe vce(cluster area_fips)
xtreg gini RS_lawandgovernment EngRelated countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)


xtreg gini RS_lawandgovernment EngRelated FinancialEmployment_percentage countypopulation gdppercapita unemp_rate i.year, fe vce(cluster area_fips)












