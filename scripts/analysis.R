##### Setup #####
# Install necessary packages
# devtools::install_github("dankessler/combootcca")

# Load Libraries
library(combootcca)
library(dplyr)
library(ggplot2)
library(CCA)

# Set working directory and seed
setwd("C:/Users/colem/Desktop/STOR 674/STOR674 Final Project")
set.seed(123)

# Load Data
load("data/Sample_Data.RData")

# Source Functions
source("code/functions.R")

##### Statistical Inference Using combootcca #####
# Create reference solution and bootstrap results
ref_solution <- cc(PrincComp_FC, Synthetic_Subj_Traits)
bootstrp_solution <- run_combootcca(PrincComp_FC, Synthetic_Subj_Traits, ref_solution)

##### Extract Principal Component Confidence Intervals #####
# Process and visualize confidence intervals for X
all_PC_data_x <- process_principal_components(
  bootstrp_solution$basic$xcoef,
  c("\u03B21", "\u03B22")
)
plot_confidence_intervals(all_PC_data_x, "output/Figures/CI_3PC_B.png", "Confidence Interval for First Three Canonical Directions (B)")

# Process and visualize confidence intervals for Y
all_PC_data_y <- process_principal_components(
  bootstrp_solution$basic$ycoef,
  c("\u03B31", "\u03B32")
)
plot_confidence_intervals(all_PC_data_y, "output/Figures/CI_3PC_G.png", "Confidence Interval for First Three Canonical Directions (G)",ylim_range = c(-8, 8))

# Add these after constructing x_first_PC, x_second_PC, etc.
non_zero_indexes_first_PC_X <- which(!(x_first_PC$CI_contains_zero))
non_zero_indexes_second_PC_X <- which(!(x_second_PC$CI_contains_zero))

non_zero_indexes_first_PC_Y <- which(!(y_first_PC$CI_contains_zero))
non_zero_indexes_second_PC_Y <- which(!(y_second_PC$CI_contains_zero))

##### Canonical Loadings and Cross Loadings #####
loading_results <- calculate_loadings(ref_solution, non_zero_indexes_first_PC_X, non_zero_indexes_second_PC_X, non_zero_indexes_first_PC_Y, non_zero_indexes_second_PC_Y)

##### Principal Component Contributions #####
result1 <- calculate_contributions(loadingsX, non_zero_indexes_first_PC_X)
result2 <- calculate_contributions(loadingsX, non_zero_indexes_second_PC_X)

print(result1)
print(result2)

