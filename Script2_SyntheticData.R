### ALSPAC climate beliefs and behaviours data note - ALSPAC B-number B4123
### Script 2: Generating synthetic datasets
### Created 25/1/2024 by Dan Major-Smith
### R version 4.3.1

###########################################################################################
#### Clear workspace, install/load packages, and set working directory
rm(list = ls())

setwd("X:\\Studies\\RSBB Team\\Dan\\B4123 - Climate Data Note")

#install.packages("tidyverse")
library(tidyverse)

#install.packages("synthpop")
library(synthpop)

#install.packages("readstata13")
library(readstata13)

#install.packages("haven")
library(haven)


##########################################################################################
#### Read in the processed offspring dataset, reduce down to observations with climate data, and generate synthetic datasets using 'synthpop' (https://www.synthpop.org.uk/get-started.html)

data_raw <- read.dta13("B4123_offspringData_processed.dta", nonint.factors = TRUE)
head(data_raw)
glimpse(data_raw)


# Take a working copy by dropping some admin vars and 'total number of actions' (will recreate later to ensure consistency with the individual actions) and keeping just observations in the complete-case analyses
dat <- data_raw %>%
  select(-c(aln, qlet, total_actions:total_actions_red_excKids)) %>%
  filter(!is.na(age))

head(dat)
glimpse(dat)


#### Now start the synthpop process

# Get information about variables in the dataset
codebook.syn(dat)$tab

# Create a synthetic dataset using default options (which are non-parametric/CART [classification and regression trees]) - Also specify rules to ensure consistency between variables
dat_syn <- syn(dat, seed = 268645,
               rules = list(climateConcern = "climateChanging == '0. Definitely not'",
                            climateHumans = "climateChanging == '0. Definitely not'",
                            climateAction = "climateChanging == '0. Definitely not'",
                            climateConcern_mum = "climateChanging_mum == '0. Definitely not'",
                            climateHumans_mum = "climateChanging_mum == '0. Definitely not'",
                            climateAction_mum = "climateChanging_mum == '0. Definitely not'",
                            climateConcern_ptnr = "climateChanging_ptnr == '0. Definitely not'",
                            climateHumans_ptnr = "climateChanging_ptnr == '0. Definitely not'",
                            climateAction_ptnr = "climateChanging_ptnr == '0. Definitely not'"),
               rvalues = list(climateConcern = NA, climateHumans = NA, climateAction = NA,
                              climateConcern_mum = NA, climateHumans_mum = NA, climateAction_mum = NA,
                              climateConcern_ptnr = NA, climateHumans_ptnr = NA, climateAction_ptnr = NA))

head(dat_syn$syn[dat_syn$syn$climateChanging == "0. Definitely not", ])
head(dat_syn$syn[dat_syn$syn$climateChanging_mum == "0. Definitely not", ])
head(dat_syn$syn[dat_syn$syn$climateChanging_ptnr == "0. Definitely not", ])
head(dat_syn$syn)


## Re-create the binary climate action variables so they are consistent with the categorical variables
dat_syn$syn <- dat_syn$syn %>%
  mutate(travel_bin = ifelse(is.na(travel), NA,
                             ifelse(travel == "0. No" | travel == "2. Yes, for other",
                                    "0. No", "1. Yes"))) %>%
  mutate(travel_bin = as.factor(travel_bin)) %>%
  mutate(waste_bin = ifelse(is.na(waste), NA,
                            ifelse(waste == "0. No" | waste == "2. Yes, for other",
                                   "waste_bin No", "1. Yes"))) %>%
  mutate(waste_bin = as.factor(travel_bin)) %>%
  mutate(energy_bin = ifelse(is.na(energy), NA,
                             ifelse(energy == "0. No" | energy == "2. Yes, for other",
                                    "0. No", "1. Yes"))) %>%
  mutate(energy_bin = as.factor(energy_bin)) %>%
  mutate(buy_bin = ifelse(is.na(buy), NA,
                          ifelse(buy == "0. No" | buy == "2. Yes, for other",
                                 "0. No", "1. Yes"))) %>%
  mutate(buy_bin = as.factor(buy_bin)) %>%
  mutate(airTravel_bin = ifelse(is.na(airTravel), NA,
                                ifelse(airTravel == "0. No" | airTravel == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(airTravel_bin = as.factor(airTravel_bin)) %>%
  mutate(elecCar_bin = ifelse(is.na(elecCar), NA,
                              ifelse(elecCar == "0. No" | elecCar == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(elecCar_bin = as.factor(elecCar_bin)) %>%
  mutate(localFood_bin = ifelse(is.na(localFood), NA,
                                ifelse(localFood == "0. No" | localFood == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(localFood_bin = as.factor(localFood_bin)) %>%
  mutate(recycle_bin = ifelse(is.na(recycle), NA,
                              ifelse(recycle == "0. No" | recycle == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(recycle_bin = as.factor(recycle_bin)) %>%
  mutate(plastic_bin = ifelse(is.na(plastic), NA,
                              ifelse(plastic == "0. No" | plastic == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(plastic_bin = as.factor(plastic_bin)) %>%
  mutate(sustainable_bin = ifelse(is.na(sustainable), NA,
                                  ifelse(sustainable == "0. No" | sustainable == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(sustainable_bin = as.factor(sustainable_bin)) %>%
  mutate(insulation_bin = ifelse(is.na(insulation), NA,
                                 ifelse(insulation == "0. No" | insulation == "2. Yes, for other",
                                        "0. No", "1. Yes"))) %>%
  mutate(insulation_bin = as.factor(insulation_bin)) %>%
  mutate(solar_bin = ifelse(is.na(solar), NA,
                            ifelse(solar == "0. No" | solar == "2. Yes, for other",
                                   "0. No", "1. Yes"))) %>%
  mutate(solar_bin = as.factor(solar_bin)) %>%
  mutate(veg_bin = ifelse(is.na(veg), NA,
                          ifelse(veg == "0. No" | veg == "2. Yes, for other",
                                 "0. No", "1. Yes"))) %>%
  mutate(veg_bin = as.factor(veg_bin)) %>%
  mutate(trees_bin = ifelse(is.na(trees), NA,
                            ifelse(trees == "0. No" | trees == "2. Yes, for other",
                                   "0. No", "1. Yes"))) %>%
  mutate(trees_bin = as.factor(trees_bin)) %>%
  mutate(avoidFossil_bin = ifelse(is.na(avoidFossil), NA,
                                  ifelse(avoidFossil == "0. No" | avoidFossil == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(avoidFossil_bin = as.factor(avoidFossil_bin)) %>%
  mutate(children_bin = ifelse(is.na(children), NA,
                               ifelse(children == "0. No" | children == "2. Yes, for other",
                                      "0. No", "1. Yes"))) %>%
  mutate(children_bin = as.factor(children_bin)) %>%
  mutate(otherAction_bin = ifelse(is.na(otherAction), NA,
                                  ifelse(otherAction == "0. No" | otherAction == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(otherAction_bin = as.factor(otherAction_bin)) %>%
  mutate(meatDairy_bin = ifelse(is.na(meatDairy), NA,
                                ifelse(meatDairy == "0. No" | meatDairy == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(meatDairy_bin = as.factor(meatDairy_bin))

head(dat_syn$syn)
glimpse(dat_syn$syn)


# Use the 'sdc' command (statistical disclosure control) to identify and remove any cases that are unique in both synthetic and observed data (i.e., cases which may be disclosive) - Here, 0 observations have been dropped (0.0% of data)
replicated.uniques(dat_syn, dat)
dat_syn <- sdc(dat_syn, dat, rm.replicated.uniques = TRUE)


## Take a few unique true observations, and make sure not fully-replicated in synthetic dataset (based on the 'replicated.uniques' command from the 'synthpop' package)

# Make a dataset just of unique individuals using the observed data (as if two or more participants share exactly the same data, then it's impossible to link back to a unique individual)
sum(!(duplicated(dat) | duplicated(dat, fromLast = TRUE)))
dat_unique <- dat[!(duplicated(dat) | duplicated(dat, fromLast = TRUE)), ]

# Make a dataset just of unique individuals from the synthetic dataset
sum(!(duplicated(dat_syn$syn) | duplicated(dat_syn$syn, fromLast = TRUE)))
syn_unique <- dat_syn$syn[!(duplicated(dat_syn$syn) | duplicated(dat_syn$syn, fromLast = TRUE)), ]

# Select a random row from the observed data
(row_unique <- dat_unique[sample(nrow(dat_unique), 1), ])

# Combine observed row with the synthetic data, and see if any duplicates
sum(duplicated(rbind.data.frame(syn_unique, row_unique)))

# Repeat for a few more rows of observed data
(row_unique <- dat_unique[sample(nrow(dat_unique), 10), ])
sum(duplicated(rbind.data.frame(syn_unique, row_unique)))


### Explore this synthetic dataset
dat_syn
summary(dat_syn)

# Compare between actual and synthetic datasets - This provides tables and plots comparing distribution of variables between the two datasets (correspondence is fairly good). Save this as a PDF
compare(dat_syn, dat, stat = "counts", nrow = 7, ncol = 10)

pdf("./Results_SynthPop/ComparingDescStats_offspring.pdf", height = 18, width = 24)
compare(dat_syn, dat, stat = "counts", nrow = 7, ncol = 10)
dev.off()


## Univariable ordinal regression analysis with 'belief in climate change' as outcome and education as exposure to show that get similar results in both datasets (i.e., that the structures of the dataset are preserved)
model.syn <- polr.synds(climateChanging ~ edu, data = dat_syn)
summary(model.syn)

# Results not exactly the same, but similar overall pattern of results (and store as PDF)
compare(model.syn, dat)

pdf("./Results_SynthPop/ComparingUnadjustedModel_offspring.pdf", height = 6, width = 8)
compare(model.syn, dat)
dev.off()


## Now re-create the total number of climate actions variables
dat_syn$syn <- dat_syn$syn %>%
  rowwise() %>%
  mutate(total_actions = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, as.numeric(energy_bin) - 1, 
                             as.numeric(buy_bin) - 1, as.numeric(airTravel_bin) - 1, as.numeric(elecCar_bin) - 1,
                             as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                             as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                             as.numeric(insulation_bin) - 1, as.numeric(solar_bin) - 1,
                             as.numeric(veg_bin) - 1, as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                             as.numeric(children_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_red = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, as.numeric(energy_bin) - 1, 
                             as.numeric(buy_bin) - 1, as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                             as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                             as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                             as.numeric(children_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_excKids = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, 
                                     as.numeric(energy_bin) - 1, as.numeric(buy_bin) - 1, 
                                     as.numeric(airTravel_bin) - 1, as.numeric(elecCar_bin) - 1,
                                     as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                     as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                     as.numeric(insulation_bin) - 1, as.numeric(solar_bin) - 1,
                                     as.numeric(veg_bin) - 1, as.numeric(trees_bin) - 1, 
                                     as.numeric(avoidFossil_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_red_excKids = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, 
                                         as.numeric(energy_bin) - 1, as.numeric(buy_bin) - 1,
                                         as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                         as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                         as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                                         as.numeric(meatDairy_bin) - 1)) %>%
  ungroup() %>%
  relocate(age:meatDairy_bin, total_actions:total_actions_red_excKids)

summary(dat_syn$syn$total_actions)
summary(dat_syn$syn$total_actions_red)
summary(dat_syn$syn$total_actions_excKids)
summary(dat_syn$syn$total_actions_red_excKids)


### Adding in a variable called 'FALSE_DATA', with the value 'FALSE_DATA' for all observations, as an additional safety check to users know the dataset is synthetic
dat_syn$syn <- cbind(FALSE_DATA = rep("FALSE_DATA", nrow(dat_syn$syn)), dat_syn$syn)
summary(dat_syn)

# Extract the synthetic dataset (rather than it being stored within a list)
dat_syn_df <- dat_syn$syn
head(dat_syn_df)
glimpse(dat_syn_df)
summary(dat_syn_df)


## Now store this synthetic dataset in Stata format
write_dta(dat_syn_df, ".\\AnalysisCode_ClimateDataNote_B4123\\SyntheticData\\syntheticData_Offspring_B4123.dta")



##########################################################################################
#### Read in the processed mother's dataset, reduce down to observations with climate data, and generate synthetic datasets using 'synthpop' (https://www.synthpop.org.uk/get-started.html)

rm(list = ls())

data_raw <- read.dta13("B4123_motherData_processed.dta", nonint.factors = TRUE)
head(data_raw)
glimpse(data_raw)


# Take a working copy by dropping some admin vars and 'total number of actions' (will recreate later to ensure consistency with the individual actions) and keeping just observations in the complete-case analyses
dat <- data_raw %>%
  select(-c(aln, total_actions:total_actions_red_excKids)) %>%
  filter(!is.na(age))

head(dat)
glimpse(dat)


#### Now start the synthpop process

# Get information about variables in the dataset
codebook.syn(dat)$tab

# Create a synthetic dataset using default options (which are non-parametric/CART [classification and regression trees]) - Also specify rules to ensure consistency between variables
dat_syn <- syn(dat, seed = 57469,
               rules = list(climateConcern = "climateChanging == '0. Definitely not'",
                            climateHumans = "climateChanging == '0. Definitely not'",
                            climateAction = "climateChanging == '0. Definitely not'",
                            climateConcern_ptnr = "climateChanging_ptnr == '0. Definitely not'",
                            climateHumans_ptnr = "climateChanging_ptnr == '0. Definitely not'",
                            climateAction_ptnr = "climateChanging_ptnr == '0. Definitely not'"),
               rvalues = list(climateConcern = NA, climateHumans = NA, climateAction = NA,
                              climateConcern_ptnr = NA, climateHumans_ptnr = NA, climateAction_ptnr = NA))

head(dat_syn$syn[dat_syn$syn$climateChanging == "0. Definitely not", ])
head(dat_syn$syn[dat_syn$syn$climateChanging_ptnr == "0. Definitely not", ])
head(dat_syn$syn)


## Re-create the binary climate action variables so they are consistent with the categorical variables
dat_syn$syn <- dat_syn$syn %>%
  mutate(travel_bin = ifelse(is.na(travel), NA,
                             ifelse(travel == "0. No" | travel == "2. Yes, for other",
                                    "0. No", "1. Yes"))) %>%
  mutate(travel_bin = as.factor(travel_bin)) %>%
  mutate(waste_bin = ifelse(is.na(waste), NA,
                            ifelse(waste == "0. No" | waste == "2. Yes, for other",
                                   "waste_bin No", "1. Yes"))) %>%
  mutate(waste_bin = as.factor(travel_bin)) %>%
  mutate(energy_bin = ifelse(is.na(energy), NA,
                             ifelse(energy == "0. No" | energy == "2. Yes, for other",
                                    "0. No", "1. Yes"))) %>%
  mutate(energy_bin = as.factor(energy_bin)) %>%
  mutate(buy_bin = ifelse(is.na(buy), NA,
                          ifelse(buy == "0. No" | buy == "2. Yes, for other",
                                 "0. No", "1. Yes"))) %>%
  mutate(buy_bin = as.factor(buy_bin)) %>%
  mutate(airTravel_bin = ifelse(is.na(airTravel), NA,
                                ifelse(airTravel == "0. No" | airTravel == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(airTravel_bin = as.factor(airTravel_bin)) %>%
  mutate(elecCar_bin = ifelse(is.na(elecCar), NA,
                              ifelse(elecCar == "0. No" | elecCar == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(elecCar_bin = as.factor(elecCar_bin)) %>%
  mutate(localFood_bin = ifelse(is.na(localFood), NA,
                                ifelse(localFood == "0. No" | localFood == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(localFood_bin = as.factor(localFood_bin)) %>%
  mutate(recycle_bin = ifelse(is.na(recycle), NA,
                              ifelse(recycle == "0. No" | recycle == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(recycle_bin = as.factor(recycle_bin)) %>%
  mutate(plastic_bin = ifelse(is.na(plastic), NA,
                              ifelse(plastic == "0. No" | plastic == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(plastic_bin = as.factor(plastic_bin)) %>%
  mutate(sustainable_bin = ifelse(is.na(sustainable), NA,
                                  ifelse(sustainable == "0. No" | sustainable == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(sustainable_bin = as.factor(sustainable_bin)) %>%
  mutate(insulation_bin = ifelse(is.na(insulation), NA,
                                 ifelse(insulation == "0. No" | insulation == "2. Yes, for other",
                                        "0. No", "1. Yes"))) %>%
  mutate(insulation_bin = as.factor(insulation_bin)) %>%
  mutate(solar_bin = ifelse(is.na(solar), NA,
                            ifelse(solar == "0. No" | solar == "2. Yes, for other",
                                   "0. No", "1. Yes"))) %>%
  mutate(solar_bin = as.factor(solar_bin)) %>%
  mutate(veg_bin = ifelse(is.na(veg), NA,
                          ifelse(veg == "0. No" | veg == "2. Yes, for other",
                                 "0. No", "1. Yes"))) %>%
  mutate(veg_bin = as.factor(veg_bin)) %>%
  mutate(trees_bin = ifelse(is.na(trees), NA,
                            ifelse(trees == "0. No" | trees == "2. Yes, for other",
                                   "0. No", "1. Yes"))) %>%
  mutate(trees_bin = as.factor(trees_bin)) %>%
  mutate(avoidFossil_bin = ifelse(is.na(avoidFossil), NA,
                                  ifelse(avoidFossil == "0. No" | avoidFossil == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(avoidFossil_bin = as.factor(avoidFossil_bin)) %>%
  mutate(children_bin = ifelse(is.na(children), NA,
                               ifelse(children == "0. No" | children == "2. Yes, for other",
                                      "0. No", "1. Yes"))) %>%
  mutate(children_bin = as.factor(children_bin)) %>%
  mutate(otherAction_bin = ifelse(is.na(otherAction), NA,
                                  ifelse(otherAction == "0. No" | otherAction == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(otherAction_bin = as.factor(otherAction_bin)) %>%
  mutate(meatDairy_bin = ifelse(is.na(meatDairy), NA,
                                ifelse(meatDairy == "0. No" | meatDairy == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(meatDairy_bin = as.factor(meatDairy_bin))

head(dat_syn$syn)
glimpse(dat_syn$syn)


# Use the 'sdc' command (statistical disclosure control) to identify and remove any cases that are unique in both synthetic and observed data (i.e., cases which may be disclosive) - Here, 1 observations has been dropped (0.02% of data)
replicated.uniques(dat_syn, dat)
dat_syn <- sdc(dat_syn, dat, rm.replicated.uniques = TRUE)


## Take a few unique true observations, and make sure not fully-replicated in synthetic dataset (based on the 'replicated.uniques' command from the 'synthpop' package)

# Make a dataset just of unique individuals using the observed data (as if two or more participants share exactly the same data, then it's impossible to link back to a unique individual)
sum(!(duplicated(dat) | duplicated(dat, fromLast = TRUE)))
dat_unique <- dat[!(duplicated(dat) | duplicated(dat, fromLast = TRUE)), ]

# Make a dataset just of unique individuals from the synthetic dataset
sum(!(duplicated(dat_syn$syn) | duplicated(dat_syn$syn, fromLast = TRUE)))
syn_unique <- dat_syn$syn[!(duplicated(dat_syn$syn) | duplicated(dat_syn$syn, fromLast = TRUE)), ]

# Select a random row from the observed data
(row_unique <- dat_unique[sample(nrow(dat_unique), 1), ])

# Combine observed row with the synthetic data, and see if any duplicates
sum(duplicated(rbind.data.frame(syn_unique, row_unique)))

# Repeat for a few more rows of observed data
(row_unique <- dat_unique[sample(nrow(dat_unique), 10), ])
sum(duplicated(rbind.data.frame(syn_unique, row_unique)))


### Explore this synthetic dataset
dat_syn
summary(dat_syn)

# Compare between actual and synthetic datasets - This provides tables and plots comparing distribution of variables between the two datasets (correspondence is fairly good). Save this as a PDF
compare(dat_syn, dat, stat = "counts", nrow = 8, ncol = 8)

pdf("./Results_SynthPop/ComparingDescStats_mothers.pdf", height = 18, width = 20)
compare(dat_syn, dat, stat = "counts", nrow = 8, ncol = 8)
dev.off()


## Univariable ordinal regression analysis with 'belief in climate change' as outcome and age as exposure to show that get similar results in both datasets (i.e., that the structures of the dataset are preserved)
model.syn <- polr.synds(climateChanging ~ age, data = dat_syn)
summary(model.syn)

# Results not exactly the same, but similar overall pattern of results (and store as PDF)
compare(model.syn, dat)

pdf("./Results_SynthPop/ComparingUnadjustedModel_mothers.pdf", height = 6, width = 8)
compare(model.syn, dat)
dev.off()


## Now re-create the total number of climate actions variables
dat_syn$syn <- dat_syn$syn %>%
  rowwise() %>%
  mutate(total_actions = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, as.numeric(energy_bin) - 1, 
                             as.numeric(buy_bin) - 1, as.numeric(airTravel_bin) - 1, as.numeric(elecCar_bin) - 1,
                             as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                             as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                             as.numeric(insulation_bin) - 1, as.numeric(solar_bin) - 1,
                             as.numeric(veg_bin) - 1, as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                             as.numeric(children_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_red = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, as.numeric(energy_bin) - 1, 
                                 as.numeric(buy_bin) - 1, as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                 as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                 as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                                 as.numeric(children_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_excKids = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, 
                                     as.numeric(energy_bin) - 1, as.numeric(buy_bin) - 1, 
                                     as.numeric(airTravel_bin) - 1, as.numeric(elecCar_bin) - 1,
                                     as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                     as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                     as.numeric(insulation_bin) - 1, as.numeric(solar_bin) - 1,
                                     as.numeric(veg_bin) - 1, as.numeric(trees_bin) - 1, 
                                     as.numeric(avoidFossil_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_red_excKids = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, 
                                         as.numeric(energy_bin) - 1, as.numeric(buy_bin) - 1,
                                         as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                         as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                         as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                                         as.numeric(meatDairy_bin) - 1)) %>%
  ungroup() %>%
  relocate(ageAtBirth:meatDairy_bin, total_actions:total_actions_red_excKids)

summary(dat_syn$syn$total_actions)
summary(dat_syn$syn$total_actions_red)
summary(dat_syn$syn$total_actions_excKids)
summary(dat_syn$syn$total_actions_red_excKids)


### Adding in a variable called 'FALSE_DATA', with the value 'FALSE_DATA' for all observations, as an additional safety check to users know the dataset is synthetic
dat_syn$syn <- cbind(FALSE_DATA = rep("FALSE_DATA", nrow(dat_syn$syn)), dat_syn$syn)
summary(dat_syn)

# Extract the synthetic dataset (rather than it being stored within a list)
dat_syn_df <- dat_syn$syn
head(dat_syn_df)
glimpse(dat_syn_df)
summary(dat_syn_df)


## Now store this synthetic dataset in Stata format
write_dta(dat_syn_df, ".\\AnalysisCode_ClimateDataNote_B4123\\SyntheticData\\syntheticData_mothers_B4123.dta")



##########################################################################################
#### Read in the processed partner's dataset, reduce down to observations with climate data, and generate synthetic datasets using 'synthpop' (https://www.synthpop.org.uk/get-started.html)

rm(list = ls())

data_raw <- read.dta13("B4123_partnerData_processed.dta", nonint.factors = TRUE)
head(data_raw)
glimpse(data_raw)


# Take a working copy by dropping some admin vars and 'total number of actions' (will recreate later to ensure consistency with the individual actions) and keeping just observations in the complete-case analyses
dat <- data_raw %>%
  select(-c(aln, total_actions:total_actions_red_excKids)) %>%
  filter(!is.na(age))

head(dat)
glimpse(dat)


#### Now start the synthpop process

# Get information about variables in the dataset
codebook.syn(dat)$tab

# Create a synthetic dataset using default options (which are non-parametric/CART [classification and regression trees]) - Also specify rules to ensure consistency between variables
dat_syn <- syn(dat, seed = 128450,
               rules = list(climateConcern = "climateChanging == '0. Definitely not'",
                            climateHumans = "climateChanging == '0. Definitely not'",
                            climateAction = "climateChanging == '0. Definitely not'"),
               rvalues = list(climateConcern = NA, climateHumans = NA, climateAction = NA))

head(dat_syn$syn[dat_syn$syn$climateChanging == "0. Definitely not", ])
head(dat_syn$syn)


## Re-create the binary climate action variables so they are consistent with the categorical variables
dat_syn$syn <- dat_syn$syn %>%
  mutate(travel_bin = ifelse(is.na(travel), NA,
                             ifelse(travel == "0. No" | travel == "2. Yes, for other",
                                    "0. No", "1. Yes"))) %>%
  mutate(travel_bin = as.factor(travel_bin)) %>%
  mutate(waste_bin = ifelse(is.na(waste), NA,
                            ifelse(waste == "0. No" | waste == "2. Yes, for other",
                                   "waste_bin No", "1. Yes"))) %>%
  mutate(waste_bin = as.factor(travel_bin)) %>%
  mutate(energy_bin = ifelse(is.na(energy), NA,
                             ifelse(energy == "0. No" | energy == "2. Yes, for other",
                                    "0. No", "1. Yes"))) %>%
  mutate(energy_bin = as.factor(energy_bin)) %>%
  mutate(buy_bin = ifelse(is.na(buy), NA,
                          ifelse(buy == "0. No" | buy == "2. Yes, for other",
                                 "0. No", "1. Yes"))) %>%
  mutate(buy_bin = as.factor(buy_bin)) %>%
  mutate(airTravel_bin = ifelse(is.na(airTravel), NA,
                                ifelse(airTravel == "0. No" | airTravel == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(airTravel_bin = as.factor(airTravel_bin)) %>%
  mutate(elecCar_bin = ifelse(is.na(elecCar), NA,
                              ifelse(elecCar == "0. No" | elecCar == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(elecCar_bin = as.factor(elecCar_bin)) %>%
  mutate(localFood_bin = ifelse(is.na(localFood), NA,
                                ifelse(localFood == "0. No" | localFood == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(localFood_bin = as.factor(localFood_bin)) %>%
  mutate(recycle_bin = ifelse(is.na(recycle), NA,
                              ifelse(recycle == "0. No" | recycle == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(recycle_bin = as.factor(recycle_bin)) %>%
  mutate(plastic_bin = ifelse(is.na(plastic), NA,
                              ifelse(plastic == "0. No" | plastic == "2. Yes, for other",
                                     "0. No", "1. Yes"))) %>%
  mutate(plastic_bin = as.factor(plastic_bin)) %>%
  mutate(sustainable_bin = ifelse(is.na(sustainable), NA,
                                  ifelse(sustainable == "0. No" | sustainable == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(sustainable_bin = as.factor(sustainable_bin)) %>%
  mutate(insulation_bin = ifelse(is.na(insulation), NA,
                                 ifelse(insulation == "0. No" | insulation == "2. Yes, for other",
                                        "0. No", "1. Yes"))) %>%
  mutate(insulation_bin = as.factor(insulation_bin)) %>%
  mutate(solar_bin = ifelse(is.na(solar), NA,
                            ifelse(solar == "0. No" | solar == "2. Yes, for other",
                                   "0. No", "1. Yes"))) %>%
  mutate(solar_bin = as.factor(solar_bin)) %>%
  mutate(veg_bin = ifelse(is.na(veg), NA,
                          ifelse(veg == "0. No" | veg == "2. Yes, for other",
                                 "0. No", "1. Yes"))) %>%
  mutate(veg_bin = as.factor(veg_bin)) %>%
  mutate(trees_bin = ifelse(is.na(trees), NA,
                            ifelse(trees == "0. No" | trees == "2. Yes, for other",
                                   "0. No", "1. Yes"))) %>%
  mutate(trees_bin = as.factor(trees_bin)) %>%
  mutate(avoidFossil_bin = ifelse(is.na(avoidFossil), NA,
                                  ifelse(avoidFossil == "0. No" | avoidFossil == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(avoidFossil_bin = as.factor(avoidFossil_bin)) %>%
  mutate(children_bin = ifelse(is.na(children), NA,
                               ifelse(children == "0. No" | children == "2. Yes, for other",
                                      "0. No", "1. Yes"))) %>%
  mutate(children_bin = as.factor(children_bin)) %>%
  mutate(otherAction_bin = ifelse(is.na(otherAction), NA,
                                  ifelse(otherAction == "0. No" | otherAction == "2. Yes, for other",
                                         "0. No", "1. Yes"))) %>%
  mutate(otherAction_bin = as.factor(otherAction_bin)) %>%
  mutate(meatDairy_bin = ifelse(is.na(meatDairy), NA,
                                ifelse(meatDairy == "0. No" | meatDairy == "2. Yes, for other",
                                       "0. No", "1. Yes"))) %>%
  mutate(meatDairy_bin = as.factor(meatDairy_bin))

head(dat_syn$syn)
glimpse(dat_syn$syn)


# Use the 'sdc' command (statistical disclosure control) to identify and remove any cases that are unique in both synthetic and observed data (i.e., cases which may be disclosive) - Here, 1 observations has been dropped (0.05% of data)
replicated.uniques(dat_syn, dat)
dat_syn <- sdc(dat_syn, dat, rm.replicated.uniques = TRUE)


## Take a few unique true observations, and make sure not fully-replicated in synthetic dataset (based on the 'replicated.uniques' command from the 'synthpop' package)

# Make a dataset just of unique individuals using the observed data (as if two or more participants share exactly the same data, then it's impossible to link back to a unique individual)
sum(!(duplicated(dat) | duplicated(dat, fromLast = TRUE)))
dat_unique <- dat[!(duplicated(dat) | duplicated(dat, fromLast = TRUE)), ]

# Make a dataset just of unique individuals from the synthetic dataset
sum(!(duplicated(dat_syn$syn) | duplicated(dat_syn$syn, fromLast = TRUE)))
syn_unique <- dat_syn$syn[!(duplicated(dat_syn$syn) | duplicated(dat_syn$syn, fromLast = TRUE)), ]

# Select a random row from the observed data
(row_unique <- dat_unique[sample(nrow(dat_unique), 1), ])

# Combine observed row with the synthetic data, and see if any duplicates
sum(duplicated(rbind.data.frame(syn_unique, row_unique)))

# Repeat for a few more rows of observed data
(row_unique <- dat_unique[sample(nrow(dat_unique), 10), ])
sum(duplicated(rbind.data.frame(syn_unique, row_unique)))


### Explore this synthetic dataset
dat_syn
summary(dat_syn)

# Compare between actual and synthetic datasets - This provides tables and plots comparing distribution of variables between the two datasets (correspondence is fairly good). Save this as a PDF
compare(dat_syn, dat, stat = "counts", nrow = 7, ncol = 8)

pdf("./Results_SynthPop/ComparingDescStats_partners.pdf", height = 18, width = 20)
compare(dat_syn, dat, stat = "counts", nrow = 7, ncol = 8)
dev.off()


## Univariable ordinal regression analysis with 'belief in climate change' as outcome and age as exposure to show that get similar results in both datasets (i.e., that the structures of the dataset are preserved)
model.syn <- polr.synds(climateChanging ~ age, data = dat_syn)
summary(model.syn)

# Results not exactly the same, but similar overall pattern of results (and store as PDF)
compare(model.syn, dat)

pdf("./Results_SynthPop/ComparingUnadjustedModel_partners.pdf", height = 6, width = 8)
compare(model.syn, dat)
dev.off()


## Now re-create the total number of climate actions variables
dat_syn$syn <- dat_syn$syn %>%
  rowwise() %>%
  mutate(total_actions = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, as.numeric(energy_bin) - 1, 
                             as.numeric(buy_bin) - 1, as.numeric(airTravel_bin) - 1, as.numeric(elecCar_bin) - 1,
                             as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                             as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                             as.numeric(insulation_bin) - 1, as.numeric(solar_bin) - 1,
                             as.numeric(veg_bin) - 1, as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                             as.numeric(children_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_red = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, as.numeric(energy_bin) - 1, 
                                 as.numeric(buy_bin) - 1, as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                 as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                 as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                                 as.numeric(children_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_excKids = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, 
                                     as.numeric(energy_bin) - 1, as.numeric(buy_bin) - 1, 
                                     as.numeric(airTravel_bin) - 1, as.numeric(elecCar_bin) - 1,
                                     as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                     as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                     as.numeric(insulation_bin) - 1, as.numeric(solar_bin) - 1,
                                     as.numeric(veg_bin) - 1, as.numeric(trees_bin) - 1, 
                                     as.numeric(avoidFossil_bin) - 1, as.numeric(meatDairy_bin) - 1)) %>%
  mutate(total_actions_red_excKids = sum(as.numeric(travel_bin) - 1, as.numeric(waste_bin) - 1, 
                                         as.numeric(energy_bin) - 1, as.numeric(buy_bin) - 1,
                                         as.numeric(localFood_bin) - 1, as.numeric(recycle_bin) - 1, 
                                         as.numeric(plastic_bin) - 1, as.numeric(sustainable_bin) - 1, 
                                         as.numeric(trees_bin) - 1, as.numeric(avoidFossil_bin) - 1,
                                         as.numeric(meatDairy_bin) - 1)) %>%
  ungroup() %>%
  relocate(ageAtBirth:meatDairy_bin, total_actions:total_actions_red_excKids)

summary(dat_syn$syn$total_actions)
summary(dat_syn$syn$total_actions_red)
summary(dat_syn$syn$total_actions_excKids)
summary(dat_syn$syn$total_actions_red_excKids)


### Adding in a variable called 'FALSE_DATA', with the value 'FALSE_DATA' for all observations, as an additional safety check to users know the dataset is synthetic
dat_syn$syn <- cbind(FALSE_DATA = rep("FALSE_DATA", nrow(dat_syn$syn)), dat_syn$syn)
summary(dat_syn)

# Extract the synthetic dataset (rather than it being stored within a list)
dat_syn_df <- dat_syn$syn
head(dat_syn_df)
glimpse(dat_syn_df)
summary(dat_syn_df)


## Now store this synthetic dataset in Stata format
write_dta(dat_syn_df, ".\\AnalysisCode_ClimateDataNote_B4123\\SyntheticData\\syntheticData_partners_B4123.dta")
