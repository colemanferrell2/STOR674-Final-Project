#Install the combootcca package and R.matlab package if not installed already
#devtools::install_github("dankessler/combootcca")


#add comment to talk about setting working directory
# Set your working directory to the project folder
setwd("C:/Users/colem/Desktop/STOR 674/STOR674 Final Project")

library(combootcca)


#Load .csv Data file with Pairwise Correlations and traits
Pairwise_Corr_FC <- read.csv("Analysis/Pairwise_Corr_FC.csv")
Subj_175_Traits <- read.csv("Analysis/Traits175.csv")
Subj_confound_var <- read.csv("Analysis/Confounding_variables.csv")

