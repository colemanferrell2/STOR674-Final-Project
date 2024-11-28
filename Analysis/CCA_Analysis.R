#Install the combootcca package and R.matlab package if not installed already
#devtools::install_github("dankessler/combootcca")


#add comment to talk about setting working directory


library(combootcca)
library(R.matlab)

#Load MatLab Data file with Pairwise Correlations
Pairwise_Corr_FC <- read.csv("Analysis/Pairwise_Corr_FC.csv")
