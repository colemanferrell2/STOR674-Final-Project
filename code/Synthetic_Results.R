##### Set up #####
#Install the combootcca package and R.matlab package if not installed already
#devtools::install_github("dankessler/combootcca")

# Load Libraries
library(combootcca)
library(dplyr)
library(ggplot2)

# Set your working directory to the project folder and load combootcca functions
setwd("C:/Users/colem/Desktop/STOR 674/STOR674 Final Project")

# Set seed for reproducibility
set.seed(123)

# Load Data
load("data/Sample_Data.RData")

####### Performing statistical inference using combootcca #######

# Creating reference solution
ref_solution <- cancor(PrincComp_FC, Synthetic_Subj_Traits)
# Running combootcca
bootstrp_solution <-cca_ci_boot(PrincComp_FC, Synthetic_Subj_Traits, align = combootcca:::cca_align_hungarian_weighted,ref = ref_solution,level=.9,nboots=1000,boot_type = "basic")

# Extract Canonical Direction Confidence Intervals
xcoef_lower_diagonal <- bootstrp_solution$basic$xcoef[, , 1]  
xcoef_upper_diagonal <- bootstrp_solution$basic$xcoef[, , 2]  
ycoef_lower_diagonal <- bootstrp_solution$basic$ycoef[, , 1]  
ycoef_upper_diagonal <- bootstrp_solution$basic$ycoef[, , 2] 
##### Extracting first three principal components #####
## Extracting First three Principal Components for X 
xcoef_num <- nrow(bootstrp_solution$basic$xcoef)

xLB_first_PC <- as.data.frame(xcoef_lower_diagonal[,1] )
xUB_first_PC <- as.data.frame(xcoef_upper_diagonal[,1] )
x_first_PC <- cbind(xLB_first_PC,xUB_first_PC,seq(1:xcoef_num))
colnames(x_first_PC) <- c("LB","UB","Index")
x_first_PC$CI_contains_zero <- ifelse(x_first_PC[,1] <= 0 & x_first_PC[,2] >= 0, TRUE, FALSE)

xLB_second_PC <- as.data.frame(xcoef_lower_diagonal[,2] )
xUB_second_PC <- as.data.frame(xcoef_upper_diagonal[,2] )
x_second_PC <- cbind(xLB_second_PC,xUB_second_PC,seq(1:xcoef_num))
colnames(x_second_PC) <- c("LB","UB","Index")
x_second_PC$CI_contains_zero <- ifelse(x_second_PC[,1] <= 0 & x_second_PC[,2] >= 0, TRUE, FALSE)

xLB_third_PC <- as.data.frame(xcoef_lower_diagonal[,3] )
xUB_third_PC <- as.data.frame(xcoef_upper_diagonal[,3] )
x_third_PC <- cbind(xLB_third_PC,xUB_third_PC,seq(1:xcoef_num))
colnames(x_third_PC) <- c("LB","UB","Index")
x_third_PC$CI_contains_zero <- ifelse(x_third_PC[,1] <= 0 & x_third_PC[,2] >= 0, TRUE, FALSE)

# Combine the three data frames into one, adding a new column for PC number
x_first_PC$PC <- "\u03B21"
x_second_PC$PC <- "\u03B22"
x_third_PC$PC <- "\u03B23"

# Combine all into one data frame
all_PC_data_x <- rbind(x_first_PC, x_second_PC, x_third_PC)

CI_3PC_B <- ggplot(all_PC_data_x, aes(x = Index, ymin = LB, ymax = UB, color = CI_contains_zero)) +
  geom_errorbar(width = 0.2) +  # Add error bars for confidence intervals
  geom_point(aes(y = (LB + UB) / 2)) +  # Add points for the mid-point of the CI
  scale_color_manual(values = c("red", "blue")) +  # Color the points and error bars based on CI_contains_zero
  facet_wrap(~ PC, scales = "free_y",ncol = 1)+
  ggtitle("Confidence Interval for first three canonical directions for B")+
  geom_hline(yintercept = 0,  color = "black") +# Create separate plots for each PC
  labs(x = "Principal Component", y = "Value", color = "CI Contains Zero") +  # Labels for axes
  theme_minimal()  # Use a minimal theme for the plot
CI_3PC_B
ggsave("output/Figures/CI_3PC_B.png",plot=CI_3PC_B, width = 10, height = 6)

## Extracting First three Principal Components for Y
ycoef_num <- nrow(bootstrp_solution$basic$ycoef)

yLB_first_PC <- as.data.frame(ycoef_lower_diagonal[,1] )
yUB_first_PC <- as.data.frame(ycoef_upper_diagonal[,1] )
y_first_PC <- cbind(yLB_first_PC,yUB_first_PC,seq(1:ycoef_num))
colnames(y_first_PC) <- c("LB","UB","Index")
y_first_PC$CI_contains_zero <- ifelse(y_first_PC[,1] <= 0 & y_first_PC[,2] >= 0, TRUE, FALSE)

yLB_second_PC <- as.data.frame(ycoef_lower_diagonal[,2] )
yUB_second_PC <- as.data.frame(ycoef_upper_diagonal[,2] )
y_second_PC <- cbind(yLB_second_PC,yUB_second_PC,seq(1:ycoef_num))
colnames(y_second_PC) <- c("LB","UB","Index")
y_second_PC$CI_contains_zero <- ifelse(y_second_PC[,1] <= 0 & y_second_PC[,2] >= 0, TRUE, FALSE)

yLB_third_PC <- as.data.frame(ycoef_lower_diagonal[,3] )
yUB_third_PC <- as.data.frame(ycoef_upper_diagonal[,3] )
y_third_PC <- cbind(yLB_third_PC,yUB_third_PC,seq(1:ycoef_num))
colnames(y_third_PC) <- c("LB","UB","Index")
y_third_PC$CI_contains_zero <- ifelse(y_third_PC[,1] <= 0 & y_third_PC[,2] >= 0, TRUE, FALSE)



# Combine the three data frames into one, adding a new column for PC number
y_first_PC$PC <- "\u03B31"
y_second_PC$PC <- "\u03B32"
y_third_PC$PC <- "\u03B33"

# Combine all into one data frame
all_PC_data_y <- rbind(y_first_PC, y_second_PC, y_third_PC)

CI_3PC_G <-ggplot(all_PC_data_y, aes(x = Index, ymin = LB, ymax = UB, color = CI_contains_zero)) +
  geom_errorbar(width = 0.2) +  # Add error bars for confidence intervals
  geom_point(aes(y = (LB + UB) / 2)) +  # Add points for the mid-point of the CI
  scale_color_manual(values = c("red", "blue")) +  # Color the points and error bars based on CI_contains_zero
  facet_wrap(~ PC, scales = "free_y",ncol = 1) + ylim(-8,8)+
  ggtitle("Confidence Interval for first three canonical directions for G")+ 
  geom_hline(yintercept = 0,  color = "black") +# Create separate plots for each PC
  labs(x = "Principal Component", y = "Value", color = "CI Contains Zero") +  # Labels for axes
  theme_minimal()  # Use a minimal theme for the plot
CI_3PC_G 
ggsave("output/Figures/CI_3PC_G.png",plot=CI_3PC_G, width = 10, height = 6)