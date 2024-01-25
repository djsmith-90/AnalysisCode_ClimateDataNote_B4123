*** ALSPAC climate beliefs and behaviours data note - ALSPAC B-number B4123
*** Script 5: Analysing partner's data
*** Created 25/1/2024 by Dan Major-Smith
*** Stata version 18.0

** Set working directory
cd "X:\Studies\RSBB Team\Dan\B4123 - Climate Data Note"

** Install any user-written packages
*ssc install missings, replace

** Create log file
capture log close
log using "./Results/Climate_dataNote_partnerAnalyses.log", replace

** Read in dataset
use "B4123_partnerData_processed.dta", clear

* Or, if using the synthetic dataset
*use ".\AnalysisCode_ClimateDataNote_B4123\SyntheticData\syntheticData_partners_B4123.dta", clear


*****************************************************************************
***** 1) Descriptive statistics

** Levels of missing data
missings report climateChanging-total_actions_red_excKids, percent


** Believes that the climate is changing - ordered categorical variable 
tab climateChanging


** Degree to which is concerned about the impact of climate change (only answered if believe climate is changing) - ordered categorical variable
tab climateConcern


** Believes that humans are to blame for climate change (only answered if believe climate is changing) - ordered categorical variable
tab climateHumans


** Personal actions will make difference to long-term climate changes (only answered if believe climate is changing) - unordered categorical variable
tab climateAction


** Questions about which things will change due to climate change
tab1 weatherAffected-otherAffected

* Make a bar plot of these results
keep aln weatherAffected-otherAffected

order aln weatherAffected futureGensAffected economyAffected neighbourhoodAffected healthAffected workAffected otherAffected nothingAffected

numlabel, remove

local i = 1
foreach var of varlist weatherAffected-nothingAffected {
	rename `var' graph_`i'
	local i = `i' + 1
}

reshape long graph_, i(aln) j(question)

label define q_lb 1 "Weather" 2 "Future generations" 3 "Economy" 4 "Neighbourhood" 5 "Health" 6 "Work" 7 "Other" 8 "Nothing"
label values question q_lb

graph hbar (count), over(graph_) over(question) stack asyvars percent ///
	ytitle("Percent") title("Will be affected by climate change")
	
graph export "./Results/AffectedByClimateChange_Partners.pdf", replace

* Read back in dataset
use "B4123_partnerData_processed.dta", clear


** Individual climate actions (categorical)
tab1 travel waste energy buy airTravel elecCar localFood recycle plastic sustainable insulation solar veg trees avoidFossil children otherAction meatDairy

* Bar chart for categorical actions
keep aln travel waste energy buy airTravel elecCar localFood recycle plastic sustainable insulation solar veg trees avoidFossil meatDairy otherAction

order aln recycle plastic waste sustainable energy buy localFood travel insulation meatDairy airTravel avoidFossil trees elecCar veg solar otherAction

numlabel, remove

local i = 1
foreach var of varlist recycle-otherAction {
	rename `var' graph_`i'
	local i = `i' + 1
}

reshape long graph_, i(aln) j(question)

label define q 1 "Recycled more" 2 "Reduced plastic use" 3 "Reduced household waste" ///
	4 "Chosen sustainable items" 5 "Reduced energy use" 6 "Changed what buy" ///
	7 "Bought local food" 8 "Changed how travel locally" ///
	9 "Improved home insulation" 10 "Reduced meat/dairy consumption" ///
	11 "Reduced air travel" 12 "Avoided fossil fuel orgs." 13 "Planted trees" ///
	14 "Used hybrid/electric car" 15 "Started growing vegetables" ///
	16 "Installed solar panels" 17 "Other action"
label values question q

graph hbar (count), over(graph_) over(question, label(labsize(small))) ///
	stack asyvars percent ///
	ytitle("Percent") title("Actions take for climate and/or other reasons") ///
	legend(rows(1) position(6) size(small))
	
graph export ".\Results\climateActions_partners.pdf", replace

* Read back in the original data
use "B4123_partnerData_processed.dta", clear


** Individual climate actions (binary)
tab1 travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin otherAction_bin meatDairy_bin

* Bar chart for binary actions
keep aln *_bin
drop children_bin

order aln recycle_bin plastic_bin waste_bin sustainable_bin energy_bin buy_bin localFood_bin travel_bin insulation_bin meatDairy_bin airTravel_bin avoidFossil_bin trees_bin elecCar_bin veg_bin solar_bin otherAction_bin

numlabel, remove

local i = 1
foreach var of varlist recycle_bin-otherAction_bin {
	rename `var' graph_`i'
	local i = `i' + 1
}

reshape long graph_, i(aln) j(question)

label define q 1 "Recycled more" 2 "Reduced plastic use" 3 "Reduced household waste" ///
	4 "Chosen sustainable items" 5 "Reduced energy use" 6 "Changed what buy" ///
	7 "Bought local food" 8 "Changed how travel locally" ///
	9 "Improved home insulation" 10 "Reduced meat/dairy consumption" ///
	11 "Reduced air travel" 12 "Avoided fossil fuel orgs." 13 "Planted trees" ///
	14 "Used hybrid/electric car" 15 "Started growing vegetables" ///
	16 "Installed solar panels" 17 "Other action"
label values question q

graph hbar (count), over(graph_) over(question) stack asyvars percent ///
	ytitle("Percent") title("Actions taken for climate reasons")

graph export ".\Results\climateActions_binary_partners.pdf", replace

* Read back in the original data
use "B4123_partnerData_processed.dta", clear


** Total number of climate actions
sum total_actions total_actions_red total_actions_excKids total_actions_red_excKids, d

hist total_actions, freq discrete ///
	xlabel(0(3)18) xtitle("Total number of actions taken due to climate concern")
	
graph export ".\Results\totalClimateActions_hist_partners.pdf", replace


****************************************************************************
**** Basic associations between sociodemographic factors and climate beliefs/behaviours

*** Belief in climate change

** Age
tab climateChanging, sum(age)
ologit climateChanging age, or
ologit climateChanging c.age##c.age, or

* Predicted probabilities
ologit climateChanging c.age##c.age, or
margins, at(age = (50, 60, 70))

ologit climateChanging c.age##c.age, or
margins, at(age = (43(1)83))

matrix res = r(table)
matrix list res
local n = colsof(res)/5

clear 
set obs `n'
egen age = fill(43 44)
gen p0 = .
gen p1 = .
gen p2 = .
gen p3 = .
gen p4 = .

forvalues i = 1(1)`n' {
	replace p0 = res[1,`i'] if _n == `i'
	replace p1 = res[1,`n' + `i'] if _n == `i'
	replace p2 = res[1,`n' + `n' + `i'] if _n == `i'
	replace p3 = res[1,`n' + `n' + `n' + `i'] if _n == `i'
	replace p4 = res[1,`n' + `n' + `n' + `n' + `i'] if _n == `i'
}

list, clean

twoway (line p0 age, col(black)) ///
	(line p1 age, col(red)) ///
	(line p2 age, col(blue)) ///
	(line p3 age, col(green)) ///
	(line p4 age, col(orange)), ///
	xscale(range(40 85)) xlabel(45(5)80, labsize(small)) ///
	yscale(range(0, 1)) ylabel(0(0.1)1, labsize(small)) ///
	xtitle("") ytitle("Predicted probability") yscale(titlegap(2)) ///
	title("Age", size(medium)) ///
	legend(order(1 "Definitely not" 2 "Probably not" 3 "Yes, maybe" ///
		4 "Yes, probably" 5 "Yes, definitely") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateChanging_partners.pdf", replace

* Read back in the original data
use "B4123_partnerData_processed.dta", clear


** Ethnicity
tab climateChanging ethnicity, col chi V

** Education
tab climateChanging edu, col chi V

** Occupational social class
tab climateChanging occSocClass, col chi V

** Income
tab climateChanging income, col chi V

** IMD
tab climateChanging imd, col chi V


*** Concern regarding climate change

** Age
tab climateConcern, sum(age)
ologit climateConcern age, or
ologit climateConcern c.age##c.age, or

* Predicted probabilities
ologit climateConcern c.age##c.age, or
margins, at(age = (50, 60, 70))

ologit climateConcern c.age##c.age, or
margins, at(age = (43(1)83))

matrix res = r(table)
matrix list res
local n = colsof(res)/4

clear 
set obs `n'
egen age = fill(43 44)
gen p0 = .
gen p1 = .
gen p2 = .
gen p3 = .

forvalues i = 1(1)`n' {
	replace p0 = res[1,`i'] if _n == `i'
	replace p1 = res[1,`n' + `i'] if _n == `i'
	replace p2 = res[1,`n' + `n' + `i'] if _n == `i'
	replace p3 = res[1,`n' + `n' + `n' + `i'] if _n == `i'
}

list, clean

twoway (line p0 age, col(black)) ///
	(line p1 age, col(red)) ///
	(line p2 age, col(blue)) ///
	(line p3 age, col(green)), ///
	xscale(range(40 85)) xlabel(45(5)80, labsize(small)) ///
	ylabel(, labsize(small)) ///
	xtitle("") ytitle("Predicted probability") yscale(titlegap(2)) ///
	title("Age", size(medium)) ///
	legend(order(1 "Not at all concerned" 2 "Not very concerned"  ///
	3 "Somewhat concerned" 4 "Very concerned") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateConcern_partners.pdf", replace

* Read back in the original data
use "B4123_partnerData_processed.dta", clear


** Ethnicity
tab climateConcern ethnicity, col chi V

** Education
tab climateConcern edu, col chi V

** Occupational social class
tab climateConcern occSocClass, col chi V

** Income
tab climateConcern income, col chi V

** IMD
tab climateConcern imd, col chi V

** Belief in climate change
tab climateConcern climateChanging, col chi V


*** Humans are to blame for climate change

** Age
tab climateHumans, sum(age)
ologit climateHumans age, or
ologit climateHumans c.age##c.age, or

* Predicted probabilities
ologit climateHumans c.age##c.age, or
margins, at(age = (50, 60, 70))

ologit climateHumans c.age##c.age, or
margins, at(age = (43(1)83))

matrix res = r(table)
matrix list res
local n = colsof(res)/4

clear 
set obs `n'
egen age = fill(43 44)
gen p0 = .
gen p1 = .
gen p2 = .
gen p3 = .

forvalues i = 1(1)`n' {
	replace p0 = res[1,`i'] if _n == `i'
	replace p1 = res[1,`n' + `i'] if _n == `i'
	replace p2 = res[1,`n' + `n' + `i'] if _n == `i'
	replace p3 = res[1,`n' + `n' + `n' + `i'] if _n == `i'
}

list, clean

twoway (line p0 age, col(black)) ///
	(line p1 age, col(red)) ///
	(line p2 age, col(blue)) ///
	(line p3 age, col(green)), ///
	xscale(range(40 85)) xlabel(45(5)85, labsize(small)) ///
	yscale(range(0, 0.5)) ylabel(0(0.1)0.5, labsize(small)) ///
	xtitle("") ytitle("Predicted probability") yscale(titlegap(2)) ///
	title("Age", size(medium)) ///
	legend(order(1 "Not at all" 2 "For some of it" 3 "For most of it" ///
		4 "For all of it") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateHumans_partners.pdf", replace

* Read back in the original data
use "B4123_partnerData_processed.dta", clear


** Ethnicity
tab climateHumans ethnicity, col chi V

** Education
tab climateHumans edu, col chi V

** Occupational social class
tab climateHumans occSocClass, col chi V

** Income
tab climateHumans income, col chi V

** IMD
tab climateHumans imd, col chi V

** Belief in climate change
tab climateHumans climateChanging, col chi V


*** Individual actions can make a difference to long-term climate changes

** Age
tab climateAction, sum(age)
mlogit climateAction age, rrr baseoutcome(0)
mlogit climateAction c.age##c.age, rrr baseoutcome(0)

* Predicted probabilities
mlogit climateAction c.age##c.age, rrr baseoutcome(0)
margins, at(age = (50, 60, 70))

mlogit climateAction c.age##c.age, rrr baseoutcome(0)
margins, at(age = (43(1)83))

matrix res = r(table)
matrix list res
local n = colsof(res)/3

clear 
set obs `n'
egen age = fill(43 44)
gen p0 = .
gen p1 = .
gen p2 = .

forvalues i = 1(1)`n' {
	replace p0 = res[1,`i'] if _n == `i'
	replace p1 = res[1,`n' + `i'] if _n == `i'
	replace p2 = res[1,`n' + `n' + `i'] if _n == `i'
}

list, clean

twoway (line p0 age, col(black)) ///
	(line p1 age, col(red)) ///
	(line p2 age, col(blue)), ///
	xscale(range(40 85)) xlabel(45(5)85, labsize(small)) ///
	ylabel(, labsize(small)) ///
	xtitle("") ytitle("Predicted probability") yscale(titlegap(2)) ///
	title("Age", size(medium)) ///
	legend(order(1 "No" 2 "Yes" 3 "Not sure") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateAction_partners.pdf", replace

* Read back in the original data
use "B4123_partnerData_processed.dta", clear


** Ethnicity
tab climateAction ethnicity, col chi V

** Education
tab climateAction edu, col chi V

** Occupational social class
tab climateAction occSocClass, col chi V

** Income
tab climateAction income, col chi V

** IMD
tab climateAction imd, col chi V

** Belief in climate change
tab climateAction climateChanging, col chi V


*** Total number of environmental actions

** Age
corr total_actions age
regress total_actions age
regress total_actions c.age##c.age

twoway (scatter total_actions age, jitter(3) jitterseed(1234)) ///
	(qfit total_actions age)
	
graph export ".\Results\ageTotalActions_partners.pdf", replace

* Sanity check that results robust to exclusion of outliers (they are)
regress total_actions age if age >=50 & age <= 80
regress total_actions c.age##c.age if age >=50 & age <= 80

twoway (scatter total_actions age if age >=50 & age <= 80, jitter(3) jitterseed(1234)) ///
	(qfit total_actions age if age >=50 & age <= 80)


** Ethnicity
tab ethnicity, sum(total_actions)
regress total_actions i.ethnicity

** Education
tab edu, sum(total_actions)
regress total_actions i.edu

** Occupational social class
tab occSocClass, sum(total_actions)
regress total_actions i.occSocClass

** Income
tab income, sum(total_actions)
regress total_actions i.income

** IMD
tab imd, sum(total_actions)
regress total_actions i.imd

** Belief in climate change
tab climateChanging, sum(total_actions)
regress total_actions i.climateChanging

** Concern over climate change
tab climateConcern, sum(total_actions)
regress total_actions i.climateConcern

** Believes humans to blame for climate change
tab climateHumans, sum(total_actions)
regress total_actions i.climateHumans

** Individual actions can mitigate climate impact
tab climateAction, sum(total_actions)
regress total_actions i.climateAction



*****************************************************************************
**** Difference between full sample and those with climate data

* Partner's age at birth
sum ageAtBirth
sum ageAtBirth if age != .

* Partner's education
tab edu
tab edu if age != .

* IMD
tab imd
tab imd if age != .

* Ethnicity
tab ethnicity
tab ethnicity if age != .


graph close _all
log close
clear
