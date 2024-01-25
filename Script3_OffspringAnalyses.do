*** ALSPAC climate beliefs and behaviours data note - ALSPAC B-number B4123
*** Script 3: Analysing offspring data
*** Created 25/1/2024 by Dan Major-Smith
*** Stata version 18.0

** Set working directory
cd "X:\Studies\RSBB Team\Dan\B4123 - Climate Data Note"

** Install any user-written packages
*ssc install missings, replace

** Create log file
capture log close
log using "./Results/Climate_dataNote_offspringAnalyses.log", replace

** Read in dataset
use "B4123_offspringData_processed.dta", clear

* Or, if using the synthetic dataset
*use ".\AnalysisCode_ClimateDataNote_B4123\SyntheticData\syntheticData_Offspring_B4123.dta", clear


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
keep aln qlet weatherAffected-otherAffected

order aln qlet weatherAffected futureGensAffected economyAffected healthAffected neighbourhoodAffected workAffected otherAffected nothingAffected

numlabel, remove

local i = 1
foreach var of varlist weatherAffected-nothingAffected {
	rename `var' graph_`i'
	local i = `i' + 1
}

reshape long graph_, i(aln qlet) j(question)

label define q_lb 1 "Weather" 2 "Future generations" 3 "Economy" 4 "Health" 5 "Neighbourhood" 6 "Work" 7 "Other" 8 "Nothing"
label values question q_lb

graph hbar (count), over(graph_) over(question) stack asyvars percent ///
	ytitle("Percent") title("Will be affected by climate change")
	
graph export "./Results/AffectedByClimateChange_Offspring.pdf", replace

* Read back in dataset
use "B4123_offspringData_processed.dta", clear


** Individual climate actions (categorical)
tab1 travel waste energy buy airTravel elecCar localFood recycle plastic sustainable insulation solar veg trees avoidFossil children otherAction meatDairy

* Bar chart for categorical actions
keep aln qlet travel waste energy buy airTravel elecCar localFood recycle plastic sustainable insulation solar veg trees avoidFossil children meatDairy otherAction

order aln qlet recycle plastic waste sustainable buy energy meatDairy localFood travel avoidFossil airTravel veg trees insulation children elecCar otherAction solar

numlabel, remove

local i = 1
foreach var of varlist recycle-solar {
	rename `var' graph_`i'
	local i = `i' + 1
}

reshape long graph_, i(aln qlet) j(question)

label define q 1 "Recycled more" 2 "Reduced plastic use" 3 "Reduced household waste" ///
	4 "Chosen sustainable items" 5 "Changed what buy" 6 "Reduced energy use" ///
	7 "Reduced meat/dairy consumption" 8 "Bought local food" ///
	9 "Changed how travel locally" 10 "Avoided fossil fuel orgs." ///
	11 "Reduced air travel" 12 "Started growing vegetables" 13 "Planted trees" ///
	14 "Improved home insulation" 15 "Planned fewer children" ///
	16 "Used hybrid/electric car" 17 "Other action" 18 "Installed solar panels"
label values question q

graph hbar (count), over(graph_) over(question, label(labsize(small))) ///
	stack asyvars percent ///
	ytitle("Percent") title("Actions take for climate and/or other reasons") ///
	legend(rows(1) position(6) size(small))
	
graph export ".\Results\climateActions_offspring.pdf", replace

* Read back in the original data
use "B4123_offspringData_processed.dta", clear


** Individual climate actions (binary)
tab1 travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin children_bin otherAction_bin meatDairy_bin

* Bar chart for binary actions
keep aln qlet *_bin

order aln qlet recycle_bin plastic_bin waste_bin sustainable_bin buy_bin energy_bin meatDairy_bin localFood_bin travel_bin avoidFossil_bin airTravel_bin veg_bin trees_bin insulation_bin children_bin elecCar_bin otherAction_bin solar_bin

numlabel, remove

local i = 1
foreach var of varlist recycle_bin-solar_bin {
	rename `var' graph_`i'
	local i = `i' + 1
}

reshape long graph_, i(aln qlet) j(question)

label define q 1 "Recycled more" 2 "Reduced plastic use" 3 "Reduced household waste" ///
	4 "Chosen sustainable items" 5 "Changed what buy" 6 "Reduced energy use" ///
	7 "Reduced meat/dairy consumption" 8 "Bought local food" ///
	9 "Changed how travel locally" 10 "Avoided fossil fuel orgs." ///
	11 "Reduced air travel" 12 "Started growing vegetables" 13 "Planted trees" ///
	14 "Improved home insulation" 15 "Planned fewer children" ///
	16 "Used hybrid/electric car" 17 "Other action" 18 "Installed solar panels"
label values question q

graph hbar (count), over(graph_) over(question) stack asyvars percent ///
	ytitle("Percent") title("Actions taken for climate reasons")

graph export ".\Results\climateActions_binary_offspring.pdf", replace

* Read back in the original data
use "B4123_offspringData_processed.dta", clear


** Total number of climate actions
sum total_actions total_actions_red total_actions_excKids total_actions_red_excKids, d

hist total_actions, freq discrete ///
	xlabel(0(3)18) xtitle("Total number of actions taken due to climate concern")
	
graph export ".\Results\totalClimateActions_hist_offspring.pdf", replace


****************************************************************************
**** Basic associations between sociodemographic factors and climate beliefs/behaviours

*** Belief in climate change

** Age
tab climateChanging age, col chi V

** Sex
tab climateChanging sex, col chi V

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
tab climateConcern age, col chi V

** Sex
tab climateConcern sex, col chi V

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
tab climateHumans age, col chi V

** Sex
tab climateHumans sex, col chi V

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
tab climateAction age, col chi V

** Sex
tab climateAction sex, col chi V

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
tab age, sum(total_actions)
regress total_actions i.age

** Sex
tab sex, sum(total_actions)
regress total_actions i.sex

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
**** Parent-offspring similarity

** Belief in climate change
tab climateChanging climateChanging_mum, col chi V
tab climateChanging climateChanging_ptnr, col chi V

** Concern over climate change
tab climateConcern climateConcern_mum, col chi V
tab climateConcern climateConcern_ptnr, col chi V

** Humans to blame for climate change
tab climateHumans climateHumans_mum, col chi V
tab climateHumans climateHumans_ptnr, col chi V

** Individual actions can impact climate changes
tab climateAction climateAction_mum, col chi V
tab climateAction climateAction_ptnr, col chi V

** Total number of climate actions
corr total_actions_excKids total_actions_excKids_mum
regress total_actions_excKids total_actions_excKids_mum

corr total_actions_excKids total_actions_excKids_ptnr
regress total_actions_excKids total_actions_excKids_ptnr



*****************************************************************************
**** Difference between full sample and those with climate data

* Mother's age
sum mum_ageAtBirth
sum mum_ageAtBirth if age != .

* Mother's education
tab mum_edu
tab mum_edu if age != .

* IMD
tab imd
tab imd if age != .

* Ethnicity
tab ethnicity
tab ethnicity if age != .


graph close _all
log close
clear
