*** ALSPAC climate beliefs and behaviours data note - ALSPAC B-number B4123
*** Script 4: Analysing mother's data
*** Created 25/1/2024 by Dan Major-Smith
*** Stata version 18.0

** Set working directory
cd "X:\Studies\RSBB Team\Dan\B4123 - Climate Data Note"

** Install any user-written packages
*ssc install missings, replace

** Create log file
capture log close
log using "./Results/Climate_dataNote_motherAnalyses.log", replace

** Read in dataset
use "B4123_motherData_processed.dta", clear

* Or, if using the synthetic dataset
*use ".\AnalysisCode_ClimateDataNote_B4123\SyntheticData\syntheticData_mothers_B4123.dta", clear


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

order aln weatherAffected futureGensAffected economyAffected healthAffected neighbourhoodAffected workAffected otherAffected nothingAffected

numlabel, remove force

label define yn_lb 1 "Yes" 2 "No"

local i = 1
foreach var of varlist weatherAffected-nothingAffected {
	rename `var' graph_`i'
	recode graph_`i' (1 = 1) (0 = 2)
	label values graph_`i' yn_lb
	local i = `i' + 1
}

reshape long graph_, i(aln) j(question)

label define q_lb 1 "The weather" 2 "Future generations" 3 "The economy" 4 "Their health" 5 "Their neighbourhood" 6 "Their work" 7 "Other" 8 "Nothing"
label values question q_lb

graph hbar (count), over(graph_) over(question) stack asyvars percent ///
	ytitle("Percent") title("G0 mother results")
	
graph export ".\Results\AffectedByClimateChange_Mothers.pdf", replace
graph save ".\Results\AffectedByClimateChange_Mothers.gph", replace
graph export ".\Results\AffectedByClimateChange_Mothers.eps", replace

* Read back in dataset
use "B4123_motherData_processed.dta", clear


** Individual climate actions (categorical)
tab1 travel waste energy buy airTravel elecCar localFood recycle plastic sustainable insulation solar veg trees avoidFossil children otherAction meatDairy

* Bar chart for categorical actions
keep aln travel waste energy buy airTravel elecCar localFood recycle plastic sustainable insulation solar veg trees avoidFossil meatDairy otherAction

order aln plastic recycle waste sustainable energy buy localFood meatDairy insulation travel airTravel trees veg avoidFossil elecCar solar otherAction

numlabel, remove force

label define action_lb 1 "Yes, for climate" 2 "Yes, for climate and other" 3 "Yes, for other" 4 "No"

local i = 1
foreach var of varlist plastic-otherAction {
	rename `var' graph_`i'
	recode graph_`i' (0 = 4) (1 = 1) (2 = 3) (3 = 2)
	label values graph_`i' action_lb
	local i = `i' + 1
}

reshape long graph_, i(aln) j(question)

label define q 1 "Reduced plastic use" 2 "Recycled more" 3 "Reduced household waste" ///
	4 "Chosen sustainable items" 5 "Reduced energy use" 6 "Changed what buy" ///
	7 "Bought local food" 8 "Reduced meat/dairy consumption" ///
	9 "Improved home insulation" 10 "Changed how travel locally" ///
	11 "Reduced air travel" 12 "Planted trees" 13 "Started growing vegetables" ///
	14 "Avoided fossil fuel orgs." 15 "Used hybrid/electric car" ///
	16 "Installed solar panels" 17 "Other action"
label values question q

graph hbar (count), over(graph_) over(question, label(labsize(small))) ///
	stack asyvars percent ///
	ytitle("Percent") title("G0 mother results") ///
	legend(rows(1) position(6) size(small))
	
graph export ".\Results\climateActions_mothers.pdf", replace
graph save ".\Results\climateActions_mothers.gph", replace
graph export ".\Results\climateActions_mothers.eps", replace

* Read back in the original data
use "B4123_motherData_processed.dta", clear


** Individual climate actions (binary)
tab1 travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin otherAction_bin meatDairy_bin

* Bar chart for binary actions
keep aln *_bin
drop children_bin

order aln plastic_bin recycle_bin waste_bin sustainable_bin energy_bin buy_bin localFood_bin meatDairy_bin insulation_bin travel_bin airTravel_bin trees_bin veg_bin avoidFossil_bin elecCar_bin solar_bin otherAction_bin

numlabel, remove force

label define yn_lb 1 "Yes" 2 "No"

local i = 1
foreach var of varlist plastic_bin-otherAction_bin {
	rename `var' graph_`i'
	recode graph_`i' (1 = 1) (0 = 2)
	label values graph_`i' yn_lb
	local i = `i' + 1
}

reshape long graph_, i(aln) j(question)

label define q 1 "Reduced plastic use" 2 "Recycled more" 3 "Reduced household waste" ///
	4 "Chosen sustainable items" 5 "Reduced energy use" 6 "Changed what buy" ///
	7 "Bought local food" 8 "Reduced meat/dairy consumption" ///
	9 "Improved home insulation" 10 "Changed how travel locally" ///
	11 "Reduced air travel" 12 "Planted trees" 13 "Started growing vegetables" ///
	14 "Avoided fossil fuel orgs." 15 "Used hybrid/electric car" ///
	16 "Installed solar panels" 17 "Other action"
label values question q

graph hbar (count), over(graph_) over(question) stack asyvars percent ///
	ytitle("Percent") title("G0 mother results")

graph export ".\Results\climateActions_binary_mothers.pdf", replace
graph save ".\Results\climateActions_binary_mothers.gph", replace
graph export ".\Results\climateActions_binary_mothers.eps", replace

* Read back in the original data
use "B4123_motherData_processed.dta", clear


** Total number of climate actions
sum total_actions total_actions_red total_actions_excKids total_actions_red_excKids, d

tab1 total_actions total_actions_red total_actions_excKids total_actions_red_excKids

hist total_actions, freq discrete ///
	xlabel(0(3)18) xtitle("Total number of actions taken due to climate concern (G0 mother results)")
	
graph export ".\Results\totalClimateActions_hist_mothers.pdf", replace
graph save ".\Results\totalClimateActions_hist_mothers.gph", replace
graph export ".\Results\totalClimateActions_hist_mothers.eps", replace


****************************************************************************
**** Basic associations between sociodemographic factors and climate beliefs/behaviours

*** Belief in climate change

** Age
tab climateChanging, sum(age)
ologit climateChanging age, or
est store linear
ologit climateChanging c.age##c.age, or
est store quad

lrtest linear quad

* Predicted probabilities
ologit climateChanging age, or
margins, at(age = (50, 60, 70))

ologit climateChanging age, or
margins, at(age = (45(1)75))

matrix res = r(table)
matrix list res
local n = colsof(res)/5

clear 
set obs `n'
egen age = fill(45 46)
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
	xscale(range(45 75)) xlabel(45(5)75, labsize(small)) ///
	yscale(range(0, 1)) ylabel(0(0.1)1, labsize(small)) ///
	xtitle("Age") ytitle("Predicted probability") yscale(titlegap(2)) ///
	legend(order(1 "Definitely not" 2 "Probably not" 3 "Yes, maybe" ///
		4 "Yes, probably" 5 "Yes, definitely") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateChanging_mothers.pdf", replace

* Read back in the original data
use "B4123_motherData_processed.dta", clear

* If adjust for education (and/or other SEP factors) then this age association disappears (but difficult to interpret, as these could either be mediators of the age effect, or confounders for age at birth...)
ologit climateChanging age i.edu, or
ologit climateChanging age i.edu i.occSocClass i.income i.imd, or


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

** Repeat with 'definitely not' and 'probably not' combined together (due to low cell counts)
recode climateChanging (0 = 1), gen(climateChanging_grp)
label define change_grp_lb 1 "Definitely/probably not" 2 "Yes maybe" 3 "Yes probably" 4 "Yes, definitely"
numlabel change_grp_lb, add
label values climateChanging_grp change_grp_lb
tab climateChanging_grp

tab climateChanging_grp, sum(age)
ologit climateChanging_grp age, or
est store linear
ologit climateChanging_grp c.age##c.age, or
est store quad
lrtest linear quad

tab climateChanging_grp ethnicity, col chi V
tab climateChanging_grp edu, col chi V
tab climateChanging_grp occSocClass, col chi V
tab climateChanging_grp income, col chi V
tab climateChanging_grp imd, col chi V


*** Concern regarding climate change

** Age
tab climateConcern, sum(age)
ologit climateConcern age, or
est store linear
ologit climateConcern c.age##c.age, or
est store quad

lrtest linear quad

* Predicted probabilities
ologit climateConcern age, or
margins, at(age = (50, 60, 70))

ologit climateConcern age, or
margins, at(age = (45(1)75))

matrix res = r(table)
matrix list res
local n = colsof(res)/4

clear 
set obs `n'
egen age = fill(45 46)
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
	xscale(range(45 75)) xlabel(45(5)75, labsize(small)) ///
	ylabel(, labsize(small)) ///
	xtitle("Age") ytitle("Predicted probability") yscale(titlegap(2)) ///
	legend(order(1 "Not at all concerned" 2 "Not very concerned"  ///
	3 "Somewhat concerned" 4 "Very concerned") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateConcern_mothers.pdf", replace

* Read back in the original data
use "B4123_motherData_processed.dta", clear

* If adjust for education (and/or other SEP factors) then this age association still occurs
ologit climateConcern age i.edu, or
ologit climateConcern age i.edu i.occSocClass i.income i.imd, or


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
est store linear
ologit climateHumans c.age##c.age, or
est store quad

lrtest linear quad

* Predicted probabilities
ologit climateHumans age, or
margins, at(age = (50, 60, 70))

ologit climateHumans age, or
margins, at(age = (45(1)75))

matrix res = r(table)
matrix list res
local n = colsof(res)/4

clear 
set obs `n'
egen age = fill(45 46)
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
	xscale(range(45 75)) xlabel(45(5)75, labsize(small)) ///
	yscale(range(0, 0.5)) ylabel(0(0.1)0.5, labsize(small)) ///
	xtitle("Age") ytitle("Predicted probability") yscale(titlegap(2)) ///
	legend(order(1 "Not at all" 2 "For some of it" 3 "For most of it" ///
		4 "For all of it") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateHumans_mothers.pdf", replace

* Read back in the original data
use "B4123_motherData_processed.dta", clear

* If adjust for education (and/or other SEP factors) then this age association disappears
ologit climateHumans age i.edu, or
ologit climateHumans age i.edu i.occSocClass i.income i.imd, or


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
est store linear
mlogit climateAction c.age##c.age, rrr baseoutcome(0)
est store quad

lrtest linear quad

* Predicted probabilities
mlogit climateAction c.age##c.age, rrr baseoutcome(0)
margins, at(age = (50, 60, 70))

mlogit climateAction c.age##c.age, rrr baseoutcome(0)
margins, at(age = (45(1)75))

matrix res = r(table)
matrix list res
local n = colsof(res)/3

clear 
set obs `n'
egen age = fill(45 46)
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
	xscale(range(45 75)) xlabel(45(5)75, labsize(small)) ///
	ylabel(, labsize(small)) ///
	xtitle("Age") ytitle("Predicted probability") yscale(titlegap(2)) ///
	legend(order(1 "No" 2 "Yes" 3 "Not sure") ///
		position(6) rows(1) size(small) symxsize(*0.5))
	
graph export ".\Results\ageClimateAction_mothers.pdf", replace

* Read back in the original data
use "B4123_motherData_processed.dta", clear

* If adjust for education (and/or other SEP factors) then this age association weakens slightly
mlogit climateAction c.age##c.age i.edu, rrr baseoutcome(0)
mlogit climateAction c.age##c.age i.edu i.occSocClass i.income i.imd, rrr baseoutcome(0)


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
est store linear
regress total_actions c.age##c.age
est store quad

lrtest linear quad

* If adjust for education (and/or other SEP factors) then this age association disappears
regress total_actions age i.edu
regress total_actions age i.edu i.occSocClass i.income i.imd


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


** Making box plot comparing number of actions by different sociodemographic factors
numlabel, remove force

recode age (45/54 = 1) (55/64 = 2) (65/74 = 3), gen(age_cat)
label define age_lb 1 "45-54" 2 "55-64" 3 "65-74"
label values age_cat age_lb
tab age_cat

graph hbox total_actions, over(age_cat, label(labsize(small))) ///
	name(age, replace) ytitle("Total number of actions", size(small)) ///
	title("Age", size(medium)) ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(ethnicity, label(labsize(small))) ///
	name(ethnicity, replace) ytitle("Total number of actions", size(small)) ///
	title("Ethnicity", size(medium)) ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(edu, label(labsize(small))) name(edu, replace) ///
	ytitle("Total number of actions", size(small)) ///
	title("Education", size(medium)) ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(occSocClass, label(labsize(small))) ///
	name(occSocClass, replace) ytitle("Total number of actions", size(small)) ///
	title("Occupational social class", size(medium)) ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(income, label(labsize(small))) ///
	name(income, replace) ytitle("Total number of actions", size(small)) ///
	title("Weekly income", size(medium)) ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(imd, label(labsize(small))) name(imd, replace) ///
	ytitle("Total number of actions", size(small)) ///
	title("Index of multiple deprivation (quintiles)", size(medium)) ///
	ylabel(0(1)17, labsize(vsmall))

graph combine age ethnicity edu occSocClass income imd, ///
	cols(1) imargin(zero) ysize(20) xsize(12) ///
	title("G0 mothers", size(medium))

graph export ".\Results\sociodemoResults_actions_mothers.pdf", replace
graph save ".\Results\sociodemoResults_actions_mothers.gph", replace
graph export ".\Results\sociodemoResults_actions_mothers.eps", replace


** Making box plot comparing number of actions by different climate belief factors
graph hbox total_actions, over(climateChanging, label(labsize(small))) ///
	name(change, replace) ytitle("Total number of actions", size(small)) ///
	title("Belief in climate change", size(medium)) ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(climateConcern, label(labsize(small))) ///
	name(concern, replace) ytitle("Total number of actions", size(small)) ///
	title("Concern over climate change", size(medium)) ///
	ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(climateHumans, label(labsize(small))) ///
	name(humans, replace) ytitle("Total number of actions", size(small)) ///
	title("Humans are to blame for climate change", size(medium)) ///
	ylabel(0(1)17, labsize(vsmall))
graph hbox total_actions, over(climateAction, label(labsize(small))) ///
	name(action, replace) ytitle("Total number of actions", size(small)) ///
	title("Individual actions can mitigate long-term climate impact", ///
	size(medium)) ylabel(0(1)17, labsize(vsmall))

graph combine change concern humans action, ///
	cols(1) imargin(zero) ysize(16) xsize(12) ///
	title("G0 mothers", size(medium))

graph export ".\Results\climateBeliefs_actions_mothers.pdf", replace
graph save ".\Results\climateBeliefs_actions_mothers.gph", replace
graph export ".\Results\climateBeliefs_actions_mothers.eps", replace

* Read back in the original data
use "B4123_motherData_processed.dta", clear


*****************************************************************************
**** Mother-partner similarity

** Belief in climate change
tab climateChanging_ptnr climateChanging, col chi V

* Small cell count categories combined together
recode climateChanging (0 = 1), gen(climateChanging_grp)
label define change_grp_lb 1 "Definitely/probably not" 2 "Yes maybe" 3 "Yes probably" 4 "Yes, definitely"
numlabel change_grp_lb, add
label values climateChanging_grp change_grp_lb
tab climateChanging_grp

recode climateChanging_ptnr (0 = 1), gen(climateChanging_ptnr_grp)
label values climateChanging_ptnr_grp change_grp_lb
tab climateChanging_ptnr_grp

tab climateChanging_ptnr_grp climateChanging_grp, col chi V

** Concern over climate change
tab climateConcern_ptnr climateConcern, col chi V

** Humans to blame for climate change
tab climateHumans_ptnr climateHumans, col chi V

** Individual actions can impact climate changes
tab climateAction_ptnr climateAction, col chi V

** Total number of climate actions
corr total_actions_excKids total_actions_excKids_ptnr
regress total_actions_excKids total_actions_excKids_ptnr

twoway (scatter total_actions_excKids total_actions_excKids_ptnr, ///
	jitter(3) jitterseed(4321) legend(off)) ///
	(lfitci total_actions_excKids total_actions_excKids_ptnr, legend(off)), ///
	ytitle("Total number of climate actions (G0 mothers)") ///
	xtitle("Total number of climate actions (G0 partners)")
		
graph export ".\Results\mothersPartners_totalActions.pdf", replace
graph save ".\Results\mothersPartners_totalActions.gph", replace
graph export ".\Results\mothersPartners_totalActions.eps", replace


*****************************************************************************
**** Difference between full sample and those with climate data

* Mother's age at birth
sum ageAtBirth
sum ageAtBirth if age != .

* Mother's education
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
