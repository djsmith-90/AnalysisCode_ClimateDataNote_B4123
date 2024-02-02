*** ALSPAC climate beliefs and behaviours data note - ALSPAC B-number B4123
*** Script 1: Cleaning and processing the raw datasets
*** Created 24/1/2024 by Dan Major-Smith
*** Stata version 18.0

** Set working directory
cd "X:\Studies\RSBB Team\Dan\B4123 - Climate Data Note"

** Create log file
capture log close
log using "./Results/Climate_dataNote_cleaning.log", replace

** Read in dataset (NOTE: If using the synthetic datasets, start from the analysis scripts - script 3 (for offspring), 4 (for mothers) or 5 (for partners))
use "B4123_climateDataNote_dataset.dta", clear


*****************************************************************************
***** Data cleaning and processing


***** First prep file for G1 offspring

* Add value labels
numlabel, add

** Remove children not alive at 1 year of age or if withdrew consent
tab1 kz011b YPJ7500, m

drop if kz011b == 2 | kz011b == .a
drop if YPJ7500 == .b

** Keep just relevant variables for the offspring's dataset
keep aln qlet kz021 YPC2492-jan2021imd2015q5_YP ///
	mz028b c645a c804 jan2021imd2015q5_YP ///
	Z3000-Z3003 Z3020-Z3075 FPD3000-FPD3003 FPD3020-FPD3075
	
order aln qlet YPJ7500 kz021 c804 YPF7970 YPC2492 YPE6020 ///
	jan2021imd2015q5_YP mz028b c645a YPJ3000-YPJ3075 ///
	Z3000-Z3003 Z3020-Z3075 FPD3000-FPD3003 FPD3020-FPD3075


*** Go through each variable and clean ready for analysis

* Offspring age (at completion of climate questions)
tab YPJ7500, m

replace YPJ7500 = . if YPJ7500 < 0
replace YPJ7500 = 29 if YPJ7500 == 28
rename YPJ7500 age
tab age, m

* Offspring sex
tab kz021, m

rename kz021 sex
tab sex, m

* Offspring ethnicity
tab c804, m

replace c804 = . if c804 < 0
label define ethnic_lb 1 "White" 2 "Other than White"
numlabel ethnic_lb, add
label values c804 ethnic_lb
rename c804 ethnicity
tab ethnicity, m

* Offspring education
tab YPF7970, m

replace YPF7970 = . if YPF7970 < 0
recode YPF7970 (1 2 = 1) (3 4 5 = 2) (6 = 3) (7 8 = 4)
label define edu_lb 1 "GCSE" 2 "A-level" 3 "Degree" 4 "Post-grad"
numlabel edu_lb, add
label values YPF7970 edu_lb
rename YPF7970 edu
tab edu, m

* Offspring occupational social class
tab YPC2492, m

replace YPC2492 = . if YPC2492 < 0
label define occ_lb 1 "Managerial/Professional" 2 "Intermediate" 3 "Small employers" 4 "Lower supervisory/technical" 5 "(Semi-)Routine"
numlabel occ_lb, add
label values YPC2492 occ_lb
rename YPC2492 occSocClass
tab occSocClass, m

* Offspring monthly income
tab YPE6020, m

replace YPE6020 = . if YPE6020 < 0
recode YPE6020 (0 1 2 = 1) (3 4 = 2) (5 6 = 3) (7 = 4)
label define income_lb 1 "<£1000" 2 "£1000 - £1999" 3 "£2000 - £2999" 4 "£3000+"
numlabel income_lb, add
label values YPE6020 income_lb
rename YPE6020 income
tab income, m

* IMD quintile in 2021
tab jan2021imd2015q5_YP, m

replace jan2021imd2015q5_YP = . if jan2021imd2015q5_YP < 0
label define imd_lb 1 "Least deprived" 2 "2" 3 "3" 4 "4" 5 "Most deprived"
numlabel imd_lb, add
label values jan2021imd2015q5_YP imd_lb
rename jan2021imd2015q5_YP imd
tab imd, m


* Mother age at birth
tab mz028b, m

replace mz028b = . if mz028b < 0
rename mz028b mum_ageAtBirth
tab mum_ageAtBirth, m

* Mother highest education level
tab c645a, m

replace c645a = . if c645a < 0
rename c645a mum_edu
tab mum_edu, m


** Offspring climate beliefs and behaviours

* Believes that the climate is changing - ordered categorical variable 
tab YPJ3000, m

replace YPJ3000 = . if YPJ3000 < 0
rename YPJ3000 climateChanging
tab climateChanging, m


* Degree to which YP is concerned about the impact of climate change (only answered if believe climate is changing) - ordered categorical variable
tab YPJ3001, m

replace YPJ3001 = . if YPJ3001 < 0
rename YPJ3001 climateConcern
tab climateConcern, m


* Believes that humans are to blame for climate change (only answered if believe climate is changing) - ordered categorical variable
tab YPJ3002, m

replace YPJ3002 = . if YPJ3002 < 0
rename YPJ3002 climateHumans
tab climateHumans, m


* Personal actions will make difference to long-term climate changes (only answered if believe climate is changing) - unordered categorical variable
tab YPJ3003, m

replace YPJ3003 = . if YPJ3003 < 0
rename YPJ3003 climateAction
tab climateAction, m


** Questions about which things will change due to climate change
describe YPJ3010-YPJ3017

* Weather will be affected by climate change
tab YPJ3010, m

replace YPJ3010 = . if YPJ3010 < 0
rename YPJ3010 weatherAffected
tab weatherAffected, m

* Work will be affected by climate change
tab YPJ3011, m

replace YPJ3011 = . if YPJ3011 < 0
rename YPJ3011 workAffected
tab workAffected, m

* Economy will be affected by climate change
tab YPJ3012, m

replace YPJ3012 = . if YPJ3012 < 0
rename YPJ3012 economyAffected
tab economyAffected, m

* Neighbourhood will be affected by climate change
tab YPJ3013, m

replace YPJ3013 = . if YPJ3013 < 0
rename YPJ3013 neighbourhoodAffected
tab neighbourhoodAffected, m

* Health will be affected by climate change
tab YPJ3014, m

replace YPJ3014 = . if YPJ3014 < 0
rename YPJ3014 healthAffected
tab healthAffected, m

* Future generations will be affected by climate change
tab YPJ3015, m

replace YPJ3015 = . if YPJ3015 < 0
rename YPJ3015 futureGensAffected
tab futureGensAffected, m

* None of the above will be affected by climate change
tab YPJ3016, m

replace YPJ3016 = . if YPJ3016 < 0
rename YPJ3016 nothingAffected
tab nothingAffected, m

* Make sure that no-one who answered 'nothing' gave another response
count if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

list aln qlet weatherAffected-nothingAffected if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

replace nothingAffected = 0 if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

tab nothingAffected, m

* Something else will be affected by climate change
tab YPJ3017, m

replace YPJ3017 = . if YPJ3017 < 0
rename YPJ3017 otherAffected
tab otherAffected, m


** Now go through the 'actions taken due to climate change' questions and recode as appropriate into 'not done this' vs 'done for non-climate reasons' vs 'done for climate reasons' vs 'done for both climate and non-climate reasons' (while excluding impossible combinations of values - e.g., 'not done and done')

* Travelling locally
tab1 YPJ3020 YPJ3021 YPJ3022, m

replace YPJ3020 = . if YPJ3020 < 0
replace YPJ3021 = . if YPJ3021 < 0
replace YPJ3022 = . if YPJ3022 < 0

egen travel = group(YPJ3020 YPJ3021 YPJ3022), label
tab travel, m

recode travel (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable travel "Changed the way travel locally"
label define actions_lb 0 "No" 1 "Yes, for climate" 2 "Yes, for other" 3 "Yes, for climate and other"
numlabel actions_lb, add
label values travel actions_lb
tab travel, m

tab YPJ3020 YPJ3021

recode travel (0 2 = 0) (1 3 = 1), gen(travel_bin)
label variable travel_bin "Changed the way travel locally (binary)"
label define actions_bin_lb 0 "No" 1 "Yes"
numlabel actions_bin_lb, add
label values travel_bin actions_bin_lb
tab travel_bin, m

drop YPJ3020 YPJ3021 YPJ3022


* Reduced household waste
tab1 YPJ3023 YPJ3024 YPJ3025, m

replace YPJ3023 = . if YPJ3023 < 0
replace YPJ3024 = . if YPJ3024 < 0
replace YPJ3025 = . if YPJ3025 < 0

egen waste = group(YPJ3023 YPJ3024 YPJ3025), label
tab waste, m

recode waste (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable waste "Reduced household waste"
label values waste actions_lb
tab waste, m

tab YPJ3023 YPJ3024

recode waste (0 2 = 0) (1 3 = 1), gen(waste_bin)
label variable waste_bin "Reduced household waste (binary)"
label values waste_bin actions_bin_lb
tab waste_bin, m

drop YPJ3023 YPJ3024 YPJ3025


* Reduced energy use
tab1 YPJ3026 YPJ3027 YPJ3028, m

replace YPJ3026 = . if YPJ3026 < 0
replace YPJ3027 = . if YPJ3027 < 0
replace YPJ3028 = . if YPJ3028 < 0

egen energy = group(YPJ3026 YPJ3027 YPJ3028), label
tab energy, m

recode energy (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable energy "Reduced energy use"
label values energy actions_lb
tab energy, m

tab YPJ3026 YPJ3027

recode energy (0 2 = 0) (1 3 = 1), gen(energy_bin)
label variable energy_bin "Reduced energy use (binary)"
label values energy_bin actions_bin_lb
tab energy_bin, m

drop YPJ3026 YPJ3027 YPJ3028


* Changed what buy
tab1 YPJ3029 YPJ3030 YPJ3031, m

replace YPJ3029 = . if YPJ3029 < 0
replace YPJ3030 = . if YPJ3030 < 0
replace YPJ3031 = . if YPJ3031 < 0

egen buy = group(YPJ3029 YPJ3030 YPJ3031), label
tab buy, m

recode buy (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable buy "Changed what buy"
label values buy actions_lb
tab buy, m

tab YPJ3029 YPJ3030

recode buy (0 2 = 0) (1 3 = 1), gen(buy_bin)
label variable buy_bin "Changed what buy (binary)"
label values buy_bin actions_bin_lb
tab buy_bin, m

drop YPJ3029 YPJ3030 YPJ3031


* Reduced air travel
tab1 YPJ3032 YPJ3033 YPJ3034, m

replace YPJ3032 = . if YPJ3032 < 0
replace YPJ3033 = . if YPJ3033 < 0
replace YPJ3034 = . if YPJ3034 < 0

egen airTravel = group(YPJ3032 YPJ3033 YPJ3034), label
tab airTravel, m

recode airTravel (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable airTravel "Reduced air travel"
label values airTravel actions_lb
tab airTravel, m

tab YPJ3032 YPJ3033

recode airTravel (0 2 = 0) (1 3 = 1), gen(airTravel_bin)
label variable airTravel_bin "Reduced air travel (binary)"
label values airTravel_bin actions_bin_lb
tab airTravel_bin, m

drop YPJ3032 YPJ3033 YPJ3034


* Electric/hybrid car
tab1 YPJ3035 YPJ3036 YPJ3037, m

replace YPJ3035 = . if YPJ3035 < 0
replace YPJ3036 = . if YPJ3036 < 0
replace YPJ3037 = . if YPJ3037 < 0

egen elecCar = group(YPJ3035 YPJ3036 YPJ3037), label
tab elecCar, m

recode elecCar (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable elecCar "Electric/hybrid car"
label values elecCar actions_lb
tab elecCar, m

tab YPJ3035 YPJ3036

recode elecCar (0 2 = 0) (1 3 = 1), gen(elecCar_bin)
label variable elecCar_bin "Electric/hybrid car (binary)"
label values elecCar_bin actions_bin_lb
tab elecCar_bin, m

drop YPJ3035 YPJ3036 YPJ3037


* Bought local food
tab1 YPJ3038 YPJ3039 YPJ3040, m

replace YPJ3038 = . if YPJ3038 < 0
replace YPJ3039 = . if YPJ3039 < 0
replace YPJ3040 = . if YPJ3040 < 0

egen localFood = group(YPJ3038 YPJ3039 YPJ3040), label
tab localFood, m

recode localFood (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable localFood "Bought local food"
label values localFood actions_lb
tab localFood, m

tab YPJ3038 YPJ3039 

recode localFood (0 2 = 0) (1 3 = 1), gen(localFood_bin)
label variable localFood_bin "Bought local food (binary)"
label values localFood_bin actions_bin_lb
tab localFood_bin, m

drop YPJ3038 YPJ3039 YPJ3040


* Recycled more
tab1 YPJ3041 YPJ3042 YPJ3043, m

replace YPJ3041 = . if YPJ3041 < 0
replace YPJ3042 = . if YPJ3042 < 0
replace YPJ3043 = . if YPJ3043 < 0

egen recycle = group(YPJ3041 YPJ3042 YPJ3043), label
tab recycle, m

recode recycle (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable recycle "Recycled more"
label values recycle actions_lb
tab recycle, m

tab YPJ3041 YPJ3042

recode recycle (0 2 = 0) (1 3 = 1), gen(recycle_bin)
label variable recycle_bin "Recycled more (binary)"
label values recycle_bin actions_bin_lb
tab recycle_bin, m

drop YPJ3041 YPJ3042 YPJ3043


* Reduced plastic use
tab1 YPJ3044 YPJ3045 YPJ3046, m

replace YPJ3044 = . if YPJ3044 < 0
replace YPJ3045 = . if YPJ3045 < 0
replace YPJ3046 = . if YPJ3046 < 0

egen plastic = group(YPJ3044 YPJ3045 YPJ3046), label
tab plastic, m

recode plastic (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable plastic "Reduced plastic use"
label values plastic actions_lb
tab plastic, m

tab YPJ3044 YPJ3045

recode plastic (0 2 = 0) (1 3 = 1), gen(plastic_bin)
label variable plastic_bin "Reduced plastic use (binary)"
label values plastic_bin actions_bin_lb
tab plastic_bin, m

drop YPJ3044 YPJ3045 YPJ3046


* Chosen sustainably sourced items
tab1 YPJ3047 YPJ3048 YPJ3049, m

replace YPJ3047 = . if YPJ3047 < 0
replace YPJ3048 = . if YPJ3048 < 0
replace YPJ3049 = . if YPJ3049 < 0

egen sustainable = group(YPJ3047 YPJ3048 YPJ3049), label
tab sustainable, m

recode sustainable (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable sustainable "Chosen sustainably sourced items"
label values sustainable actions_lb
tab sustainable, m

tab YPJ3047 YPJ3048

recode sustainable (0 2 = 0) (1 3 = 1), gen(sustainable_bin)
label variable sustainable_bin "Chosen sustainably sourced items (binary)"
label values sustainable_bin actions_bin_lb
tab sustainable_bin, m

drop YPJ3047 YPJ3048 YPJ3049


* Improved home insulation
tab1 YPJ3050 YPJ3051 YPJ3052, m

replace YPJ3050 = . if YPJ3050 < 0
replace YPJ3051 = . if YPJ3051 < 0
replace YPJ3052 = . if YPJ3052 < 0

egen insulation = group(YPJ3050 YPJ3051 YPJ3052), label
tab insulation, m

recode insulation (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable insulation "Improved home insulation"
label values insulation actions_lb
tab insulation, m

tab YPJ3050 YPJ3051

recode insulation (0 2 = 0) (1 3 = 1), gen(insulation_bin)
label variable insulation_bin "Improved home insulation (binary)"
label values insulation_bin actions_bin_lb
tab insulation_bin, m

drop YPJ3050 YPJ3051 YPJ3052


* Installed solar panels
tab1 YPJ3053 YPJ3054 YPJ3055, m

replace YPJ3053 = . if YPJ3053 < 0
replace YPJ3054 = . if YPJ3054 < 0
replace YPJ3055 = . if YPJ3055 < 0

egen solar = group(YPJ3053 YPJ3054 YPJ3055), label
tab solar, m

recode solar (1 5 7 8 =.) (2=0) (3=2) (4=1) (6=3)
label variable solar "Installed solar panels"
label values solar actions_lb
tab solar, m

tab YPJ3053 YPJ3054

recode solar (0 2 = 0) (1 3 = 1), gen(solar_bin)
label variable solar_bin "Installed solar panels (binary)"
label values solar_bin actions_bin_lb
tab solar_bin, m

drop YPJ3053 YPJ3054 YPJ3055


* Started growing vegetables
tab1 YPJ3056 YPJ3057 YPJ3058, m

replace YPJ3056 = . if YPJ3056 < 0
replace YPJ3057 = . if YPJ3057 < 0
replace YPJ3058 = . if YPJ3058 < 0

egen veg = group(YPJ3056 YPJ3057 YPJ3058), label
tab veg, m

recode veg (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable veg "Started growing vegetables"
label values veg actions_lb
tab veg, m

tab YPJ3056 YPJ3057

recode veg (0 2 = 0) (1 3 = 1), gen(veg_bin)
label variable veg_bin "Started growing vegetables (binary)"
label values veg_bin actions_bin_lb
tab veg_bin, m

drop YPJ3056 YPJ3057 YPJ3058


* Planted trees
tab1 YPJ3059 YPJ3060 YPJ3061, m

replace YPJ3059 = . if YPJ3059 < 0
replace YPJ3060 = . if YPJ3060 < 0
replace YPJ3061 = . if YPJ3061 < 0

egen trees = group(YPJ3059 YPJ3060 YPJ3061), label
tab trees, m

recode trees (1 5 7 8 =.) (2=0) (3=2) (4=1) (6=3)
label variable trees "Planted trees"
label values trees actions_lb
tab trees, m

tab YPJ3059 YPJ3060

recode trees (0 2 = 0) (1 3 = 1), gen(trees_bin)
label variable trees_bin "Planted trees (binary)"
label values trees_bin actions_bin_lb
tab trees_bin, m

drop YPJ3059 YPJ3060 YPJ3061


* Avoided fossil fuel organisations
tab1 YPJ3062 YPJ3063 YPJ3064, m

replace YPJ3062 = . if YPJ3062 < 0
replace YPJ3063 = . if YPJ3063 < 0
replace YPJ3064 = . if YPJ3064 < 0

egen avoidFossil = group(YPJ3062 YPJ3063 YPJ3064), label
tab avoidFossil, m

recode avoidFossil (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable avoidFossil "Avoided fossil fuel organisations"
label values avoidFossil actions_lb
tab avoidFossil, m

tab YPJ3062 YPJ3063

recode avoidFossil (0 2 = 0) (1 3 = 1), gen(avoidFossil_bin)
label variable avoidFossil_bin "Avoided fossil fuel organisations (binary)"
label values avoidFossil_bin actions_bin_lb
tab avoidFossil_bin, m

drop YPJ3062 YPJ3063 YPJ3064


* Planned fewer children
tab1 YPJ3065 YPJ3066 YPJ3067, m

replace YPJ3065 = . if YPJ3065 < 0
replace YPJ3066 = . if YPJ3066 < 0
replace YPJ3067 = . if YPJ3067 < 0

egen children = group(YPJ3065 YPJ3066 YPJ3067), label
tab children, m

recode children (1 4 6 8 =.) (2=0) (3=2) (5=1) (7=3)
label variable children "Planned fewer children"
label values children actions_lb
tab children, m

tab YPJ3065 YPJ3066

recode children (0 2 = 0) (1 3 = 1), gen(children_bin)
label variable children_bin "Planned fewer children (binary)"
label values children_bin actions_bin_lb
tab children_bin, m

drop YPJ3065 YPJ3066 YPJ3067


* Taken other climate action
tab1 YPJ3068 YPJ3069 YPJ3070, m

replace YPJ3068 = . if YPJ3068 < 0
replace YPJ3069 = . if YPJ3069 < 0
replace YPJ3070 = . if YPJ3070 < 0

egen otherAction = group(YPJ3068 YPJ3069 YPJ3070), label
tab otherAction, m

recode otherAction (1 5 7 8 =.) (2=0) (3=2) (4=1) (6=3)
label variable otherAction "Taken other climate action"
label values otherAction actions_lb
tab otherAction, m

tab YPJ3068 YPJ3069

recode otherAction (0 2 = 0) (1 3 = 1), gen(otherAction_bin)
label variable otherAction_bin "Taken other climate action (binary)"
label values otherAction_bin actions_bin_lb
tab otherAction_bin, m

drop YPJ3068 YPJ3069 YPJ3070


* Reduced meat/dairy consumption
tab1 YPJ3071 YPJ3072 YPJ3073, m

replace YPJ3071 = . if YPJ3071 < 0
replace YPJ3072 = . if YPJ3072 < 0
replace YPJ3073 = . if YPJ3073 < 0

egen meatDairy = group(YPJ3071 YPJ3072 YPJ3073), label
tab meatDairy, m

recode meatDairy (1 4 7 8 =.) (2=0) (3=2) (5=1) (6=3)
label variable meatDairy "Reduced meat/dairy consumption"
label values meatDairy actions_lb
tab meatDairy, m

tab YPJ3071 YPJ3072

* Check answers if vegan/vegatarian - This is complicated, as some vegetarians/vegans answered this question, while others did not (vegetarians should also not be a separate category as they can still reduce dairy consumption, but hey ho). Will exclude answers from those who said 'always vegan' (as should not consume any meat or dairy products), but keep answers from those who said 'always vegetarian' 
tab1 YPJ3074 YPJ3075, m

tab meatDairy if YPJ3074 == 1 | YPJ3075 == 1
tab1 YPJ3074 YPJ3075 if meatDairy != .

replace meatDairy = . if YPJ3075 == 1
tab meatDairy, m
drop YPJ3074 YPJ3075

recode meatDairy (0 2 = 0) (1 3 = 1), gen(meatDairy_bin)
label variable meatDairy_bin "Reduced meat/dairy consumption (binary)"
label values meatDairy_bin actions_bin_lb
tab meatDairy_bin, m

drop YPJ3071 YPJ3072 YPJ3073


** Calculate total number of actions taken for climate reasons (will exclude 'other' though)
egen total_actions = rowtotal(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin children_bin meatDairy_bin), missing

tab total_actions, m
sum total_actions

* Code as missing if any questions missing
egen total_miss = rowmiss(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin children_bin meatDairy_bin)
tab total_miss, m

replace total_actions = . if total_miss > 0
tab total_actions, m
sum total_actions

drop total_miss


** Also calculate total number of actions excluding one's which may be prohibitively costly (i.e., excluding air travel, electric car, home insulation, solar panels and growing vegetables)
egen total_actions_red = rowtotal(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin children_bin meatDairy_bin), missing

tab total_actions_red, m
sum total_actions_red

* Code as missing if any questions missing
egen total_miss_red = rowmiss(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin children_bin meatDairy_bin)
tab total_miss_red, m

replace total_actions_red = . if total_miss_red > 0
tab total_actions_red, m
sum total_actions_red

drop total_miss_red


** Also calculate number of actions excluding 'had fewer/no children' to match parent data (as question not relevant for parents)
egen total_actions_excKids = rowtotal(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin meatDairy_bin), missing

tab total_actions_excKids, m
sum total_actions_excKids

* Code as missing if any questions missing
egen total_miss_excKids = rowmiss(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin meatDairy_bin)
tab total_miss_excKids, m

replace total_actions_excKids = . if total_miss_excKids > 0
tab total_actions_excKids, m
sum total_actions_excKids

drop total_miss_excKids


** And for reduced number of actions
egen total_actions_red_excKids = rowtotal(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin meatDairy_bin), missing

tab total_actions_red_excKids, m
sum total_actions_red_excKids

* Code as missing if any questions missing
egen total_miss_red_excKids = rowmiss(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin meatDairy_bin)
tab total_miss_red_excKids, m

replace total_actions_red_excKids = . if total_miss_red_excKids > 0
tab total_actions_red_excKids, m
sum total_actions_red_excKids

drop total_miss_red_excKids


*** Mother's climate beliefs and behaviours

* Believes that the climate is changing - ordered categorical variable 
tab Z3000, m

replace Z3000 = . if Z3000 < 0
rename Z3000 climateChanging_mum
tab climateChanging_mum, m


* Degree to which is concerned about the impact of climate change (only answered if believe climate is changing) - ordered categorical variable
tab Z3001, m

replace Z3001 = . if Z3001 < 0
rename Z3001 climateConcern_mum
tab climateConcern_mum, m


* Believes that humans are to blame for climate change (only answered if believe climate is changing) - ordered categorical variable
tab Z3002, m

replace Z3002 = . if Z3002 < 0
rename Z3002 climateHumans_mum
tab climateHumans_mum, m


* Personal actions will make difference to long-term climate changes (only answered if believe climate is changing) - unordered categorical variable
tab Z3003, m

replace Z3003 = . if Z3003 < 0
rename Z3003 climateAction_mum
tab climateAction_mum, m


** Questions about which things will change due to climate change (wont include here for intergenerational comparisons)


** Now go through the 'actions taken due to climate change' questions and recode as appropriate into 'not done this' vs 'done for non-climate reasons' vs 'done for climate reasons' vs 'done for both climate and non-climate reasons' (while excluding impossible combinations of values - e.g., 'not done and done')

* Travelling locally
tab1 Z3020 Z3021 Z3022, m

replace Z3020 = . if Z3020 < 0
replace Z3021 = . if Z3021 < 0
replace Z3022 = . if Z3022 < 0

egen travel_mum = group(Z3020 Z3021 Z3022), label
tab travel_mum, m

recode travel_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable travel_mum "Changed the way travel locally"
label values travel_mum actions_lb
tab travel_mum, m

tab Z3020 Z3021

recode travel_mum (0 2 = 0) (1 3 = 1), gen(travel_bin_mum)
label variable travel_bin_mum "Changed the way travel locally (binary)"
label values travel_bin_mum actions_bin_lb
tab travel_bin_mum, m

drop Z3020 Z3021 Z3022


* Reduced household waste
tab1 Z3023 Z3024 Z3025, m

replace Z3023 = . if Z3023 < 0
replace Z3024 = . if Z3024 < 0
replace Z3025 = . if Z3025 < 0

egen waste_mum = group(Z3023 Z3024 Z3025), label
tab waste_mum, m

recode waste_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable waste_mum "Reduced household waste"
label values waste_mum actions_lb
tab waste_mum, m

tab Z3023 Z3024

recode waste_mum (0 2 = 0) (1 3 = 1), gen(waste_bin_mum)
label variable waste_bin_mum "Reduced household waste (binary)"
label values waste_bin_mum actions_bin_lb
tab waste_bin_mum, m

drop Z3023 Z3024 Z3025


* Reduced energy use
tab1 Z3026 Z3027 Z3028, m

replace Z3026 = . if Z3026 < 0
replace Z3027 = . if Z3027 < 0
replace Z3028 = . if Z3028 < 0

egen energy_mum = group(Z3026 Z3027 Z3028), label
tab energy_mum, m

recode energy_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable energy_mum "Reduced energy use"
label values energy_mum actions_lb
tab energy_mum, m

tab Z3026 Z3027

recode energy_mum (0 2 = 0) (1 3 = 1), gen(energy_bin_mum)
label variable energy_bin_mum "Reduced energy use (binary)"
label values energy_bin_mum actions_bin_lb
tab energy_bin_mum, m

drop Z3026 Z3027 Z3028


* Changed what buy
tab1 Z3029 Z3030 Z3031, m

replace Z3029 = . if Z3029 < 0
replace Z3030 = . if Z3030 < 0
replace Z3031 = . if Z3031 < 0

egen buy_mum = group(Z3029 Z3030 Z3031), label
tab buy_mum, m

recode buy_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable buy_mum "Changed what buy"
label values buy_mum actions_lb
tab buy_mum, m

tab Z3029 Z3030

recode buy_mum (0 2 = 0) (1 3 = 1), gen(buy_bin_mum)
label variable buy_bin_mum "Changed what buy (binary)"
label values buy_bin_mum actions_bin_lb
tab buy_bin_mum, m

drop Z3029 Z3030 Z3031


* Reduced air travel
tab1 Z3032 Z3033 Z3034, m

replace Z3032 = . if Z3032 < 0
replace Z3033 = . if Z3033 < 0
replace Z3034 = . if Z3034 < 0

egen airTravel_mum = group(Z3032 Z3033 Z3034), label
tab airTravel_mum, m

recode airTravel_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable airTravel_mum "Reduced air travel"
label values airTravel_mum actions_lb
tab airTravel_mum, m

tab Z3032 Z3033

recode airTravel_mum (0 2 = 0) (1 3 = 1), gen(airTravel_bin_mum)
label variable airTravel_bin_mum "Reduced air travel (binary)"
label values airTravel_bin_mum actions_bin_lb
tab airTravel_bin_mum, m

drop Z3032 Z3033 Z3034


* Electric/hybrid car
tab1 Z3035 Z3036 Z3037, m

replace Z3035 = . if Z3035 < 0
replace Z3036 = . if Z3036 < 0
replace Z3037 = . if Z3037 < 0

egen elecCar_mum = group(Z3035 Z3036 Z3037), label
tab elecCar_mum, m

recode elecCar_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable elecCar_mum "Electric/hybrid car"
label values elecCar_mum actions_lb
tab elecCar_mum, m

tab Z3035 Z3036

recode elecCar_mum (0 2 = 0) (1 3 = 1), gen(elecCar_bin_mum)
label variable elecCar_bin_mum "Electric/hybrid car (binary)"
label values elecCar_bin_mum actions_bin_lb
tab elecCar_bin_mum, m

drop Z3035 Z3036 Z3037


* Bought local food
tab1 Z3038 Z3039 Z3040, m

replace Z3038 = . if Z3038 < 0
replace Z3039 = . if Z3039 < 0
replace Z3040 = . if Z3040 < 0

egen localFood_mum = group(Z3038 Z3039 Z3040), label
tab localFood_mum, m

recode localFood_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable localFood_mum "Bought local food"
label values localFood_mum actions_lb
tab localFood_mum, m

tab Z3038 Z3039 

recode localFood_mum (0 2 = 0) (1 3 = 1), gen(localFood_bin_mum)
label variable localFood_bin_mum "Bought local food (binary)"
label values localFood_bin_mum actions_bin_lb
tab localFood_bin_mum, m

drop Z3038 Z3039 Z3040


* Recycled more
tab1 Z3041 Z3042 Z3043, m

replace Z3041 = . if Z3041 < 0
replace Z3042 = . if Z3042 < 0
replace Z3043 = . if Z3043 < 0

egen recycle_mum = group(Z3041 Z3042 Z3043), label
tab recycle_mum, m

recode recycle_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable recycle_mum "Recycled more"
label values recycle_mum actions_lb
tab recycle_mum, m

tab Z3041 Z3042

recode recycle_mum (0 2 = 0) (1 3 = 1), gen(recycle_bin_mum)
label variable recycle_bin_mum "Recycled more (binary)"
label values recycle_bin_mum actions_bin_lb
tab recycle_bin_mum, m

drop Z3041 Z3042 Z3043


* Reduced plastic use
tab1 Z3044 Z3045 Z3046, m

replace Z3044 = . if Z3044 < 0
replace Z3045 = . if Z3045 < 0
replace Z3046 = . if Z3046 < 0

egen plastic_mum = group(Z3044 Z3045 Z3046), label
tab plastic_mum, m

recode plastic_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable plastic_mum "Reduced plastic use"
label values plastic_mum actions_lb
tab plastic_mum, m

tab Z3044 Z3045

recode plastic_mum (0 2 = 0) (1 3 = 1), gen(plastic_bin_mum)
label variable plastic_bin_mum "Reduced plastic use (binary)"
label values plastic_bin_mum actions_bin_lb
tab plastic_bin_mum, m

drop Z3044 Z3045 Z3046


* Chosen sustainably sourced items
tab1 Z3047 Z3048 Z3049, m

replace Z3047 = . if Z3047 < 0
replace Z3048 = . if Z3048 < 0
replace Z3049 = . if Z3049 < 0

egen sustainable_mum = group(Z3047 Z3048 Z3049), label
tab sustainable_mum, m

recode sustainable_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable sustainable_mum "Chosen sustainably sourced items"
label values sustainable_mum actions_lb
tab sustainable_mum, m

tab Z3047 Z3048

recode sustainable_mum (0 2 = 0) (1 3 = 1), gen(sustainable_bin_mum)
label variable sustainable_bin_mum "Chosen sustainably sourced items (binary)"
label values sustainable_bin_mum actions_bin_lb
tab sustainable_bin_mum, m

drop Z3047 Z3048 Z3049


* Improved home insulation
tab1 Z3050 Z3051 Z3052, m

replace Z3050 = . if Z3050 < 0
replace Z3051 = . if Z3051 < 0
replace Z3052 = . if Z3052 < 0

egen insulation_mum = group(Z3050 Z3051 Z3052), label
tab insulation_mum, m

recode insulation_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable insulation_mum "Improved home insulation"
label values insulation_mum actions_lb
tab insulation_mum, m

tab Z3050 Z3051

recode insulation_mum (0 2 = 0) (1 3 = 1), gen(insulation_bin_mum)
label variable insulation_bin_mum "Improved home insulation (binary)"
label values insulation_bin_mum actions_bin_lb
tab insulation_bin_mum, m

drop Z3050 Z3051 Z3052


* Installed solar panels
tab1 Z3053 Z3054 Z3055, m

replace Z3053 = . if Z3053 < 0
replace Z3054 = . if Z3054 < 0
replace Z3055 = . if Z3055 < 0

egen solar_mum = group(Z3053 Z3054 Z3055), label
tab solar_mum, m

recode solar_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable solar_mum "Installed solar panels"
label values solar_mum actions_lb
tab solar_mum, m

tab Z3053 Z3054

recode solar_mum (0 2 = 0) (1 3 = 1), gen(solar_bin_mum)
label variable solar_bin_mum "Installed solar panels (binary)"
label values solar_bin_mum actions_bin_lb
tab solar_bin_mum, m

drop Z3053 Z3054 Z3055


* Started growing vegetables
tab1 Z3056 Z3057 Z3058, m

replace Z3056 = . if Z3056 < 0
replace Z3057 = . if Z3057 < 0
replace Z3058 = . if Z3058 < 0

egen veg_mum = group(Z3056 Z3057 Z3058), label
tab veg_mum, m

recode veg_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable veg_mum "Started growing vegetables"
label values veg_mum actions_lb
tab veg_mum, m

tab Z3056 Z3057

recode veg_mum (0 2 = 0) (1 3 = 1), gen(veg_bin_mum)
label variable veg_bin_mum "Started growing vegetables (binary)"
label values veg_bin_mum actions_bin_lb
tab veg_bin_mum, m

drop Z3056 Z3057 Z3058


* Planted trees
tab1 Z3059 Z3060 Z3061, m

replace Z3059 = . if Z3059 < 0
replace Z3060 = . if Z3060 < 0
replace Z3061 = . if Z3061 < 0

egen trees_mum = group(Z3059 Z3060 Z3061), label
tab trees_mum, m

recode trees_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable trees_mum "Planted trees"
label values trees_mum actions_lb
tab trees_mum, m

tab Z3059 Z3060

recode trees_mum (0 2 = 0) (1 3 = 1), gen(trees_bin_mum)
label variable trees_bin_mum "Planted trees (binary)"
label values trees_bin_mum actions_bin_lb
tab trees_bin_mum, m

drop Z3059 Z3060 Z3061


* Avoided fossil fuel organisations
tab1 Z3062 Z3063 Z3064, m

replace Z3062 = . if Z3062 < 0
replace Z3063 = . if Z3063 < 0
replace Z3064 = . if Z3064 < 0

egen avoidFossil_mum = group(Z3062 Z3063 Z3064), label
tab avoidFossil_mum, m

recode avoidFossil_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable avoidFossil_mum "Avoided fossil fuel organisations"
label values avoidFossil_mum actions_lb
tab avoidFossil_mum, m

tab Z3062 Z3063

recode avoidFossil_mum (0 2 = 0) (1 3 = 1), gen(avoidFossil_bin_mum)
label variable avoidFossil_bin_mum "Avoided fossil fuel organisations (binary)"
label values avoidFossil_bin_mum actions_bin_lb
tab avoidFossil_bin_mum, m

drop Z3062 Z3063 Z3064


* Planned fewer children
tab1 Z3065 Z3066 Z3067, m

replace Z3065 = . if Z3065 < 0
replace Z3066 = . if Z3066 < 0
replace Z3067 = . if Z3067 < 0

egen children_mum = group(Z3065 Z3066 Z3067), label
tab children_mum, m

recode children_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable children_mum "Planned fewer children"
label values children_mum actions_lb
tab children_mum, m

tab Z3065 Z3066

recode children_mum (0 2 = 0) (1 3 = 1), gen(children_bin_mum)
label variable children_bin_mum "Planned fewer children (binary)"
label values children_bin_mum actions_bin_lb
tab children_bin_mum, m

drop Z3065 Z3066 Z3067


* Taken other climate action
tab1 Z3068 Z3069 Z3070, m

replace Z3068 = . if Z3068 < 0
replace Z3069 = . if Z3069 < 0
replace Z3070 = . if Z3070 < 0

egen otherAction_mum = group(Z3068 Z3069 Z3070), label
tab otherAction_mum, m

recode otherAction_mum (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable otherAction_mum "Taken other climate action"
label values otherAction_mum actions_lb
tab otherAction_mum, m

tab Z3068 Z3069

recode otherAction_mum (0 2 = 0) (1 3 = 1), gen(otherAction_bin_mum)
label variable otherAction_bin_mum "Taken other climate action (binary)"
label values otherAction_bin_mum actions_bin_lb
tab otherAction_bin_mum, m

drop Z3068 Z3069 Z3070


* Reduced meat/dairy consumption
tab1 Z3071 Z3072 Z3073, m

replace Z3071 = . if Z3071 < 0
replace Z3072 = . if Z3072 < 0
replace Z3073 = . if Z3073 < 0

egen meatDairy_mum = group(Z3071 Z3072 Z3073), label
tab meatDairy_mum, m

recode meatDairy_mum (1 4 6 =.) (2=0) (3=2) (5=1) (7=3)
label variable meatDairy_mum "Reduced meat/dairy consumption"
label values meatDairy_mum actions_lb
tab meatDairy_mum, m

tab Z3071 Z3072

* Check answers if vegan/vegatarian - This is complicated, as some vegetarians/vegans answered this question, while others did not (vegetarians should also not be a separate category as they can still reduce dairy consumption, but hey ho). Will exclude answers from those who said 'always vegan' (as should not consume any meat or dairy products), but keep answers from those who said 'always vegetarian' 
tab1 Z3074 Z3075, m

tab meatDairy_mum if Z3074 == 1 | Z3075 == 1
tab1 Z3074 Z3075 if meatDairy_mum != .

replace meatDairy_mum = . if Z3075 == 1
tab meatDairy_mum, m
drop Z3074 Z3075

recode meatDairy_mum (0 2 = 0) (1 3 = 1), gen(meatDairy_bin_mum)
label variable meatDairy_bin_mum "Reduced meat/dairy consumption (binary)"
label values meatDairy_bin_mum actions_bin_lb
tab meatDairy_bin_mum, m

drop Z3071 Z3072 Z3073



** Calculate number of actions excluding 'had fewer/no children' (as question not relevant for parents)
egen total_actions_excKids_mum = rowtotal(travel_bin_mum waste_bin_mum energy_bin_mum buy_bin_mum airTravel_bin_mum elecCar_bin_mum localFood_bin_mum recycle_bin_mum plastic_bin_mum sustainable_bin_mum insulation_bin_mum solar_bin_mum veg_bin_mum trees_bin_mum avoidFossil_bin_mum meatDairy_bin_mum), missing

tab total_actions_excKids_mum, m
sum total_actions_excKids_mum

* Code as missing if any questions missing
egen total_miss_excKids_mum = rowmiss(travel_bin_mum waste_bin_mum energy_bin_mum buy_bin_mum airTravel_bin_mum elecCar_bin_mum localFood_bin_mum recycle_bin_mum plastic_bin_mum sustainable_bin_mum insulation_bin_mum solar_bin_mum veg_bin_mum trees_bin_mum avoidFossil_bin_mum meatDairy_bin_mum)
tab total_miss_excKids_mum, m

replace total_actions_excKids_mum = . if total_miss_excKids_mum > 0
tab total_actions_excKids_mum, m
sum total_actions_excKids_mum

drop total_miss_excKids_mum


** And for reduced number of actions
egen total_actions_red_excKids_mum = rowtotal(travel_bin_mum waste_bin_mum energy_bin_mum buy_bin_mum localFood_bin_mum recycle_bin_mum plastic_bin_mum sustainable_bin_mum trees_bin_mum avoidFossil_bin_mum meatDairy_bin_mum), missing

tab total_actions_red_excKids_mum, m
sum total_actions_red_excKids_mum

* Code as missing if any questions missing
egen total_miss_red_excKids_mum = rowmiss(travel_bin_mum waste_bin_mum energy_bin_mum buy_bin_mum localFood_bin_mum recycle_bin_mum plastic_bin_mum sustainable_bin_mum trees_bin_mum avoidFossil_bin_mum meatDairy_bin_mum)
tab total_miss_red_excKids_mum, m

replace total_actions_red_excKids_mum = . if total_miss_red_excKids_mum > 0
tab total_actions_red_excKids_mum, m
sum total_actions_red_excKids_mum

drop total_miss_red_excKids_mum


** And drop all of the individual actions (as not needed for comparisons between generations)
drop travel_mum-meatDairy_bin_mum


*** Partners's climate beliefs and behaviours

* Recode all withdrawals of consent as missing
foreach var of varlist FPD3000-FPD3075 {
	replace `var' = . if `var' == .c
}

* Believes that the climate is changing - ordered categorical variable 
tab FPD3000, m

replace FPD3000 = . if FPD3000 < 0
rename FPD3000 climateChanging_ptnr
tab climateChanging_ptnr, m


* Degree to which is concerned about the impact of climate change (only answered if believe climate is changing) - ordered categorical variable
tab FPD3001, m

replace FPD3001 = . if FPD3001 < 0
rename FPD3001 climateConcern_ptnr
tab climateConcern_ptnr, m


* Believes that humans are to blame for climate change (only answered if believe climate is changing) - ordered categorical variable
tab FPD3002, m

replace FPD3002 = . if FPD3002 < 0
rename FPD3002 climateHumans_ptnr
tab climateHumans_ptnr, m


* Personal actions will make difference to long-term climate changes (only answered if believe climate is changing) - unordered categorical variable
tab FPD3003, m

replace FPD3003 = . if FPD3003 < 0
rename FPD3003 climateAction_ptnr
tab climateAction_ptnr, m


** Questions about which things will change due to climate change (wont include here for intergenerational comparisons)


** Now go through the 'actions taken due to climate change' questions and recode as appropriate into 'not done this' vs 'done for non-climate reasons' vs 'done for climate reasons' vs 'done for both climate and non-climate reasons' (while excluding impossible combinations of values - e.g., 'not done and done')

* Travelling locally
tab1 FPD3020 FPD3021 FPD3022, m

replace FPD3020 = . if FPD3020 < 0
replace FPD3021 = . if FPD3021 < 0
replace FPD3022 = . if FPD3022 < 0

egen travel_ptnr = group(FPD3020 FPD3021 FPD3022), label
tab travel_ptnr, m

recode travel_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable travel_ptnr "Changed the way travel locally"
label values travel_ptnr actions_lb
tab travel_ptnr, m

tab FPD3020 FPD3021

recode travel_ptnr (0 2 = 0) (1 3 = 1), gen(travel_bin_ptnr)
label variable travel_bin_ptnr "Changed the way travel locally (binary)"
label values travel_bin_ptnr actions_bin_lb
tab travel_bin_ptnr, m

drop FPD3020 FPD3021 FPD3022


* Reduced household waste
tab1 FPD3023 FPD3024 FPD3025, m

replace FPD3023 = . if FPD3023 < 0
replace FPD3024 = . if FPD3024 < 0
replace FPD3025 = . if FPD3025 < 0

egen waste_ptnr = group(FPD3023 FPD3024 FPD3025), label
tab waste_ptnr, m

recode waste_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable waste_ptnr "Reduced household waste"
label values waste_ptnr actions_lb
tab waste_ptnr, m

tab FPD3023 FPD3024

recode waste_ptnr (0 2 = 0) (1 3 = 1), gen(waste_bin_ptnr)
label variable waste_bin_ptnr "Reduced household waste (binary)"
label values waste_bin_ptnr actions_bin_lb
tab waste_bin_ptnr, m

drop FPD3023 FPD3024 FPD3025


* Reduced energy use
tab1 FPD3026 FPD3027 FPD3028, m

replace FPD3026 = . if FPD3026 < 0
replace FPD3027 = . if FPD3027 < 0
replace FPD3028 = . if FPD3028 < 0

egen energy_ptnr = group(FPD3026 FPD3027 FPD3028), label
tab energy_ptnr, m

recode energy_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable energy_ptnr "Reduced energy use"
label values energy_ptnr actions_lb
tab energy_ptnr, m

tab FPD3026 FPD3027

recode energy_ptnr (0 2 = 0) (1 3 = 1), gen(energy_bin_ptnr)
label variable energy_bin_ptnr "Reduced energy use (binary)"
label values energy_bin_ptnr actions_bin_lb
tab energy_bin_ptnr, m

drop FPD3026 FPD3027 FPD3028


* Changed what buy
tab1 FPD3029 FPD3030 FPD3031, m

replace FPD3029 = . if FPD3029 < 0
replace FPD3030 = . if FPD3030 < 0
replace FPD3031 = . if FPD3031 < 0

egen buy_ptnr = group(FPD3029 FPD3030 FPD3031), label
tab buy_ptnr, m

recode buy_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable buy_ptnr "Changed what buy"
label values buy_ptnr actions_lb
tab buy_ptnr, m

tab FPD3029 FPD3030

recode buy_ptnr (0 2 = 0) (1 3 = 1), gen(buy_bin_ptnr)
label variable buy_bin_ptnr "Changed what buy (binary)"
label values buy_bin_ptnr actions_bin_lb
tab buy_bin_ptnr, m

drop FPD3029 FPD3030 FPD3031


* Reduced air travel
tab1 FPD3032 FPD3033 FPD3034, m

replace FPD3032 = . if FPD3032 < 0
replace FPD3033 = . if FPD3033 < 0
replace FPD3034 = . if FPD3034 < 0

egen airTravel_ptnr = group(FPD3032 FPD3033 FPD3034), label
tab airTravel_ptnr, m

recode airTravel_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable airTravel_ptnr "Reduced air travel"
label values airTravel_ptnr actions_lb
tab airTravel_ptnr, m

tab FPD3032 FPD3033

recode airTravel_ptnr (0 2 = 0) (1 3 = 1), gen(airTravel_bin_ptnr)
label variable airTravel_bin_ptnr "Reduced air travel (binary)"
label values airTravel_bin_ptnr actions_bin_lb
tab airTravel_bin_ptnr, m

drop FPD3032 FPD3033 FPD3034


* Electric/hybrid car
tab1 FPD3035 FPD3036 FPD3037, m

replace FPD3035 = . if FPD3035 < 0
replace FPD3036 = . if FPD3036 < 0
replace FPD3037 = . if FPD3037 < 0

egen elecCar_ptnr = group(FPD3035 FPD3036 FPD3037), label
tab elecCar_ptnr, m

recode elecCar_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable elecCar_ptnr "Electric/hybrid car"
label values elecCar_ptnr actions_lb
tab elecCar_ptnr, m

tab FPD3035 FPD3036

recode elecCar_ptnr (0 2 = 0) (1 3 = 1), gen(elecCar_bin_ptnr)
label variable elecCar_bin_ptnr "Electric/hybrid car (binary)"
label values elecCar_bin_ptnr actions_bin_lb
tab elecCar_bin_ptnr, m

drop FPD3035 FPD3036 FPD3037


* Bought local food
tab1 FPD3038 FPD3039 FPD3040, m

replace FPD3038 = . if FPD3038 < 0
replace FPD3039 = . if FPD3039 < 0
replace FPD3040 = . if FPD3040 < 0

egen localFood_ptnr = group(FPD3038 FPD3039 FPD3040), label
tab localFood_ptnr, m

recode localFood_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable localFood_ptnr "Bought local food"
label values localFood_ptnr actions_lb
tab localFood_ptnr, m

tab FPD3038 FPD3039 

recode localFood_ptnr (0 2 = 0) (1 3 = 1), gen(localFood_bin_ptnr)
label variable localFood_bin_ptnr "Bought local food (binary)"
label values localFood_bin_ptnr actions_bin_lb
tab localFood_bin_ptnr, m

drop FPD3038 FPD3039 FPD3040


* Recycled more
tab1 FPD3041 FPD3042 FPD3043, m

replace FPD3041 = . if FPD3041 < 0
replace FPD3042 = . if FPD3042 < 0
replace FPD3043 = . if FPD3043 < 0

egen recycle_ptnr = group(FPD3041 FPD3042 FPD3043), label
tab recycle_ptnr, m

recode recycle_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable recycle_ptnr "Recycled more"
label values recycle_ptnr actions_lb
tab recycle_ptnr, m

tab FPD3041 FPD3042

recode recycle_ptnr (0 2 = 0) (1 3 = 1), gen(recycle_bin_ptnr)
label variable recycle_bin_ptnr "Recycled more (binary)"
label values recycle_bin_ptnr actions_bin_lb
tab recycle_bin_ptnr, m

drop FPD3041 FPD3042 FPD3043


* Reduced plastic use
tab1 FPD3044 FPD3045 FPD3046, m

replace FPD3044 = . if FPD3044 < 0
replace FPD3045 = . if FPD3045 < 0
replace FPD3046 = . if FPD3046 < 0

egen plastic_ptnr = group(FPD3044 FPD3045 FPD3046), label
tab plastic_ptnr, m

recode plastic_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable plastic_ptnr "Reduced plastic use"
label values plastic_ptnr actions_lb
tab plastic_ptnr, m

tab FPD3044 FPD3045

recode plastic_ptnr (0 2 = 0) (1 3 = 1), gen(plastic_bin_ptnr)
label variable plastic_bin_ptnr "Reduced plastic use (binary)"
label values plastic_bin_ptnr actions_bin_lb
tab plastic_bin_ptnr, m

drop FPD3044 FPD3045 FPD3046


* Chosen sustainably sourced items
tab1 FPD3047 FPD3048 FPD3049, m

replace FPD3047 = . if FPD3047 < 0
replace FPD3048 = . if FPD3048 < 0
replace FPD3049 = . if FPD3049 < 0

egen sustainable_ptnr = group(FPD3047 FPD3048 FPD3049), label
tab sustainable_ptnr, m

recode sustainable_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable sustainable_ptnr "Chosen sustainably sourced items"
label values sustainable_ptnr actions_lb
tab sustainable_ptnr, m

tab FPD3047 FPD3048

recode sustainable_ptnr (0 2 = 0) (1 3 = 1), gen(sustainable_bin_ptnr)
label variable sustainable_bin_ptnr "Chosen sustainably sourced items (binary)"
label values sustainable_bin_ptnr actions_bin_lb
tab sustainable_bin_ptnr, m

drop FPD3047 FPD3048 FPD3049


* Improved home insulation
tab1 FPD3050 FPD3051 FPD3052, m

replace FPD3050 = . if FPD3050 < 0
replace FPD3051 = . if FPD3051 < 0
replace FPD3052 = . if FPD3052 < 0

egen insulation_ptnr = group(FPD3050 FPD3051 FPD3052), label
tab insulation_ptnr, m

recode insulation_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable insulation_ptnr "Improved home insulation"
label values insulation_ptnr actions_lb
tab insulation_ptnr, m

tab FPD3050 FPD3051

recode insulation_ptnr (0 2 = 0) (1 3 = 1), gen(insulation_bin_ptnr)
label variable insulation_bin_ptnr "Improved home insulation (binary)"
label values insulation_bin_ptnr actions_bin_lb
tab insulation_bin_ptnr, m

drop FPD3050 FPD3051 FPD3052


* Installed solar panels
tab1 FPD3053 FPD3054 FPD3055, m

replace FPD3053 = . if FPD3053 < 0
replace FPD3054 = . if FPD3054 < 0
replace FPD3055 = . if FPD3055 < 0

egen solar_ptnr = group(FPD3053 FPD3054 FPD3055), label
tab solar_ptnr, m

recode solar_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable solar_ptnr "Installed solar panels"
label values solar_ptnr actions_lb
tab solar_ptnr, m

tab FPD3053 FPD3054

recode solar_ptnr (0 2 = 0) (1 3 = 1), gen(solar_bin_ptnr)
label variable solar_bin_ptnr "Installed solar panels (binary)"
label values solar_bin_ptnr actions_bin_lb
tab solar_bin_ptnr, m

drop FPD3053 FPD3054 FPD3055


* Started growing vegetables
tab1 FPD3056 FPD3057 FPD3058, m

replace FPD3056 = . if FPD3056 < 0
replace FPD3057 = . if FPD3057 < 0
replace FPD3058 = . if FPD3058 < 0

egen veg_ptnr = group(FPD3056 FPD3057 FPD3058), label
tab veg_ptnr, m

recode veg_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable veg_ptnr "Started growing vegetables"
label values veg_ptnr actions_lb
tab veg_ptnr, m

tab FPD3056 FPD3057

recode veg_ptnr (0 2 = 0) (1 3 = 1), gen(veg_bin_ptnr)
label variable veg_bin_ptnr "Started growing vegetables (binary)"
label values veg_bin_ptnr actions_bin_lb
tab veg_bin_ptnr, m

drop FPD3056 FPD3057 FPD3058


* Planted trees
tab1 FPD3059 FPD3060 FPD3061, m

replace FPD3059 = . if FPD3059 < 0
replace FPD3060 = . if FPD3060 < 0
replace FPD3061 = . if FPD3061 < 0

egen trees_ptnr = group(FPD3059 FPD3060 FPD3061), label
tab trees_ptnr, m

recode trees_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable trees_ptnr "Planted trees"
label values trees_ptnr actions_lb
tab trees_ptnr, m

tab FPD3059 FPD3060

recode trees_ptnr (0 2 = 0) (1 3 = 1), gen(trees_bin_ptnr)
label variable trees_bin_ptnr "Planted trees (binary)"
label values trees_bin_ptnr actions_bin_lb
tab trees_bin_ptnr, m

drop FPD3059 FPD3060 FPD3061


* Avoided fossil fuel organisations
tab1 FPD3062 FPD3063 FPD3064, m

replace FPD3062 = . if FPD3062 < 0
replace FPD3063 = . if FPD3063 < 0
replace FPD3064 = . if FPD3064 < 0

egen avoidFossil_ptnr = group(FPD3062 FPD3063 FPD3064), label
tab avoidFossil_ptnr, m

recode avoidFossil_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable avoidFossil_ptnr "Avoided fossil fuel organisations"
label values avoidFossil_ptnr actions_lb
tab avoidFossil_ptnr, m

tab FPD3062 FPD3063

recode avoidFossil_ptnr (0 2 = 0) (1 3 = 1), gen(avoidFossil_bin_ptnr)
label variable avoidFossil_bin_ptnr "Avoided fossil fuel organisations (binary)"
label values avoidFossil_bin_ptnr actions_bin_lb
tab avoidFossil_bin_ptnr, m

drop FPD3062 FPD3063 FPD3064


* Planned fewer children
tab1 FPD3065 FPD3066 FPD3067, m

replace FPD3065 = . if FPD3065 < 0
replace FPD3066 = . if FPD3066 < 0
replace FPD3067 = . if FPD3067 < 0

egen children_ptnr = group(FPD3065 FPD3066 FPD3067), label
tab children_ptnr, m

recode children_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable children_ptnr "Planned fewer children"
label values children_ptnr actions_lb
tab children_ptnr, m

tab FPD3065 FPD3066

recode children_ptnr (0 2 = 0) (1 3 = 1), gen(children_bin_ptnr)
label variable children_bin_ptnr "Planned fewer children (binary)"
label values children_bin_ptnr actions_bin_lb
tab children_bin_ptnr, m

drop FPD3065 FPD3066 FPD3067


* Taken other climate action
tab1 FPD3068 FPD3069 FPD3070, m

replace FPD3068 = . if FPD3068 < 0
replace FPD3069 = . if FPD3069 < 0
replace FPD3070 = . if FPD3070 < 0

egen otherAction_ptnr = group(FPD3068 FPD3069 FPD3070), label
tab otherAction_ptnr, m

recode otherAction_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable otherAction_ptnr "Taken other climate action"
label values otherAction_ptnr actions_lb
tab otherAction_ptnr, m

tab FPD3068 FPD3069

recode otherAction_ptnr (0 2 = 0) (1 3 = 1), gen(otherAction_bin_ptnr)
label variable otherAction_bin_ptnr "Taken other climate action (binary)"
label values otherAction_bin_ptnr actions_bin_lb
tab otherAction_bin_ptnr, m

drop FPD3068 FPD3069 FPD3070


* Reduced meat/dairy consumption
tab1 FPD3071 FPD3072 FPD3073, m

replace FPD3071 = . if FPD3071 < 0
replace FPD3072 = . if FPD3072 < 0
replace FPD3073 = . if FPD3073 < 0

egen meatDairy_ptnr = group(FPD3071 FPD3072 FPD3073), label
tab meatDairy_ptnr, m

recode meatDairy_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable meatDairy_ptnr "Reduced meat/dairy consumption"
label values meatDairy_ptnr actions_lb
tab meatDairy_ptnr, m

tab FPD3071 FPD3072

* Check answers if vegan/vegatarian - This is complicated, as some vegetarians/vegans answered this question, while others did not (vegetarians should also not be a separate category as they can still reduce dairy consumption, but hey ho). Will exclude answers from those who said 'always vegan' (as should not consume any meat or dairy products), but keep answers from those who said 'always vegetarian' 
tab1 FPD3074 FPD3075, m

tab meatDairy_ptnr if FPD3074 == 1 | FPD3075 == 1
tab1 FPD3074 FPD3075 if meatDairy_ptnr != .

replace meatDairy_ptnr = . if FPD3075 == 1
tab meatDairy_ptnr, m
drop FPD3074 FPD3075

recode meatDairy_ptnr (0 2 = 0) (1 3 = 1), gen(meatDairy_bin_ptnr)
label variable meatDairy_bin_ptnr "Reduced meat/dairy consumption (binary)"
label values meatDairy_bin_ptnr actions_bin_lb
tab meatDairy_bin_ptnr, m

drop FPD3071 FPD3072 FPD3073



** Calculate number of actions excluding 'had fewer/no children' (as question not relevant for parents)
egen total_actions_excKids_ptnr = rowtotal(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr airTravel_bin_ptnr elecCar_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr insulation_bin_ptnr solar_bin_ptnr veg_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr), missing

tab total_actions_excKids_ptnr, m
sum total_actions_excKids_ptnr

* Code as missing if any questions missing
egen total_miss_excKids_ptnr = rowmiss(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr airTravel_bin_ptnr elecCar_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr insulation_bin_ptnr solar_bin_ptnr veg_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr)
tab total_miss_excKids_ptnr, m

replace total_actions_excKids_ptnr = . if total_miss_excKids_ptnr > 0
tab total_actions_excKids_ptnr, m
sum total_actions_excKids_ptnr

drop total_miss_excKids_ptnr


** And for reduced number of actions
egen total_actions_red_excKids_ptnr = rowtotal(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr), missing

tab total_actions_red_excKids_ptnr, m
sum total_actions_red_excKids_ptnr

* Code as missing if any questions missing
egen total_miss_red_excKids_ptnr = rowmiss(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr)
tab total_miss_red_excKids_ptnr, m

replace total_actions_red_excKids_ptnr = . if total_miss_red_excKids_ptnr > 0
tab total_actions_red_excKids_ptnr, m
sum total_actions_red_excKids_ptnr

drop total_miss_red_excKids_ptnr


** And drop all of the individual actions (as not needed for comparisons between generations)
drop travel_ptnr-meatDairy_bin_ptnr


*** Re-arrange the variables so the mother and partner variables are at the end of the dataset
order aln-otherAffected travel-total_actions_red_excKids climateChanging_mum-climateAction_mum total_actions_excKids_mum total_actions_red_excKids_mum climateChanging_ptnr-climateAction_ptnr total_actions_excKids_ptnr total_actions_red_excKids_ptnr


** Loop through labels and remove if negative/unnecessary
label dir

local labels r(names)
display `labels'

local labels "meatDairy_ptnr otherAction_ptnr children_ptnr avoidFossil_ptnr trees_ptnr veg_ptnr solar_ptnr insulation_ptnr sustainable_ptnr plastic_ptnr recycle_ptnr localFood_ptnr elecCar_ptnr airTravel_ptnr buy_ptnr energy_ptnr waste_ptnr travel_ptnr meatDairy_mum otherAction_mum children_mum avoidFossil_mum trees_mum veg_mum solar_mum insulation_mum sustainable_mum plastic_mum recycle_mum localFood_mum elecCar_mum airTravel_mum buy_mum energy_mum waste_mum travel_mum meatDairy otherAction children avoidFossil trees veg solar insulation sustainable plastic recycle localFood elecCar airTravel buy energy waste actions_bin_lb travel imd_lb income_lb edu_lb ethnic_lb FPD3000 FPD3001 FPD3002 FPD3003 FPD3010 FPD3011 FPD3012 FPD3013 FPD3014 FPD3015 FPD3016 FPD3017 FPD3020 FPD3021 FPD3022 FPD3023 FPD3024 FPD3025 FPD3026 FPD3027 FPD3028 FPD3029 FPD3030 FPD3031 FPD3032 FPD3033 FPD3034 FPD3035 FPD3036 FPD3037 FPD3038 FPD3039 FPD3040 FPD3041 FPD3042 FPD3043 FPD3044 FPD3045 FPD3046 FPD3047 FPD3048 FPD3049 FPD3050 FPD3051 FPD3052 FPD3053 FPD3054 FPD3055 FPD3056 FPD3057 FPD3058 FPD3059 FPD3060 FPD3061 FPD3062 FPD3063 FPD3064 FPD3065 FPD3066 FPD3067 FPD3068 FPD3069 FPD3070 FPD3071 FPD3072 FPD3073 FPD3074 FPD3075 FPD6500 YPC2492 YPE6020 YPF7970 YPJ3000 YPJ3001 YPJ3002 YPJ3003 YPJ3010 YPJ3011 YPJ3012 YPJ3013 YPJ3014 YPJ3015 YPJ3016 YPJ3017 YPJ3020 YPJ3021 YPJ3022 YPJ3023 YPJ3024 YPJ3025 YPJ3026 YPJ3027 YPJ3028 YPJ3029 YPJ3030 YPJ3031 YPJ3032 YPJ3033 YPJ3034 YPJ3035 YPJ3036 YPJ3037 YPJ3038 YPJ3039 YPJ3040 YPJ3041 YPJ3042 YPJ3043 YPJ3044 YPJ3045 YPJ3046 YPJ3047 YPJ3048 YPJ3049 YPJ3050 YPJ3051 YPJ3052 YPJ3053 YPJ3054 YPJ3055 YPJ3056 YPJ3057 YPJ3058 YPJ3059 YPJ3060 YPJ3061 YPJ3062 YPJ3063 YPJ3064 YPJ3065 YPJ3066 YPJ3067 YPJ3068 YPJ3069 YPJ3070 YPJ3071 YPJ3072 YPJ3073 YPJ3074 YPJ3075 YPJ7500 Z3000 Z3001 Z3002 Z3003 Z3010 Z3011 Z3012 Z3013 Z3014 Z3015 Z3016 Z3017 Z3020 Z3021 Z3022 Z3023 Z3024 Z3025 Z3026 Z3027 Z3028 Z3029 Z3030 Z3031 Z3032 Z3033 Z3034 Z3035 Z3036 Z3037 Z3038 Z3039 Z3040 Z3041 Z3042 Z3043 Z3044 Z3045 Z3046 Z3047 Z3048 Z3049 Z3050 Z3051 Z3052 Z3053 Z3054 Z3055 Z3056 Z3057 Z3058 Z3059 Z3060 Z3061 Z3062 Z3063 Z3064 Z3065 Z3066 Z3067 Z3068 Z3069 Z3070 Z3071 Z3072 Z3073 Z3074 Z3075 Z6500 bestgest c645a c666a c755 c765 c800 c801 c804 h470 in_core in_phase2 in_phase3 in_phase4 jan2014imd2010q5_M jan2021imd2015q5_YP kz011b kz021 kz030 mum_and_preg_enrolled mz005l mz005m mz010a mz013 mz014 mz028b partner_age partner_changed partner_changed_when partner_data partner_enrolled partner_in_alspac partner_in_core preg_enrol_status preg_in_alsp preg_in_core pz_mult pz_multid second_partner_age occ_lb actions_lb"

* Have to create labels for all objects first, before removing them (else those without the number beforehand get added one)
foreach label of local labels {
	display "`label'"
	label define `label' -9999 "test" -11 "test" -10 "test" -9 "test" -8 "test" -5 "test" -2 "test" -1 "test", modify
	label define `label' -9999 "" -11 "" -10 "" -9 "" -8 "" -5 "" -2 "" -1 "", modify
}

label list


** Save processed file here (and also for synthesising)
save "B4123_offspringData_processed.dta", replace



*****************************************************************************
****** Now for the mother's dataset

use "B4123_climateDataNote_dataset.dta", clear

* Add value labels
numlabel, add

** Remove children not alive at 1 year of age or if withdrew consent
tab1 kz011b, m

drop if kz011b == 2 | kz011b == .a

* Also drop one pregnancy if mother linked to one or more pregnancy (to avoid duplicated data)
tab mz005l, m

drop if mz005l == 1

* Also drop data from second-born twin (again, avoiding duplicated mother data)
tab qlet, m

drop if qlet == "B"

* And drop if mother not enrolled in ALSPAc (but child is)
tab mum_and_preg_enrolled, m

drop if mum_and_preg_enrolled == 2


** Keep just relevant variables for the mothers's dataset
keep aln mz028b c800 c645a c755 h470 jan2014imd2010q5_M Z6500 ///
	Z3000-Z3075 FPD3000-FPD3003 FPD3020-FPD3075
	
order aln mz028b c800 c645a c755 h470 jan2014imd2010q5_M Z6500 ///
	Z3000-Z3075 FPD3000-FPD3003 FPD3020-FPD3075


*** Go through each variable and clean ready for analysis

* Mother's age at birth
tab mz028b, m

replace mz028b = . if mz028b < 0
rename mz028b ageAtBirth
tab ageAtBirth, m

* Mother age (at completion of climate questions)
tab Z6500, m

replace Z6500 = . if Z6500 < 0
rename Z6500 age
tab age, m
sum age

* Mother ethnicity
tab c800, m

replace c800 = . if c800 < 0
recode c800 (1 = 1) (2/9 = 2)
label define ethnic_lb 1 "White" 2 "Other than white"
numlabel ethnic_lb, add
label values c800 ethnic_lb
rename c800 ethnicity
tab ethnicity, m

* Mother education
tab c645a, m

replace c645a = . if c645a < 0
rename c645a edu
tab edu, m

* Mother occupational social class
tab c755, m

replace c755 = . if c755 < 0 | c755 == 65
replace c755 = 5 if c755 == 6
label define c755 5 "IV/V" 6 "" 65 "", modify
rename c755 occSocClass
tab occSocClass, m

* Mother weekly income
tab h470, m

replace h470 = . if h470 < 0
label define h470 1 "<£100" 2 "£100 - £199" 3 "£200 - £299" 4 "£300 - £399" 5 "£400+", modify
rename h470 income
tab income, m

* IMD quintile in 2014
tab jan2014imd2010q5_M, m

replace jan2014imd2010q5_M = . if jan2014imd2010q5_M < 0
label define imd_lb 1 "Least deprived" 2 "2" 3 "3" 4 "4" 5 "Most deprived"
numlabel imd_lb, add
label values jan2014imd2010q5_M imd_lb
rename jan2014imd2010q5_M imd
tab imd, m


** Mother climate beliefs and behaviours

* Believes that the climate is changing - ordered categorical variable 
tab Z3000, m

replace Z3000 = . if Z3000 < 0
rename Z3000 climateChanging
tab climateChanging, m


* Degree to which YP is concerned about the impact of climate change (only answered if believe climate is changing) - ordered categorical variable
tab Z3001, m

replace Z3001 = . if Z3001 < 0
rename Z3001 climateConcern
tab climateConcern, m


* Believes that humans are to blame for climate change (only answered if believe climate is changing) - ordered categorical variable
tab Z3002, m

replace Z3002 = . if Z3002 < 0
rename Z3002 climateHumans
tab climateHumans, m


* Personal actions will make difference to long-term climate changes (only answered if believe climate is changing) - unordered categorical variable
tab Z3003, m

replace Z3003 = . if Z3003 < 0
rename Z3003 climateAction
tab climateAction, m


** Questions about which things will change due to climate change
describe Z3010-Z3017

* Weather will be affected by climate change
tab Z3010, m

replace Z3010 = . if Z3010 < 0
rename Z3010 weatherAffected
tab weatherAffected, m

* Work will be affected by climate change
tab Z3011, m

replace Z3011 = . if Z3011 < 0
rename Z3011 workAffected
tab workAffected, m

* Economy will be affected by climate change
tab Z3012, m

replace Z3012 = . if Z3012 < 0
rename Z3012 economyAffected
tab economyAffected, m

* Neighbourhood will be affected by climate change
tab Z3013, m

replace Z3013 = . if Z3013 < 0
rename Z3013 neighbourhoodAffected
tab neighbourhoodAffected, m

* Health will be affected by climate change
tab Z3014, m

replace Z3014 = . if Z3014 < 0
rename Z3014 healthAffected
tab healthAffected, m

* Future generations will be affected by climate change
tab Z3015, m

replace Z3015 = . if Z3015 < 0
rename Z3015 futureGensAffected
tab futureGensAffected, m

* None of the above will be affected by climate change
tab Z3016, m

replace Z3016 = . if Z3016 < 0
rename Z3016 nothingAffected
tab nothingAffected, m

* Make sure that no-one who answered 'nothing' gave another response
count if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

list aln weatherAffected-nothingAffected if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

replace nothingAffected = 0 if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

tab nothingAffected, m

* Something else will be affected by climate change
tab Z3017, m

replace Z3017 = . if Z3017 < 0
rename Z3017 otherAffected
tab otherAffected, m


** Now go through the 'actions taken due to climate change' questions and recode as appropriate into 'not done this' vs 'done for non-climate reasons' vs 'done for climate reasons' vs 'done for both climate and non-climate reasons' (while excluding impossible combinations of values - e.g., 'not done and done')

* Travelling locally
tab1 Z3020 Z3021 Z3022, m

replace Z3020 = . if Z3020 < 0
replace Z3021 = . if Z3021 < 0
replace Z3022 = . if Z3022 < 0

egen travel = group(Z3020 Z3021 Z3022), label
tab travel, m

recode travel (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable travel "Changed the way travel locally"
label define actions_lb 0 "No" 1 "Yes, for climate" 2 "Yes, for other" 3 "Yes, for climate and other"
numlabel actions_lb, add
label values travel actions_lb
tab travel, m

tab Z3020 Z3021

recode travel (0 2 = 0) (1 3 = 1), gen(travel_bin)
label variable travel_bin "Changed the way travel locally (binary)"
label define actions_bin_lb 0 "No" 1 "Yes"
numlabel actions_bin_lb, add
label values travel_bin actions_bin_lb
tab travel_bin, m

drop Z3020 Z3021 Z3022


* Reduced household waste
tab1 Z3023 Z3024 Z3025, m

replace Z3023 = . if Z3023 < 0
replace Z3024 = . if Z3024 < 0
replace Z3025 = . if Z3025 < 0

egen waste = group(Z3023 Z3024 Z3025), label
tab waste, m

recode waste (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable waste "Reduced household waste"
label values waste actions_lb
tab waste, m

tab Z3023 Z3024

recode waste (0 2 = 0) (1 3 = 1), gen(waste_bin)
label variable waste_bin "Reduced household waste (binary)"
label values waste_bin actions_bin_lb
tab waste_bin, m

drop Z3023 Z3024 Z3025


* Reduced energy use
tab1 Z3026 Z3027 Z3028, m

replace Z3026 = . if Z3026 < 0
replace Z3027 = . if Z3027 < 0
replace Z3028 = . if Z3028 < 0

egen energy = group(Z3026 Z3027 Z3028), label
tab energy, m

recode energy (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable energy "Reduced energy use"
label values energy actions_lb
tab energy, m

tab Z3026 Z3027

recode energy (0 2 = 0) (1 3 = 1), gen(energy_bin)
label variable energy_bin "Reduced energy use (binary)"
label values energy_bin actions_bin_lb
tab energy_bin, m

drop Z3026 Z3027 Z3028


* Changed what buy
tab1 Z3029 Z3030 Z3031, m

replace Z3029 = . if Z3029 < 0
replace Z3030 = . if Z3030 < 0
replace Z3031 = . if Z3031 < 0

egen buy = group(Z3029 Z3030 Z3031), label
tab buy, m

recode buy (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable buy "Changed what buy"
label values buy actions_lb
tab buy, m

tab Z3029 Z3030

recode buy (0 2 = 0) (1 3 = 1), gen(buy_bin)
label variable buy_bin "Changed what buy (binary)"
label values buy_bin actions_bin_lb
tab buy_bin, m

drop Z3029 Z3030 Z3031


* Reduced air travel
tab1 Z3032 Z3033 Z3034, m

replace Z3032 = . if Z3032 < 0
replace Z3033 = . if Z3033 < 0
replace Z3034 = . if Z3034 < 0

egen airTravel = group(Z3032 Z3033 Z3034), label
tab airTravel, m

recode airTravel (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable airTravel "Reduced air travel"
label values airTravel actions_lb
tab airTravel, m

tab Z3032 Z3033

recode airTravel (0 2 = 0) (1 3 = 1), gen(airTravel_bin)
label variable airTravel_bin "Reduced air travel (binary)"
label values airTravel_bin actions_bin_lb
tab airTravel_bin, m

drop Z3032 Z3033 Z3034


* Electric/hybrid car
tab1 Z3035 Z3036 Z3037, m

replace Z3035 = . if Z3035 < 0
replace Z3036 = . if Z3036 < 0
replace Z3037 = . if Z3037 < 0

egen elecCar = group(Z3035 Z3036 Z3037), label
tab elecCar, m

recode elecCar (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable elecCar "Electric/hybrid car"
label values elecCar actions_lb
tab elecCar, m

tab Z3035 Z3036

recode elecCar (0 2 = 0) (1 3 = 1), gen(elecCar_bin)
label variable elecCar_bin "Electric/hybrid car (binary)"
label values elecCar_bin actions_bin_lb
tab elecCar_bin, m

drop Z3035 Z3036 Z3037


* Bought local food
tab1 Z3038 Z3039 Z3040, m

replace Z3038 = . if Z3038 < 0
replace Z3039 = . if Z3039 < 0
replace Z3040 = . if Z3040 < 0

egen localFood = group(Z3038 Z3039 Z3040), label
tab localFood, m

recode localFood (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable localFood "Bought local food"
label values localFood actions_lb
tab localFood, m

tab Z3038 Z3039 

recode localFood (0 2 = 0) (1 3 = 1), gen(localFood_bin)
label variable localFood_bin "Bought local food (binary)"
label values localFood_bin actions_bin_lb
tab localFood_bin, m

drop Z3038 Z3039 Z3040


* Recycled more
tab1 Z3041 Z3042 Z3043, m

replace Z3041 = . if Z3041 < 0
replace Z3042 = . if Z3042 < 0
replace Z3043 = . if Z3043 < 0

egen recycle = group(Z3041 Z3042 Z3043), label
tab recycle, m

recode recycle (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable recycle "Recycled more"
label values recycle actions_lb
tab recycle, m

tab Z3041 Z3042

recode recycle (0 2 = 0) (1 3 = 1), gen(recycle_bin)
label variable recycle_bin "Recycled more (binary)"
label values recycle_bin actions_bin_lb
tab recycle_bin, m

drop Z3041 Z3042 Z3043


* Reduced plastic use
tab1 Z3044 Z3045 Z3046, m

replace Z3044 = . if Z3044 < 0
replace Z3045 = . if Z3045 < 0
replace Z3046 = . if Z3046 < 0

egen plastic = group(Z3044 Z3045 Z3046), label
tab plastic, m

recode plastic (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable plastic "Reduced plastic use"
label values plastic actions_lb
tab plastic, m

tab Z3044 Z3045

recode plastic (0 2 = 0) (1 3 = 1), gen(plastic_bin)
label variable plastic_bin "Reduced plastic use (binary)"
label values plastic_bin actions_bin_lb
tab plastic_bin, m

drop Z3044 Z3045 Z3046


* Chosen sustainably sourced items
tab1 Z3047 Z3048 Z3049, m

replace Z3047 = . if Z3047 < 0
replace Z3048 = . if Z3048 < 0
replace Z3049 = . if Z3049 < 0

egen sustainable = group(Z3047 Z3048 Z3049), label
tab sustainable, m

recode sustainable (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable sustainable "Chosen sustainably sourced items"
label values sustainable actions_lb
tab sustainable, m

tab Z3047 Z3048

recode sustainable (0 2 = 0) (1 3 = 1), gen(sustainable_bin)
label variable sustainable_bin "Chosen sustainably sourced items (binary)"
label values sustainable_bin actions_bin_lb
tab sustainable_bin, m

drop Z3047 Z3048 Z3049


* Improved home insulation
tab1 Z3050 Z3051 Z3052, m

replace Z3050 = . if Z3050 < 0
replace Z3051 = . if Z3051 < 0
replace Z3052 = . if Z3052 < 0

egen insulation = group(Z3050 Z3051 Z3052), label
tab insulation, m

recode insulation (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable insulation "Improved home insulation"
label values insulation actions_lb
tab insulation, m

tab Z3050 Z3051

recode insulation (0 2 = 0) (1 3 = 1), gen(insulation_bin)
label variable insulation_bin "Improved home insulation (binary)"
label values insulation_bin actions_bin_lb
tab insulation_bin, m

drop Z3050 Z3051 Z3052


* Installed solar panels
tab1 Z3053 Z3054 Z3055, m

replace Z3053 = . if Z3053 < 0
replace Z3054 = . if Z3054 < 0
replace Z3055 = . if Z3055 < 0

egen solar = group(Z3053 Z3054 Z3055), label
tab solar, m

recode solar (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable solar "Installed solar panels"
label values solar actions_lb
tab solar, m

tab Z3053 Z3054

recode solar (0 2 = 0) (1 3 = 1), gen(solar_bin)
label variable solar_bin "Installed solar panels (binary)"
label values solar_bin actions_bin_lb
tab solar_bin, m

drop Z3053 Z3054 Z3055


* Started growing vegetables
tab1 Z3056 Z3057 Z3058, m

replace Z3056 = . if Z3056 < 0
replace Z3057 = . if Z3057 < 0
replace Z3058 = . if Z3058 < 0

egen veg = group(Z3056 Z3057 Z3058), label
tab veg, m

recode veg (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable veg "Started growing vegetables"
label values veg actions_lb
tab veg, m

tab Z3056 Z3057

recode veg (0 2 = 0) (1 3 = 1), gen(veg_bin)
label variable veg_bin "Started growing vegetables (binary)"
label values veg_bin actions_bin_lb
tab veg_bin, m

drop Z3056 Z3057 Z3058


* Planted trees
tab1 Z3059 Z3060 Z3061, m

replace Z3059 = . if Z3059 < 0
replace Z3060 = . if Z3060 < 0
replace Z3061 = . if Z3061 < 0

egen trees = group(Z3059 Z3060 Z3061), label
tab trees, m

recode trees (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable trees "Planted trees"
label values trees actions_lb
tab trees, m

tab Z3059 Z3060

recode trees (0 2 = 0) (1 3 = 1), gen(trees_bin)
label variable trees_bin "Planted trees (binary)"
label values trees_bin actions_bin_lb
tab trees_bin, m

drop Z3059 Z3060 Z3061


* Avoided fossil fuel organisations
tab1 Z3062 Z3063 Z3064, m

replace Z3062 = . if Z3062 < 0
replace Z3063 = . if Z3063 < 0
replace Z3064 = . if Z3064 < 0

egen avoidFossil = group(Z3062 Z3063 Z3064), label
tab avoidFossil, m

recode avoidFossil (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable avoidFossil "Avoided fossil fuel organisations"
label values avoidFossil actions_lb
tab avoidFossil, m

tab Z3062 Z3063

recode avoidFossil (0 2 = 0) (1 3 = 1), gen(avoidFossil_bin)
label variable avoidFossil_bin "Avoided fossil fuel organisations (binary)"
label values avoidFossil_bin actions_bin_lb
tab avoidFossil_bin, m

drop Z3062 Z3063 Z3064


* Planned fewer children
tab1 Z3065 Z3066 Z3067, m

replace Z3065 = . if Z3065 < 0
replace Z3066 = . if Z3066 < 0
replace Z3067 = . if Z3067 < 0

egen children = group(Z3065 Z3066 Z3067), label
tab children, m

recode children (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable children "Planned fewer children"
label values children actions_lb
tab children, m

tab Z3065 Z3066

recode children (0 2 = 0) (1 3 = 1), gen(children_bin)
label variable children_bin "Planned fewer children (binary)"
label values children_bin actions_bin_lb
tab children_bin, m

drop Z3065 Z3066 Z3067


* Taken other climate action
tab1 Z3068 Z3069 Z3070, m

replace Z3068 = . if Z3068 < 0
replace Z3069 = . if Z3069 < 0
replace Z3070 = . if Z3070 < 0

egen otherAction = group(Z3068 Z3069 Z3070), label
tab otherAction, m

recode otherAction (1 =.) (2=0) (3=2) (4=1) (5=3) 
label variable otherAction "Taken other climate action"
label values otherAction actions_lb
tab otherAction, m

tab Z3068 Z3069

recode otherAction (0 2 = 0) (1 3 = 1), gen(otherAction_bin)
label variable otherAction_bin "Taken other climate action (binary)"
label values otherAction_bin actions_bin_lb
tab otherAction_bin, m

drop Z3068 Z3069 Z3070


* Reduced meat/dairy consumption
tab1 Z3071 Z3072 Z3073, m

replace Z3071 = . if Z3071 < 0
replace Z3072 = . if Z3072 < 0
replace Z3073 = . if Z3073 < 0

egen meatDairy = group(Z3071 Z3072 Z3073), label
tab meatDairy, m

recode meatDairy (1 4 6 =.) (2=0) (3=2) (5=1) (7=3)
label variable meatDairy "Reduced meat/dairy consumption"
label values meatDairy actions_lb
tab meatDairy, m

tab Z3071 Z3072

* Check answers if vegan/vegatarian - This is complicated, as some vegetarians/vegans answered this question, while others did not (vegetarians should also not be a separate category as they can still reduce dairy consumption, but hey ho). Will exclude answers from those who said 'always vegan' (as should not consume any meat or dairy products), but keep answers from those who said 'always vegetarian' 
tab1 Z3074 Z3075, m

tab meatDairy if Z3074 == 1 | Z3075 == 1
tab1 Z3074 Z3075 if meatDairy != .

replace meatDairy = . if Z3075 == 1
tab meatDairy, m
drop Z3074 Z3075

recode meatDairy (0 2 = 0) (1 3 = 1), gen(meatDairy_bin)
label variable meatDairy_bin "Reduced meat/dairy consumption (binary)"
label values meatDairy_bin actions_bin_lb
tab meatDairy_bin, m

drop Z3071 Z3072 Z3073


** Calculate total number of actions taken for climate reasons (will exclude 'other' though)
egen total_actions = rowtotal(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin children_bin meatDairy_bin), missing

tab total_actions, m
sum total_actions

* Code as missing if any questions missing
egen total_miss = rowmiss(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin children_bin meatDairy_bin)
tab total_miss, m

replace total_actions = . if total_miss > 0
tab total_actions, m
sum total_actions

drop total_miss


** Also calculate total number of actions excluding one's which may be prohibitively costly (i.e., excluding air travel, electric car, home insulation, solar panels and growing vegetables)
egen total_actions_red = rowtotal(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin children_bin meatDairy_bin), missing

tab total_actions_red, m
sum total_actions_red

* Code as missing if any questions missing
egen total_miss_red = rowmiss(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin children_bin meatDairy_bin)
tab total_miss_red, m

replace total_actions_red = . if total_miss_red > 0
tab total_actions_red, m
sum total_actions_red

drop total_miss_red


** Also calculate number of actions excluding 'had fewer/no children' to match parent data (as question not relevant for parents)
egen total_actions_excKids = rowtotal(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin meatDairy_bin), missing

tab total_actions_excKids, m
sum total_actions_excKids

* Code as missing if any questions missing
egen total_miss_excKids = rowmiss(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin meatDairy_bin)
tab total_miss_excKids, m

replace total_actions_excKids = . if total_miss_excKids > 0
tab total_actions_excKids, m
sum total_actions_excKids

drop total_miss_excKids


** And for reduced number of actions
egen total_actions_red_excKids = rowtotal(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin meatDairy_bin), missing

tab total_actions_red_excKids, m
sum total_actions_red_excKids

* Code as missing if any questions missing
egen total_miss_red_excKids = rowmiss(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin meatDairy_bin)
tab total_miss_red_excKids, m

replace total_actions_red_excKids = . if total_miss_red_excKids > 0
tab total_actions_red_excKids, m
sum total_actions_red_excKids

drop total_miss_red_excKids



*** Partners's climate beliefs and behaviours

* Recode all withdrawals of consent as missing
foreach var of varlist FPD3000-FPD3075 {
	replace `var' = . if `var' == .c
}

* Believes that the climate is changing - ordered categorical variable 
tab FPD3000, m

replace FPD3000 = . if FPD3000 < 0
rename FPD3000 climateChanging_ptnr
tab climateChanging_ptnr, m


* Degree to which is concerned about the impact of climate change (only answered if believe climate is changing) - ordered categorical variable
tab FPD3001, m

replace FPD3001 = . if FPD3001 < 0
rename FPD3001 climateConcern_ptnr
tab climateConcern_ptnr, m


* Believes that humans are to blame for climate change (only answered if believe climate is changing) - ordered categorical variable
tab FPD3002, m

replace FPD3002 = . if FPD3002 < 0
rename FPD3002 climateHumans_ptnr
tab climateHumans_ptnr, m


* Personal actions will make difference to long-term climate changes (only answered if believe climate is changing) - unordered categorical variable
tab FPD3003, m

replace FPD3003 = . if FPD3003 < 0
rename FPD3003 climateAction_ptnr
tab climateAction_ptnr, m


** Questions about which things will change due to climate change (wont include here for intergenerational comparisons)


** Now go through the 'actions taken due to climate change' questions and recode as appropriate into 'not done this' vs 'done for non-climate reasons' vs 'done for climate reasons' vs 'done for both climate and non-climate reasons' (while excluding impossible combinations of values - e.g., 'not done and done')

* Travelling locally
tab1 FPD3020 FPD3021 FPD3022, m

replace FPD3020 = . if FPD3020 < 0
replace FPD3021 = . if FPD3021 < 0
replace FPD3022 = . if FPD3022 < 0

egen travel_ptnr = group(FPD3020 FPD3021 FPD3022), label
tab travel_ptnr, m

recode travel_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable travel_ptnr "Changed the way travel locally"
label values travel_ptnr actions_lb
tab travel_ptnr, m

tab FPD3020 FPD3021

recode travel_ptnr (0 2 = 0) (1 3 = 1), gen(travel_bin_ptnr)
label variable travel_bin_ptnr "Changed the way travel locally (binary)"
label values travel_bin_ptnr actions_bin_lb
tab travel_bin_ptnr, m

drop FPD3020 FPD3021 FPD3022


* Reduced household waste
tab1 FPD3023 FPD3024 FPD3025, m

replace FPD3023 = . if FPD3023 < 0
replace FPD3024 = . if FPD3024 < 0
replace FPD3025 = . if FPD3025 < 0

egen waste_ptnr = group(FPD3023 FPD3024 FPD3025), label
tab waste_ptnr, m

recode waste_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable waste_ptnr "Reduced household waste"
label values waste_ptnr actions_lb
tab waste_ptnr, m

tab FPD3023 FPD3024

recode waste_ptnr (0 2 = 0) (1 3 = 1), gen(waste_bin_ptnr)
label variable waste_bin_ptnr "Reduced household waste (binary)"
label values waste_bin_ptnr actions_bin_lb
tab waste_bin_ptnr, m

drop FPD3023 FPD3024 FPD3025


* Reduced energy use
tab1 FPD3026 FPD3027 FPD3028, m

replace FPD3026 = . if FPD3026 < 0
replace FPD3027 = . if FPD3027 < 0
replace FPD3028 = . if FPD3028 < 0

egen energy_ptnr = group(FPD3026 FPD3027 FPD3028), label
tab energy_ptnr, m

recode energy_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable energy_ptnr "Reduced energy use"
label values energy_ptnr actions_lb
tab energy_ptnr, m

tab FPD3026 FPD3027

recode energy_ptnr (0 2 = 0) (1 3 = 1), gen(energy_bin_ptnr)
label variable energy_bin_ptnr "Reduced energy use (binary)"
label values energy_bin_ptnr actions_bin_lb
tab energy_bin_ptnr, m

drop FPD3026 FPD3027 FPD3028


* Changed what buy
tab1 FPD3029 FPD3030 FPD3031, m

replace FPD3029 = . if FPD3029 < 0
replace FPD3030 = . if FPD3030 < 0
replace FPD3031 = . if FPD3031 < 0

egen buy_ptnr = group(FPD3029 FPD3030 FPD3031), label
tab buy_ptnr, m

recode buy_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable buy_ptnr "Changed what buy"
label values buy_ptnr actions_lb
tab buy_ptnr, m

tab FPD3029 FPD3030

recode buy_ptnr (0 2 = 0) (1 3 = 1), gen(buy_bin_ptnr)
label variable buy_bin_ptnr "Changed what buy (binary)"
label values buy_bin_ptnr actions_bin_lb
tab buy_bin_ptnr, m

drop FPD3029 FPD3030 FPD3031


* Reduced air travel
tab1 FPD3032 FPD3033 FPD3034, m

replace FPD3032 = . if FPD3032 < 0
replace FPD3033 = . if FPD3033 < 0
replace FPD3034 = . if FPD3034 < 0

egen airTravel_ptnr = group(FPD3032 FPD3033 FPD3034), label
tab airTravel_ptnr, m

recode airTravel_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable airTravel_ptnr "Reduced air travel"
label values airTravel_ptnr actions_lb
tab airTravel_ptnr, m

tab FPD3032 FPD3033

recode airTravel_ptnr (0 2 = 0) (1 3 = 1), gen(airTravel_bin_ptnr)
label variable airTravel_bin_ptnr "Reduced air travel (binary)"
label values airTravel_bin_ptnr actions_bin_lb
tab airTravel_bin_ptnr, m

drop FPD3032 FPD3033 FPD3034


* Electric/hybrid car
tab1 FPD3035 FPD3036 FPD3037, m

replace FPD3035 = . if FPD3035 < 0
replace FPD3036 = . if FPD3036 < 0
replace FPD3037 = . if FPD3037 < 0

egen elecCar_ptnr = group(FPD3035 FPD3036 FPD3037), label
tab elecCar_ptnr, m

recode elecCar_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable elecCar_ptnr "Electric/hybrid car"
label values elecCar_ptnr actions_lb
tab elecCar_ptnr, m

tab FPD3035 FPD3036

recode elecCar_ptnr (0 2 = 0) (1 3 = 1), gen(elecCar_bin_ptnr)
label variable elecCar_bin_ptnr "Electric/hybrid car (binary)"
label values elecCar_bin_ptnr actions_bin_lb
tab elecCar_bin_ptnr, m

drop FPD3035 FPD3036 FPD3037


* Bought local food
tab1 FPD3038 FPD3039 FPD3040, m

replace FPD3038 = . if FPD3038 < 0
replace FPD3039 = . if FPD3039 < 0
replace FPD3040 = . if FPD3040 < 0

egen localFood_ptnr = group(FPD3038 FPD3039 FPD3040), label
tab localFood_ptnr, m

recode localFood_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable localFood_ptnr "Bought local food"
label values localFood_ptnr actions_lb
tab localFood_ptnr, m

tab FPD3038 FPD3039 

recode localFood_ptnr (0 2 = 0) (1 3 = 1), gen(localFood_bin_ptnr)
label variable localFood_bin_ptnr "Bought local food (binary)"
label values localFood_bin_ptnr actions_bin_lb
tab localFood_bin_ptnr, m

drop FPD3038 FPD3039 FPD3040


* Recycled more
tab1 FPD3041 FPD3042 FPD3043, m

replace FPD3041 = . if FPD3041 < 0
replace FPD3042 = . if FPD3042 < 0
replace FPD3043 = . if FPD3043 < 0

egen recycle_ptnr = group(FPD3041 FPD3042 FPD3043), label
tab recycle_ptnr, m

recode recycle_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable recycle_ptnr "Recycled more"
label values recycle_ptnr actions_lb
tab recycle_ptnr, m

tab FPD3041 FPD3042

recode recycle_ptnr (0 2 = 0) (1 3 = 1), gen(recycle_bin_ptnr)
label variable recycle_bin_ptnr "Recycled more (binary)"
label values recycle_bin_ptnr actions_bin_lb
tab recycle_bin_ptnr, m

drop FPD3041 FPD3042 FPD3043


* Reduced plastic use
tab1 FPD3044 FPD3045 FPD3046, m

replace FPD3044 = . if FPD3044 < 0
replace FPD3045 = . if FPD3045 < 0
replace FPD3046 = . if FPD3046 < 0

egen plastic_ptnr = group(FPD3044 FPD3045 FPD3046), label
tab plastic_ptnr, m

recode plastic_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable plastic_ptnr "Reduced plastic use"
label values plastic_ptnr actions_lb
tab plastic_ptnr, m

tab FPD3044 FPD3045

recode plastic_ptnr (0 2 = 0) (1 3 = 1), gen(plastic_bin_ptnr)
label variable plastic_bin_ptnr "Reduced plastic use (binary)"
label values plastic_bin_ptnr actions_bin_lb
tab plastic_bin_ptnr, m

drop FPD3044 FPD3045 FPD3046


* Chosen sustainably sourced items
tab1 FPD3047 FPD3048 FPD3049, m

replace FPD3047 = . if FPD3047 < 0
replace FPD3048 = . if FPD3048 < 0
replace FPD3049 = . if FPD3049 < 0

egen sustainable_ptnr = group(FPD3047 FPD3048 FPD3049), label
tab sustainable_ptnr, m

recode sustainable_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable sustainable_ptnr "Chosen sustainably sourced items"
label values sustainable_ptnr actions_lb
tab sustainable_ptnr, m

tab FPD3047 FPD3048

recode sustainable_ptnr (0 2 = 0) (1 3 = 1), gen(sustainable_bin_ptnr)
label variable sustainable_bin_ptnr "Chosen sustainably sourced items (binary)"
label values sustainable_bin_ptnr actions_bin_lb
tab sustainable_bin_ptnr, m

drop FPD3047 FPD3048 FPD3049


* Improved home insulation
tab1 FPD3050 FPD3051 FPD3052, m

replace FPD3050 = . if FPD3050 < 0
replace FPD3051 = . if FPD3051 < 0
replace FPD3052 = . if FPD3052 < 0

egen insulation_ptnr = group(FPD3050 FPD3051 FPD3052), label
tab insulation_ptnr, m

recode insulation_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable insulation_ptnr "Improved home insulation"
label values insulation_ptnr actions_lb
tab insulation_ptnr, m

tab FPD3050 FPD3051

recode insulation_ptnr (0 2 = 0) (1 3 = 1), gen(insulation_bin_ptnr)
label variable insulation_bin_ptnr "Improved home insulation (binary)"
label values insulation_bin_ptnr actions_bin_lb
tab insulation_bin_ptnr, m

drop FPD3050 FPD3051 FPD3052


* Installed solar panels
tab1 FPD3053 FPD3054 FPD3055, m

replace FPD3053 = . if FPD3053 < 0
replace FPD3054 = . if FPD3054 < 0
replace FPD3055 = . if FPD3055 < 0

egen solar_ptnr = group(FPD3053 FPD3054 FPD3055), label
tab solar_ptnr, m

recode solar_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable solar_ptnr "Installed solar panels"
label values solar_ptnr actions_lb
tab solar_ptnr, m

tab FPD3053 FPD3054

recode solar_ptnr (0 2 = 0) (1 3 = 1), gen(solar_bin_ptnr)
label variable solar_bin_ptnr "Installed solar panels (binary)"
label values solar_bin_ptnr actions_bin_lb
tab solar_bin_ptnr, m

drop FPD3053 FPD3054 FPD3055


* Started growing vegetables
tab1 FPD3056 FPD3057 FPD3058, m

replace FPD3056 = . if FPD3056 < 0
replace FPD3057 = . if FPD3057 < 0
replace FPD3058 = . if FPD3058 < 0

egen veg_ptnr = group(FPD3056 FPD3057 FPD3058), label
tab veg_ptnr, m

recode veg_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable veg_ptnr "Started growing vegetables"
label values veg_ptnr actions_lb
tab veg_ptnr, m

tab FPD3056 FPD3057

recode veg_ptnr (0 2 = 0) (1 3 = 1), gen(veg_bin_ptnr)
label variable veg_bin_ptnr "Started growing vegetables (binary)"
label values veg_bin_ptnr actions_bin_lb
tab veg_bin_ptnr, m

drop FPD3056 FPD3057 FPD3058


* Planted trees
tab1 FPD3059 FPD3060 FPD3061, m

replace FPD3059 = . if FPD3059 < 0
replace FPD3060 = . if FPD3060 < 0
replace FPD3061 = . if FPD3061 < 0

egen trees_ptnr = group(FPD3059 FPD3060 FPD3061), label
tab trees_ptnr, m

recode trees_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable trees_ptnr "Planted trees"
label values trees_ptnr actions_lb
tab trees_ptnr, m

tab FPD3059 FPD3060

recode trees_ptnr (0 2 = 0) (1 3 = 1), gen(trees_bin_ptnr)
label variable trees_bin_ptnr "Planted trees (binary)"
label values trees_bin_ptnr actions_bin_lb
tab trees_bin_ptnr, m

drop FPD3059 FPD3060 FPD3061


* Avoided fossil fuel organisations
tab1 FPD3062 FPD3063 FPD3064, m

replace FPD3062 = . if FPD3062 < 0
replace FPD3063 = . if FPD3063 < 0
replace FPD3064 = . if FPD3064 < 0

egen avoidFossil_ptnr = group(FPD3062 FPD3063 FPD3064), label
tab avoidFossil_ptnr, m

recode avoidFossil_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable avoidFossil_ptnr "Avoided fossil fuel organisations"
label values avoidFossil_ptnr actions_lb
tab avoidFossil_ptnr, m

tab FPD3062 FPD3063

recode avoidFossil_ptnr (0 2 = 0) (1 3 = 1), gen(avoidFossil_bin_ptnr)
label variable avoidFossil_bin_ptnr "Avoided fossil fuel organisations (binary)"
label values avoidFossil_bin_ptnr actions_bin_lb
tab avoidFossil_bin_ptnr, m

drop FPD3062 FPD3063 FPD3064


* Planned fewer children
tab1 FPD3065 FPD3066 FPD3067, m

replace FPD3065 = . if FPD3065 < 0
replace FPD3066 = . if FPD3066 < 0
replace FPD3067 = . if FPD3067 < 0

egen children_ptnr = group(FPD3065 FPD3066 FPD3067), label
tab children_ptnr, m

recode children_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable children_ptnr "Planned fewer children"
label values children_ptnr actions_lb
tab children_ptnr, m

tab FPD3065 FPD3066

recode children_ptnr (0 2 = 0) (1 3 = 1), gen(children_bin_ptnr)
label variable children_bin_ptnr "Planned fewer children (binary)"
label values children_bin_ptnr actions_bin_lb
tab children_bin_ptnr, m

drop FPD3065 FPD3066 FPD3067


* Taken other climate action
tab1 FPD3068 FPD3069 FPD3070, m

replace FPD3068 = . if FPD3068 < 0
replace FPD3069 = . if FPD3069 < 0
replace FPD3070 = . if FPD3070 < 0

egen otherAction_ptnr = group(FPD3068 FPD3069 FPD3070), label
tab otherAction_ptnr, m

recode otherAction_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable otherAction_ptnr "Taken other climate action"
label values otherAction_ptnr actions_lb
tab otherAction_ptnr, m

tab FPD3068 FPD3069

recode otherAction_ptnr (0 2 = 0) (1 3 = 1), gen(otherAction_bin_ptnr)
label variable otherAction_bin_ptnr "Taken other climate action (binary)"
label values otherAction_bin_ptnr actions_bin_lb
tab otherAction_bin_ptnr, m

drop FPD3068 FPD3069 FPD3070


* Reduced meat/dairy consumption
tab1 FPD3071 FPD3072 FPD3073, m

replace FPD3071 = . if FPD3071 < 0
replace FPD3072 = . if FPD3072 < 0
replace FPD3073 = . if FPD3073 < 0

egen meatDairy_ptnr = group(FPD3071 FPD3072 FPD3073), label
tab meatDairy_ptnr, m

recode meatDairy_ptnr (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable meatDairy_ptnr "Reduced meat/dairy consumption"
label values meatDairy_ptnr actions_lb
tab meatDairy_ptnr, m

tab FPD3071 FPD3072

* Check answers if vegan/vegatarian - This is complicated, as some vegetarians/vegans answered this question, while others did not (vegetarians should also not be a separate category as they can still reduce dairy consumption, but hey ho). Will exclude answers from those who said 'always vegan' (as should not consume any meat or dairy products), but keep answers from those who said 'always vegetarian' 
tab1 FPD3074 FPD3075, m

tab meatDairy_ptnr if FPD3074 == 1 | FPD3075 == 1
tab1 FPD3074 FPD3075 if meatDairy_ptnr != .

replace meatDairy_ptnr = . if FPD3075 == 1
tab meatDairy_ptnr, m
drop FPD3074 FPD3075

recode meatDairy_ptnr (0 2 = 0) (1 3 = 1), gen(meatDairy_bin_ptnr)
label variable meatDairy_bin_ptnr "Reduced meat/dairy consumption (binary)"
label values meatDairy_bin_ptnr actions_bin_lb
tab meatDairy_bin_ptnr, m

drop FPD3071 FPD3072 FPD3073



** Calculate number of actions excluding 'had fewer/no children' (as question not relevant for parents)
egen total_actions_excKids_ptnr = rowtotal(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr airTravel_bin_ptnr elecCar_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr insulation_bin_ptnr solar_bin_ptnr veg_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr), missing

tab total_actions_excKids_ptnr, m
sum total_actions_excKids_ptnr

* Code as missing if any questions missing
egen total_miss_excKids_ptnr = rowmiss(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr airTravel_bin_ptnr elecCar_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr insulation_bin_ptnr solar_bin_ptnr veg_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr)
tab total_miss_excKids_ptnr, m

replace total_actions_excKids_ptnr = . if total_miss_excKids_ptnr > 0
tab total_actions_excKids_ptnr, m
sum total_actions_excKids_ptnr

drop total_miss_excKids_ptnr


** And for reduced number of actions
egen total_actions_red_excKids_ptnr = rowtotal(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr), missing

tab total_actions_red_excKids_ptnr, m
sum total_actions_red_excKids_ptnr

* Code as missing if any questions missing
egen total_miss_red_excKids_ptnr = rowmiss(travel_bin_ptnr waste_bin_ptnr energy_bin_ptnr buy_bin_ptnr localFood_bin_ptnr recycle_bin_ptnr plastic_bin_ptnr sustainable_bin_ptnr trees_bin_ptnr avoidFossil_bin_ptnr meatDairy_bin_ptnr)
tab total_miss_red_excKids_ptnr, m

replace total_actions_red_excKids_ptnr = . if total_miss_red_excKids_ptnr > 0
tab total_actions_red_excKids_ptnr, m
sum total_actions_red_excKids_ptnr

drop total_miss_red_excKids_ptnr


** And drop all of the individual actions (as not needed for comparisons between generations)
drop travel_ptnr-meatDairy_bin_ptnr


*** Re-arrange the variables so the partner variables are at the end of the dataset
order aln-otherAffected travel-total_actions_red_excKids climateChanging_ptnr-climateAction_ptnr total_actions_excKids_ptnr total_actions_red_excKids_ptnr


** Loop through labels and remove if negative/unnecessary
label dir

local labels r(names)
display `labels'

local labels "meatDairy_ptnr otherAction_ptnr children_ptnr avoidFossil_ptnr trees_ptnr veg_ptnr solar_ptnr insulation_ptnr sustainable_ptnr plastic_ptnr recycle_ptnr localFood_ptnr elecCar_ptnr airTravel_ptnr buy_ptnr energy_ptnr waste_ptnr travel_ptnr meatDairy otherAction children avoidFossil trees veg solar insulation sustainable plastic recycle localFood elecCar airTravel buy energy waste actions_bin_lb travel imd_lb ethnic_lb FPD3000 FPD3001 FPD3002 FPD3003 FPD3010 FPD3011 FPD3012 FPD3013 FPD3014 FPD3015 FPD3016 FPD3017 FPD3020 FPD3021 FPD3022 FPD3023 FPD3024 FPD3025 FPD3026 FPD3027 FPD3028 FPD3029 FPD3030 FPD3031 FPD3032 FPD3033 FPD3034 FPD3035 FPD3036 FPD3037 FPD3038 FPD3039 FPD3040 FPD3041 FPD3042 FPD3043 FPD3044 FPD3045 FPD3046 FPD3047 FPD3048 FPD3049 FPD3050 FPD3051 FPD3052 FPD3053 FPD3054 FPD3055 FPD3056 FPD3057 FPD3058 FPD3059 FPD3060 FPD3061 FPD3062 FPD3063 FPD3064 FPD3065 FPD3066 FPD3067 FPD3068 FPD3069 FPD3070 FPD3071 FPD3072 FPD3073 FPD3074 FPD3075 FPD6500 YPC2492 YPE6020 YPF7970 YPJ3000 YPJ3001 YPJ3002 YPJ3003 YPJ3010 YPJ3011 YPJ3012 YPJ3013 YPJ3014 YPJ3015 YPJ3016 YPJ3017 YPJ3020 YPJ3021 YPJ3022 YPJ3023 YPJ3024 YPJ3025 YPJ3026 YPJ3027 YPJ3028 YPJ3029 YPJ3030 YPJ3031 YPJ3032 YPJ3033 YPJ3034 YPJ3035 YPJ3036 YPJ3037 YPJ3038 YPJ3039 YPJ3040 YPJ3041 YPJ3042 YPJ3043 YPJ3044 YPJ3045 YPJ3046 YPJ3047 YPJ3048 YPJ3049 YPJ3050 YPJ3051 YPJ3052 YPJ3053 YPJ3054 YPJ3055 YPJ3056 YPJ3057 YPJ3058 YPJ3059 YPJ3060 YPJ3061 YPJ3062 YPJ3063 YPJ3064 YPJ3065 YPJ3066 YPJ3067 YPJ3068 YPJ3069 YPJ3070 YPJ3071 YPJ3072 YPJ3073 YPJ3074 YPJ3075 YPJ7500 Z3000 Z3001 Z3002 Z3003 Z3010 Z3011 Z3012 Z3013 Z3014 Z3015 Z3016 Z3017 Z3020 Z3021 Z3022 Z3023 Z3024 Z3025 Z3026 Z3027 Z3028 Z3029 Z3030 Z3031 Z3032 Z3033 Z3034 Z3035 Z3036 Z3037 Z3038 Z3039 Z3040 Z3041 Z3042 Z3043 Z3044 Z3045 Z3046 Z3047 Z3048 Z3049 Z3050 Z3051 Z3052 Z3053 Z3054 Z3055 Z3056 Z3057 Z3058 Z3059 Z3060 Z3061 Z3062 Z3063 Z3064 Z3065 Z3066 Z3067 Z3068 Z3069 Z3070 Z3071 Z3072 Z3073 Z3074 Z3075 Z6500 bestgest c645a c666a c755 c765 c800 c801 c804 h470 in_core in_phase2 in_phase3 in_phase4 jan2014imd2010q5_M jan2021imd2015q5_YP kz011b kz021 kz030 mum_and_preg_enrolled mz005l mz005m mz010a mz013 mz014 mz028b partner_age partner_changed partner_changed_when partner_data partner_enrolled partner_in_alspac partner_in_core preg_enrol_status preg_in_alsp preg_in_core pz_mult pz_multid second_partner_age actions_lb"

* Have to create labels for all objects first, before removing them (else those without the number beforehand get added one)
foreach label of local labels {
	display "`label'"
	label define `label' -9999 "test" -11 "test" -10 "test" -9 "test" -8 "test" -5 "test" -2 "test" -1 "test", modify
	label define `label' -9999 "" -11 "" -10 "" -9 "" -8 "" -5 "" -2 "" -1 "", modify
}

label list


** Save processed file here (and also for synthesising)
save "B4123_motherData_processed.dta", replace




*****************************************************************************
****** Now for the mother's dataset

use "B4123_climateDataNote_dataset.dta", clear

* Add value labels
numlabel, add

** Remove children not alive at 1 year of age or if withdrew consent
tab1 kz011b partner_age, m

drop if kz011b == 2 | kz011b == .a
drop if partner_age == .c

* Also drop one pregnancy if mother linked to one or more pregnancy (to avoid duplicated data)
tab mz005l, m

drop if mz005l == 1

* Check for any additional duplicated partners
tab pz_mult, m

* Also drop data from second-born twin (again, avoiding duplicated data)
tab qlet, m

drop if qlet == "B"

* Drop if mother not enrolled in ALSPAC (but child is)
tab mum_and_preg_enrolled, m

drop if mum_and_preg_enrolled == 2

* Drop if no data from partner or partner not enrolled
tab partner_in_alspac, m

drop if partner_in_alspac == .

* Also drop is partner identity known to have changed over course of study
tab partner_changed, m

keep if partner_changed == 1


** Keep just relevant variables for the partner's dataset
keep aln partner_age c801 c666a c765 h470 jan2014imd2010q5_M FPD6500 ///
	FPD3000-FPD3075
	
order aln partner_age c801 c666a c765 h470 jan2014imd2010q5_M FPD6500 ///
	FPD3000-FPD3075


*** Go through each variable and clean ready for analysis

* Partner's age at birth
tab partner_age, m

replace partner_age = . if partner_age < 0
replace partner_age = 15 if partner_age < 15
rename partner_age ageAtBirth
tab ageAtBirth, m

* Partner age (at completion of climate questions)
tab FPD6500, m

replace FPD6500 = . if FPD6500 < 0
rename FPD6500 age
tab age, m
sum age

* Partner ethnicity
tab c801, m

replace c801 = . if c801 < 0
recode c801 (1 = 1) (2/9 = 2)
label define ethnic_lb 1 "White" 2 "Other than white"
numlabel ethnic_lb, add
label values c801 ethnic_lb
rename c801 ethnicity
tab ethnicity, m

* Partner education
tab c666a, m

replace c666a = . if c666a < 0
rename c666a edu
tab edu, m

* Partner occupational social class
tab c765, m

replace c765 = . if c765 < 0 | c765 == 65
replace c765 = 5 if c765 == 6
label define c765 5 "IV/V" 6 "" 65 "", modify
rename c765 occSocClass
tab occSocClass, m

* Weekly household income
tab h470, m

replace h470 = . if h470 < 0
label define h470 1 "<£100" 2 "£100 - £199" 3 "£200 - £299" 4 "£300 - £399" 5 "£400+", modify
rename h470 income
tab income, m

* IMD quintile in 2014
tab jan2014imd2010q5_M, m

replace jan2014imd2010q5_M = . if jan2014imd2010q5_M < 0
label define imd_lb 1 "Least deprived" 2 "2" 3 "3" 4 "4" 5 "Most deprived"
numlabel imd_lb, add
label values jan2014imd2010q5_M imd_lb
rename jan2014imd2010q5_M imd
tab imd, m


** Partner climate beliefs and behaviours

* Believes that the climate is changing - ordered categorical variable 
tab FPD3000, m

replace FPD3000 = . if FPD3000 < 0
rename FPD3000 climateChanging
tab climateChanging, m


* Degree to which YP is concerned about the impact of climate change (only answered if believe climate is changing) - ordered categorical variable
tab FPD3001, m

replace FPD3001 = . if FPD3001 < 0
rename FPD3001 climateConcern
tab climateConcern, m


* Believes that humans are to blame for climate change (only answered if believe climate is changing) - ordered categorical variable
tab FPD3002, m

replace FPD3002 = . if FPD3002 < 0
rename FPD3002 climateHumans
tab climateHumans, m


* Personal actions will make difference to long-term climate changes (only answered if believe climate is changing) - unordered categorical variable
tab FPD3003, m

replace FPD3003 = . if FPD3003 < 0
rename FPD3003 climateAction
tab climateAction, m


** Questions about which things will change due to climate change
describe FPD3010-FPD3017

* Weather will be affected by climate change
tab FPD3010, m

replace FPD3010 = . if FPD3010 < 0
rename FPD3010 weatherAffected
tab weatherAffected, m

* Work will be affected by climate change
tab FPD3011, m

replace FPD3011 = . if FPD3011 < 0
rename FPD3011 workAffected
tab workAffected, m

* Economy will be affected by climate change
tab FPD3012, m

replace FPD3012 = . if FPD3012 < 0
rename FPD3012 economyAffected
tab economyAffected, m

* Neighbourhood will be affected by climate change
tab FPD3013, m

replace FPD3013 = . if FPD3013 < 0
rename FPD3013 neighbourhoodAffected
tab neighbourhoodAffected, m

* Health will be affected by climate change
tab FPD3014, m

replace FPD3014 = . if FPD3014 < 0
rename FPD3014 healthAffected
tab healthAffected, m

* Future generations will be affected by climate change
tab FPD3015, m

replace FPD3015 = . if FPD3015 < 0
rename FPD3015 futureGensAffected
tab futureGensAffected, m

* None of the above will be affected by climate change
tab FPD3016, m

replace FPD3016 = . if FPD3016 < 0
rename FPD3016 nothingAffected
tab nothingAffected, m

* Make sure that no-one who answered 'nothing' gave another response
count if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

list aln weatherAffected-nothingAffected if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

replace nothingAffected = 0 if nothingAffected == 1 & (weatherAffected == 1 | workAffected == 1 | economyAffected == 1 | neighbourhoodAffected == 1 | healthAffected == 1 | futureGensAffected == 1)

tab nothingAffected, m

* Something else will be affected by climate change
tab FPD3017, m

replace FPD3017 = . if FPD3017 < 0
rename FPD3017 otherAffected
tab otherAffected, m


** Now go through the 'actions taken due to climate change' questions and recode as appropriate into 'not done this' vs 'done for non-climate reasons' vs 'done for climate reasons' vs 'done for both climate and non-climate reasons' (while excluding impossible combinations of values - e.g., 'not done and done')

* Travelling locally
tab1 FPD3020 FPD3021 FPD3022, m

replace FPD3020 = . if FPD3020 < 0
replace FPD3021 = . if FPD3021 < 0
replace FPD3022 = . if FPD3022 < 0

egen travel = group(FPD3020 FPD3021 FPD3022), label
tab travel, m

recode travel (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable travel "Changed the way travel locally"
label define actions_lb 0 "No" 1 "Yes, for climate" 2 "Yes, for other" 3 "Yes, for climate and other"
numlabel actions_lb, add
label values travel actions_lb
tab travel, m

tab FPD3020 FPD3021

recode travel (0 2 = 0) (1 3 = 1), gen(travel_bin)
label variable travel_bin "Changed the way travel locally (binary)"
label define actions_bin_lb 0 "No" 1 "Yes"
numlabel actions_bin_lb, add
label values travel_bin actions_bin_lb
tab travel_bin, m

drop FPD3020 FPD3021 FPD3022


* Reduced household waste
tab1 FPD3023 FPD3024 FPD3025, m

replace FPD3023 = . if FPD3023 < 0
replace FPD3024 = . if FPD3024 < 0
replace FPD3025 = . if FPD3025 < 0

egen waste = group(FPD3023 FPD3024 FPD3025), label
tab waste, m

recode waste (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable waste "Reduced household waste"
label values waste actions_lb
tab waste, m

tab FPD3023 FPD3024

recode waste (0 2 = 0) (1 3 = 1), gen(waste_bin)
label variable waste_bin "Reduced household waste (binary)"
label values waste_bin actions_bin_lb
tab waste_bin, m

drop FPD3023 FPD3024 FPD3025


* Reduced energy use
tab1 FPD3026 FPD3027 FPD3028, m

replace FPD3026 = . if FPD3026 < 0
replace FPD3027 = . if FPD3027 < 0
replace FPD3028 = . if FPD3028 < 0

egen energy = group(FPD3026 FPD3027 FPD3028), label
tab energy, m

recode energy (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable energy "Reduced energy use"
label values energy actions_lb
tab energy, m

tab FPD3026 FPD3027

recode energy (0 2 = 0) (1 3 = 1), gen(energy_bin)
label variable energy_bin "Reduced energy use (binary)"
label values energy_bin actions_bin_lb
tab energy_bin, m

drop FPD3026 FPD3027 FPD3028


* Changed what buy
tab1 FPD3029 FPD3030 FPD3031, m

replace FPD3029 = . if FPD3029 < 0
replace FPD3030 = . if FPD3030 < 0
replace FPD3031 = . if FPD3031 < 0

egen buy = group(FPD3029 FPD3030 FPD3031), label
tab buy, m

recode buy (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable buy "Changed what buy"
label values buy actions_lb
tab buy, m

tab FPD3029 FPD3030

recode buy (0 2 = 0) (1 3 = 1), gen(buy_bin)
label variable buy_bin "Changed what buy (binary)"
label values buy_bin actions_bin_lb
tab buy_bin, m

drop FPD3029 FPD3030 FPD3031


* Reduced air travel
tab1 FPD3032 FPD3033 FPD3034, m

replace FPD3032 = . if FPD3032 < 0
replace FPD3033 = . if FPD3033 < 0
replace FPD3034 = . if FPD3034 < 0

egen airTravel = group(FPD3032 FPD3033 FPD3034), label
tab airTravel, m

recode airTravel (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable airTravel "Reduced air travel"
label values airTravel actions_lb
tab airTravel, m

tab FPD3032 FPD3033

recode airTravel (0 2 = 0) (1 3 = 1), gen(airTravel_bin)
label variable airTravel_bin "Reduced air travel (binary)"
label values airTravel_bin actions_bin_lb
tab airTravel_bin, m

drop FPD3032 FPD3033 FPD3034


* Electric/hybrid car
tab1 FPD3035 FPD3036 FPD3037, m

replace FPD3035 = . if FPD3035 < 0
replace FPD3036 = . if FPD3036 < 0
replace FPD3037 = . if FPD3037 < 0

egen elecCar = group(FPD3035 FPD3036 FPD3037), label
tab elecCar, m

recode elecCar (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable elecCar "Electric/hybrid car"
label values elecCar actions_lb
tab elecCar, m

tab FPD3035 FPD3036

recode elecCar (0 2 = 0) (1 3 = 1), gen(elecCar_bin)
label variable elecCar_bin "Electric/hybrid car (binary)"
label values elecCar_bin actions_bin_lb
tab elecCar_bin, m

drop FPD3035 FPD3036 FPD3037


* Bought local food
tab1 FPD3038 FPD3039 FPD3040, m

replace FPD3038 = . if FPD3038 < 0
replace FPD3039 = . if FPD3039 < 0
replace FPD3040 = . if FPD3040 < 0

egen localFood = group(FPD3038 FPD3039 FPD3040), label
tab localFood, m

recode localFood (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable localFood "Bought local food"
label values localFood actions_lb
tab localFood, m

tab FPD3038 FPD3039 

recode localFood (0 2 = 0) (1 3 = 1), gen(localFood_bin)
label variable localFood_bin "Bought local food (binary)"
label values localFood_bin actions_bin_lb
tab localFood_bin, m

drop FPD3038 FPD3039 FPD3040


* Recycled more
tab1 FPD3041 FPD3042 FPD3043, m

replace FPD3041 = . if FPD3041 < 0
replace FPD3042 = . if FPD3042 < 0
replace FPD3043 = . if FPD3043 < 0

egen recycle = group(FPD3041 FPD3042 FPD3043), label
tab recycle, m

recode recycle (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable recycle "Recycled more"
label values recycle actions_lb
tab recycle, m

tab FPD3041 FPD3042

recode recycle (0 2 = 0) (1 3 = 1), gen(recycle_bin)
label variable recycle_bin "Recycled more (binary)"
label values recycle_bin actions_bin_lb
tab recycle_bin, m

drop FPD3041 FPD3042 FPD3043


* Reduced plastic use
tab1 FPD3044 FPD3045 FPD3046, m

replace FPD3044 = . if FPD3044 < 0
replace FPD3045 = . if FPD3045 < 0
replace FPD3046 = . if FPD3046 < 0

egen plastic = group(FPD3044 FPD3045 FPD3046), label
tab plastic, m

recode plastic (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable plastic "Reduced plastic use"
label values plastic actions_lb
tab plastic, m

tab FPD3044 FPD3045

recode plastic (0 2 = 0) (1 3 = 1), gen(plastic_bin)
label variable plastic_bin "Reduced plastic use (binary)"
label values plastic_bin actions_bin_lb
tab plastic_bin, m

drop FPD3044 FPD3045 FPD3046


* Chosen sustainably sourced items
tab1 FPD3047 FPD3048 FPD3049, m

replace FPD3047 = . if FPD3047 < 0
replace FPD3048 = . if FPD3048 < 0
replace FPD3049 = . if FPD3049 < 0

egen sustainable = group(FPD3047 FPD3048 FPD3049), label
tab sustainable, m

recode sustainable (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable sustainable "Chosen sustainably sourced items"
label values sustainable actions_lb
tab sustainable, m

tab FPD3047 FPD3048

recode sustainable (0 2 = 0) (1 3 = 1), gen(sustainable_bin)
label variable sustainable_bin "Chosen sustainably sourced items (binary)"
label values sustainable_bin actions_bin_lb
tab sustainable_bin, m

drop FPD3047 FPD3048 FPD3049


* Improved home insulation
tab1 FPD3050 FPD3051 FPD3052, m

replace FPD3050 = . if FPD3050 < 0
replace FPD3051 = . if FPD3051 < 0
replace FPD3052 = . if FPD3052 < 0

egen insulation = group(FPD3050 FPD3051 FPD3052), label
tab insulation, m

recode insulation (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable insulation "Improved home insulation"
label values insulation actions_lb
tab insulation, m

tab FPD3050 FPD3051

recode insulation (0 2 = 0) (1 3 = 1), gen(insulation_bin)
label variable insulation_bin "Improved home insulation (binary)"
label values insulation_bin actions_bin_lb
tab insulation_bin, m

drop FPD3050 FPD3051 FPD3052


* Installed solar panels
tab1 FPD3053 FPD3054 FPD3055, m

replace FPD3053 = . if FPD3053 < 0
replace FPD3054 = . if FPD3054 < 0
replace FPD3055 = . if FPD3055 < 0

egen solar = group(FPD3053 FPD3054 FPD3055), label
tab solar, m

recode solar (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable solar "Installed solar panels"
label values solar actions_lb
tab solar, m

tab FPD3053 FPD3054

recode solar (0 2 = 0) (1 3 = 1), gen(solar_bin)
label variable solar_bin "Installed solar panels (binary)"
label values solar_bin actions_bin_lb
tab solar_bin, m

drop FPD3053 FPD3054 FPD3055


* Started growing vegetables
tab1 FPD3056 FPD3057 FPD3058, m

replace FPD3056 = . if FPD3056 < 0
replace FPD3057 = . if FPD3057 < 0
replace FPD3058 = . if FPD3058 < 0

egen veg = group(FPD3056 FPD3057 FPD3058), label
tab veg, m

recode veg (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable veg "Started growing vegetables"
label values veg actions_lb
tab veg, m

tab FPD3056 FPD3057

recode veg (0 2 = 0) (1 3 = 1), gen(veg_bin)
label variable veg_bin "Started growing vegetables (binary)"
label values veg_bin actions_bin_lb
tab veg_bin, m

drop FPD3056 FPD3057 FPD3058


* Planted trees
tab1 FPD3059 FPD3060 FPD3061, m

replace FPD3059 = . if FPD3059 < 0
replace FPD3060 = . if FPD3060 < 0
replace FPD3061 = . if FPD3061 < 0

egen trees = group(FPD3059 FPD3060 FPD3061), label
tab trees, m

recode trees (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable trees "Planted trees"
label values trees actions_lb
tab trees, m

tab FPD3059 FPD3060

recode trees (0 2 = 0) (1 3 = 1), gen(trees_bin)
label variable trees_bin "Planted trees (binary)"
label values trees_bin actions_bin_lb
tab trees_bin, m

drop FPD3059 FPD3060 FPD3061


* Avoided fossil fuel organisations
tab1 FPD3062 FPD3063 FPD3064, m

replace FPD3062 = . if FPD3062 < 0
replace FPD3063 = . if FPD3063 < 0
replace FPD3064 = . if FPD3064 < 0

egen avoidFossil = group(FPD3062 FPD3063 FPD3064), label
tab avoidFossil, m

recode avoidFossil (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable avoidFossil "Avoided fossil fuel organisations"
label values avoidFossil actions_lb
tab avoidFossil, m

tab FPD3062 FPD3063

recode avoidFossil (0 2 = 0) (1 3 = 1), gen(avoidFossil_bin)
label variable avoidFossil_bin "Avoided fossil fuel organisations (binary)"
label values avoidFossil_bin actions_bin_lb
tab avoidFossil_bin, m

drop FPD3062 FPD3063 FPD3064


* Planned fewer children
tab1 FPD3065 FPD3066 FPD3067, m

replace FPD3065 = . if FPD3065 < 0
replace FPD3066 = . if FPD3066 < 0
replace FPD3067 = . if FPD3067 < 0

egen children = group(FPD3065 FPD3066 FPD3067), label
tab children, m

recode children (1 =.) (2=0) (3=2) (4=1) (5=3)
label variable children "Planned fewer children"
label values children actions_lb
tab children, m

tab FPD3065 FPD3066

recode children (0 2 = 0) (1 3 = 1), gen(children_bin)
label variable children_bin "Planned fewer children (binary)"
label values children_bin actions_bin_lb
tab children_bin, m

drop FPD3065 FPD3066 FPD3067


* Taken other climate action
tab1 FPD3068 FPD3069 FPD3070, m

replace FPD3068 = . if FPD3068 < 0
replace FPD3069 = . if FPD3069 < 0
replace FPD3070 = . if FPD3070 < 0

egen otherAction = group(FPD3068 FPD3069 FPD3070), label
tab otherAction, m

recode otherAction (1 =.) (2=0) (3=2) (4=1) (5=3) 
label variable otherAction "Taken other climate action"
label values otherAction actions_lb
tab otherAction, m

tab FPD3068 FPD3069

recode otherAction (0 2 = 0) (1 3 = 1), gen(otherAction_bin)
label variable otherAction_bin "Taken other climate action (binary)"
label values otherAction_bin actions_bin_lb
tab otherAction_bin, m

drop FPD3068 FPD3069 FPD3070


* Reduced meat/dairy consumption
tab1 FPD3071 FPD3072 FPD3073, m

replace FPD3071 = . if FPD3071 < 0
replace FPD3072 = . if FPD3072 < 0
replace FPD3073 = . if FPD3073 < 0

egen meatDairy = group(FPD3071 FPD3072 FPD3073), label
tab meatDairy, m

recode meatDairy (1 =.) (2=0) (3=2) (4=1) (5=3) 
label variable meatDairy "Reduced meat/dairy consumption"
label values meatDairy actions_lb
tab meatDairy, m

tab FPD3071 FPD3072

* Check answers if vegan/vegatarian - This is complicated, as some vegetarians/vegans answered this question, while others did not (vegetarians should also not be a separate category as they can still reduce dairy consumption, but hey ho). Will exclude answers from those who said 'always vegan' (as should not consume any meat or dairy products), but keep answers from those who said 'always vegetarian' 
tab1 FPD3074 FPD3075, m

tab meatDairy if FPD3074 == 1 | FPD3075 == 1
tab1 FPD3074 FPD3075 if meatDairy != .

replace meatDairy = . if FPD3075 == 1
tab meatDairy, m
drop FPD3074 FPD3075

recode meatDairy (0 2 = 0) (1 3 = 1), gen(meatDairy_bin)
label variable meatDairy_bin "Reduced meat/dairy consumption (binary)"
label values meatDairy_bin actions_bin_lb
tab meatDairy_bin, m

drop FPD3071 FPD3072 FPD3073


** Calculate total number of actions taken for climate reasons (will exclude 'other' though)
egen total_actions = rowtotal(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin children_bin meatDairy_bin), missing

tab total_actions, m
sum total_actions

* Code as missing if any questions missing
egen total_miss = rowmiss(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin children_bin meatDairy_bin)
tab total_miss, m

replace total_actions = . if total_miss > 0
tab total_actions, m
sum total_actions

drop total_miss


** Also calculate total number of actions excluding one's which may be prohibitively costly (i.e., excluding air travel, electric car, home insulation, solar panels and growing vegetables)
egen total_actions_red = rowtotal(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin children_bin meatDairy_bin), missing

tab total_actions_red, m
sum total_actions_red

* Code as missing if any questions missing
egen total_miss_red = rowmiss(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin children_bin meatDairy_bin)
tab total_miss_red, m

replace total_actions_red = . if total_miss_red > 0
tab total_actions_red, m
sum total_actions_red

drop total_miss_red


** Also calculate number of actions excluding 'had fewer/no children' to match parent data (as question not relevant for parents)
egen total_actions_excKids = rowtotal(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin meatDairy_bin), missing

tab total_actions_excKids, m
sum total_actions_excKids

* Code as missing if any questions missing
egen total_miss_excKids = rowmiss(travel_bin waste_bin energy_bin buy_bin airTravel_bin elecCar_bin localFood_bin recycle_bin plastic_bin sustainable_bin insulation_bin solar_bin veg_bin trees_bin avoidFossil_bin meatDairy_bin)
tab total_miss_excKids, m

replace total_actions_excKids = . if total_miss_excKids > 0
tab total_actions_excKids, m
sum total_actions_excKids

drop total_miss_excKids


** And for reduced number of actions
egen total_actions_red_excKids = rowtotal(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin meatDairy_bin), missing

tab total_actions_red_excKids, m
sum total_actions_red_excKids

* Code as missing if any questions missing
egen total_miss_red_excKids = rowmiss(travel_bin waste_bin energy_bin buy_bin localFood_bin recycle_bin plastic_bin sustainable_bin trees_bin avoidFossil_bin meatDairy_bin)
tab total_miss_red_excKids, m

replace total_actions_red_excKids = . if total_miss_red_excKids > 0
tab total_actions_red_excKids, m
sum total_actions_red_excKids

drop total_miss_red_excKids


** Loop through labels and remove if negative/unnecessary
label dir

local labels r(names)
display `labels'

local labels "meatDairy otherAction children avoidFossil trees veg solar insulation sustainable plastic recycle localFood elecCar airTravel buy energy waste actions_bin_lb travel imd_lb ethnic_lb FPD3000 FPD3001 FPD3002 FPD3003 FPD3010 FPD3011 FPD3012 FPD3013 FPD3014 FPD3015 FPD3016 FPD3017 FPD3020 FPD3021 FPD3022 FPD3023 FPD3024 FPD3025 FPD3026 FPD3027 FPD3028 FPD3029 FPD3030 FPD3031 FPD3032 FPD3033 FPD3034 FPD3035 FPD3036 FPD3037 FPD3038 FPD3039 FPD3040 FPD3041 FPD3042 FPD3043 FPD3044 FPD3045 FPD3046 FPD3047 FPD3048 FPD3049 FPD3050 FPD3051 FPD3052 FPD3053 FPD3054 FPD3055 FPD3056 FPD3057 FPD3058 FPD3059 FPD3060 FPD3061 FPD3062 FPD3063 FPD3064 FPD3065 FPD3066 FPD3067 FPD3068 FPD3069 FPD3070 FPD3071 FPD3072 FPD3073 FPD3074 FPD3075 FPD6500 YPC2492 YPE6020 YPF7970 YPJ3000 YPJ3001 YPJ3002 YPJ3003 YPJ3010 YPJ3011 YPJ3012 YPJ3013 YPJ3014 YPJ3015 YPJ3016 YPJ3017 YPJ3020 YPJ3021 YPJ3022 YPJ3023 YPJ3024 YPJ3025 YPJ3026 YPJ3027 YPJ3028 YPJ3029 YPJ3030 YPJ3031 YPJ3032 YPJ3033 YPJ3034 YPJ3035 YPJ3036 YPJ3037 YPJ3038 YPJ3039 YPJ3040 YPJ3041 YPJ3042 YPJ3043 YPJ3044 YPJ3045 YPJ3046 YPJ3047 YPJ3048 YPJ3049 YPJ3050 YPJ3051 YPJ3052 YPJ3053 YPJ3054 YPJ3055 YPJ3056 YPJ3057 YPJ3058 YPJ3059 YPJ3060 YPJ3061 YPJ3062 YPJ3063 YPJ3064 YPJ3065 YPJ3066 YPJ3067 YPJ3068 YPJ3069 YPJ3070 YPJ3071 YPJ3072 YPJ3073 YPJ3074 YPJ3075 YPJ7500 Z3000 Z3001 Z3002 Z3003 Z3010 Z3011 Z3012 Z3013 Z3014 Z3015 Z3016 Z3017 Z3020 Z3021 Z3022 Z3023 Z3024 Z3025 Z3026 Z3027 Z3028 Z3029 Z3030 Z3031 Z3032 Z3033 Z3034 Z3035 Z3036 Z3037 Z3038 Z3039 Z3040 Z3041 Z3042 Z3043 Z3044 Z3045 Z3046 Z3047 Z3048 Z3049 Z3050 Z3051 Z3052 Z3053 Z3054 Z3055 Z3056 Z3057 Z3058 Z3059 Z3060 Z3061 Z3062 Z3063 Z3064 Z3065 Z3066 Z3067 Z3068 Z3069 Z3070 Z3071 Z3072 Z3073 Z3074 Z3075 Z6500 bestgest c645a c666a c755 c765 c800 c801 c804 h470 in_core in_phase2 in_phase3 in_phase4 jan2014imd2010q5_M jan2021imd2015q5_YP kz011b kz021 kz030 mum_and_preg_enrolled mz005l mz005m mz010a mz013 mz014 mz028b partner_age partner_changed partner_changed_when partner_data partner_enrolled partner_in_alspac partner_in_core preg_enrol_status preg_in_alsp preg_in_core pz_mult pz_multid second_partner_age actions_lb"

* Have to create labels for all objects first, before removing them (else those without the number beforehand get added one)
foreach label of local labels {
	display "`label'"
	label define `label' -9999 "test" -11 "test" -10 "test" -9 "test" -8 "test" -5 "test" -2 "test" -1 "test", modify
	label define `label' -9999 "" -11 "" -10 "" -9 "" -8 "" -5 "" -2 "" -1 "", modify
}

label list


** Save processed file here (and also for synthesising)
save "B4123_partnerData_processed.dta", replace


log close
clear
