# Main script execution
setwd("C:/Users/colem/Desktop/STOR 674/STOR674 Final Project")
load("data/Sample_Data.RData")
source("scripts/functions.R")
setup_environment()

cca_results <- run_cca(PrincComp_FC, Synthetic_Subj_Traits)
x_data <- extract_and_prepare_ci(cca_results$bootstrp_solution, "xcoef", c(1, 2))
y_data <- extract_and_prepare_ci(cca_results$bootstrp_solution, "ycoef", c(1, 2))

plot_ci(x_data, "Confidence Interval for Canonical Directions (X)", "results/Figures/CI_3PC_B.png")
plot_ci(y_data, "Confidence Interval for Canonical Directions (Y)", "results/Figures/CI_3PC_G.png", y_limits = c(-8, 8))
non_zero_x <- list(
  First_Direction = x_data$Index[!x_data$CI_contains_zero & x_data$PC == "\u03B21"],
  Second_Direction = x_data$Index[!x_data$CI_contains_zero & x_data$PC == "\u03B22"]
)
non_zero_y <- list(
  First_Direction = y_data$Index[!y_data$CI_contains_zero & y_data$PC == "\u03B31"],
  Second_Direction = y_data$Index[!y_data$CI_contains_zero & y_data$PC == "\u03B32"]
)

Loadings_Dir1 <- calculate_contributions(loadingsX_synthetic, non_zero_x$First_Direction)
Loadings_Dir2 <- calculate_contributions(loadingsX_synthetic, non_zero_x$Second_Direction)

library(DT)

# Save as an interactive HTML table
datatable(as.matrix(non_zero_x),colnames = "Significant PC Number") %>% saveWidget("results/Analysis/Significant Variable Weights/Significant_X_PC.html")
datatable(as.matrix(non_zero_y),colnames = "Significant Trait Number") %>% saveWidget("results/Analysis/Significant Variable Weights/Significant_Y_Trait.html")
datatable(Loadings_Dir1,rownames = NULL,options = list(order = list(list(1,'desc')))) %>% saveWidget("results/Analysis/PC Loadings/Region_Loadings_First_Direction.html")
datatable(Loadings_Dir2,rownames = NULL,options = list(order = list(list(1,'desc')))) %>% saveWidget("results/Analysis/PC Loadings/Region_Loadings_Second_Direction.html")


