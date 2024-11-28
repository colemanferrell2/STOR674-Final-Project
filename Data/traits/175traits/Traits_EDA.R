library(R.matlab)
library(car)
#####Load Data#####

#Set working directory to project folder (an example is shown below)
setwd("C:/Users/colem/Desktop/STOR 674/STOR674 Final Project")

#Retrieve 175 traits and subject ID from MatLab Data file
data <- readMat("Data/traits/175traits/HCP_175Traits.mat")
table1 <- data$hcp.subj.id
table2 <- data$traits.175

 cor(t(table2))[1,5]

#Combine subject IDs with traits
traits <-
