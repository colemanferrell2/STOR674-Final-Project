#Load Libraries
library(R.matlab)
library(data.table)
library(purrr)

# Set your working directory to the project folder (an example is provided below)
setwd("C:/Users/colem/Desktop/STOR 674/STOR674 Final Project")

##### Functional Connectivity Correlation Matrix to Pairwise Correlation Matrix #####

# Load Functional Connectivity Correlation Matrix from the data directory
FC_Data <- readMat("Data/FC/HCP_cortical_DesikanAtlas_FC.mat") 
list2env(FC_Data,envir = .GlobalEnv)
hcp.cortical.fc <-flatten(hcp.cortical.fc)

# Removing subjects with empty entries
keep <- sapply(hcp.cortical.fc, function(x) length(x) > 0)
hcp.cortical.fc.Filtered <- hcp.cortical.fc[keep]
subj.list.Filtered <- subj.list[keep]

# Extract the upper triangle of each correlation matrix and save into DF
pairwise_data <- lapply(hcp.cortical.fc.Filtered, function(x) x[upper.tri(x)])
pairwise_data <- as.data.frame(pairwise_data)
pairwise_data <- t(pairwise_data)

# Calculate the number of regions, unique pairs, and number of subjects in the data
num_pairs <- ncol(pairwise_data)
num_regions <- (1 + sqrt(1 + 8 * num_pairs)) / 2
num_subjects <- length(subj.list.Filtered)

# Generate column names
column_names <- ""
idx <- 1
j=1
k=1
region_pairs <- combn(num_regions, 2, simplify = FALSE)
column_names <- sapply(region_pairs, function(pair) {
  sprintf("Region_%d_%d", pair[1], pair[2])
})

# Add column names and combine pairwise regions and subject ID's
colnames(pairwise_data) <- column_names
rownames(pairwise_data) <- NULL
final_data <- cbind(Subject_ID = subj.list.Filtered, pairwise_data) 

# Write to CSV for analysis into Data/Pairwise_FC folder
write.csv(final_data, "Data/Pairwise_FC/Pairwise_Corr_FC.csv", row.names = FALSE)

##### 175 Traits #####

# Load 175 traits from the data directory
Traits_Data <- readMat("Data/traits/175traits/HCP_175Traits.mat") 
list2env(Traits_Data,envir = .GlobalEnv)

# Combine subject ID with trait responses, also rename column names
traits.final <- cbind(hcp.subj.id,t(traits.175))
colnames(traits.final)[2:ncol(traits.final)] <- paste0("Trait_", 1:(ncol(traits.final) - 1))
colnames(traits.final)[1] <- "Subject_ID"

# Filter traits that have NA values
traits.final <- traits.final[rowSums(is.na(traits.final)) < 20, ]

# Remove columns with any NAs
traits.final <- df_filtered_rows[, colSums(is.na(df_filtered_rows)) == 0]

#Write to .csv file in the Data/Pairwise_FC folder
write.csv(traits.final, "Data/Pairwise_FC//Traits175.csv", row.names = FALSE)

##### Confounding Variables (Age and Gender) #####

# Load confounding MatLab file from the data directory
confound_var <- readMat("Data/traits/age_gender_subjectid.mat") 
list2env(confound_var,envir = .GlobalEnv)

#Combine subject ID with variables, also rename column names
confound_var_final <- cbind(allsubject.id,t(confond.variable))
colnames(confound_var_final) <- c("Subject_ID","Age","Gender")

#Write to .csv file in the Data/Pairwise_FC folder
write.csv(confound_var_final, "Data/Pairwise_FC/Confounding_variables.csv", row.names = FALSE)