##### Set up #####
#Install the combootcca package and R.matlab package if not installed already
#devtools::install_github("dankessler/combootcca")

#Load Libraries
library(dplyr)
library(ggplot2)

# Set your working directory to the project folder and load combootcca functions
setwd("C:/Users/colem/Desktop/STOR 674/STOR674 Final Project")
source("code/Analysis/combootcca_func/funcs.R")

# Set seed for reproducibility
set.seed(123)

#Load .csv Data file with Pairwise Correlations and traits
Pairwise_Corr_FC <- read.csv("Data/Pairwise_FC/Pairwise_Corr_FC.csv")
Subj_175_Traits <- read.csv("Data/Pairwise_FC/Traits175.csv")
Subj_confound_var <- read.csv("Data/Pairwise_FC/Confounding_variables.csv")

# Find common Subject_IDs across all three objects
common_ids <- Reduce(intersect, list(Pairwise_Corr_FC$Subject_ID, Subj_175_Traits$Subject_ID, Subj_confound_var$Subject_ID))

# Filter each data frame by common Subject_IDs
Pairwise_Corr_FC <- Pairwise_Corr_FC[Pairwise_Corr_FC$Subject_ID %in% common_ids, ]
Subj_175_Traits<- Subj_175_Traits[Subj_175_Traits$Subject_ID %in% common_ids, ]
Subj_confound_var <- Subj_confound_var [Subj_confound_var $Subject_ID %in% common_ids, ]

# Sort by Subject ID and make Subject ID the row names
Pairwise_Corr_FC <- arrange(Pairwise_Corr_FC,by = Subject_ID)
rownames(Pairwise_Corr_FC) <- Pairwise_Corr_FC[,1]
Pairwise_Corr_FC <- Pairwise_Corr_FC[,-1]

Subj_175_Traits <- arrange(Subj_175_Traits,by = Subject_ID)
rownames(Subj_175_Traits) <- Subj_175_Traits[,1]
Subj_175_Traits <- Subj_175_Traits[,-1]

Subj_confound_var <- arrange(Subj_confound_var,by = Subject_ID)
rownames(Subj_confound_var) <- Subj_confound_var[,1]
Subj_confound_var <- Subj_confound_var[,-1]

###### Partition the data into 2 equal sets: Set 1 and Set 2 #####
n=nrow(Pairwise_Corr_FC)
n_train <- floor(n * .5)
train_ind <- sample.int(n, size = n_train, replace = FALSE)

x1 <- Pairwise_Corr_FC[+train_ind, ]
x2 <- Pairwise_Corr_FC[-train_ind, ]
y1 <- Subj_175_Traits[+train_ind, ]
y2 <- Subj_175_Traits[-train_ind, ]
w1 <- Subj_confound_var[+train_ind,]
w2 <- Subj_confound_var[-train_ind,]

##### Regress the variables of interest on the confounding variables
adjust_for_nuisance <- function(data, nuisance) {
  nuisance <- as.matrix(nuisance)
  data <- as.matrix(data)
  # Compute the projection matrix for nuisance covariates
  A <- solve(t(nuisance) %*% nuisance) %*% t(nuisance) %*% data
  
  # Remove the nuisance effect
  data_adjusted <- data - nuisance %*% A
  return(data_adjusted)
}

# Apply to X1,Y1,X2,Y2
X1_adjusted <- adjust_for_nuisance(x1, w1)
Y1_adjusted <- adjust_for_nuisance(y1, w1)
X2_adjusted <- adjust_for_nuisance(x2, w2)
Y2_adjusted <- adjust_for_nuisance(y2, w2)

##### Dimension Reduction using PCA #####
# Perform PCA on X1_adjusted, and obtain weights
pca_X1 <- prcomp(X1_adjusted, center = TRUE, scale. = TRUE)
pca_Y1 <- prcomp(Y1_adjusted, center = TRUE, scale. = TRUE)

X1_pca <- pca_X1$x[, 1:300]
loadingsX <- pca_X1$rotation
Y1_pca <- pca_Y1$y[, 1:123]
loadingsY <- pca_Y1$rotation

Vx <- loadingsX
Dx <- diag(pca_X1$sdev^2)
Vy <- loadingsY
Dy <- diag(pca_Y1$sdev^2)

# Project X2_adjusted/Y2_adjusted onto the PCA space of X1nand Y1 respectively
X2_pca <- scale(X2_adjusted, center = pca_X1$center, scale = pca_X1$scale) %*% pca_X1$rotation[, 1:300]
Y2_pca <- scale(Y2_adjusted, center = pca_Y1$center, scale = pca_Y1$scale) %*% pca_Y1$rotation[, 1:123]

# Standardizing X2 and Y2 to have mean 0 and variance 1
X2_final <- scale(X2_pca)
Y2_final <- scale(Y2_pca)

#######Performing statistical inference using combootcca ##############################################################
# Creating reference solution
ref_solution <- cancor_scaled(X2_final, Y2_final, align = cca_align_nil, ref = NULL)
# Running combootcca
bootstrp_solution <- cca_ci_absboot(X2_final, Y2_final, align = cca_align_hungarian_weighted, ref = ref_solution,level=.9,nboots=1000)

# Extract Canonical Direction Confidence Intervals
xcoef_lower_diagonal <- bootstrp_solution$xcoef[, , 1]  
xcoef_upper_diagonal <- bootstrp_solution$xcoef[, , 2]  
ycoef_lower_diagonal <- bootstrp_solution$ycoef[, , 1]  
ycoef_upper_diagonal <- bootstrp_solution$ycoef[, , 2] 
##### Extracting first three principal components #####
## Extracting First three Principal Components for X 
xLB_first_PC <- as.data.frame(xcoef_lower_diagonal[,1] )
xUB_first_PC <- as.data.frame(xcoef_upper_diagonal[,1] )
x_first_PC <- cbind(xLB_first_PC,xUB_first_PC,seq(1:300))
colnames(x_first_PC) <- c("LB","UB","Index")
x_first_PC$CI_contains_zero <- ifelse(x_first_PC[,1] <= 0 & x_first_PC[,2] >= 0, TRUE, FALSE)

xLB_second_PC <- as.data.frame(xcoef_lower_diagonal[,2] )
xUB_second_PC <- as.data.frame(xcoef_upper_diagonal[,2] )
x_second_PC <- cbind(xLB_second_PC,xUB_second_PC,seq(1:300))
colnames(x_second_PC) <- c("LB","UB","Index")
x_second_PC$CI_contains_zero <- ifelse(x_second_PC[,1] <= 0 & x_second_PC[,2] >= 0, TRUE, FALSE)

xLB_third_PC <- as.data.frame(xcoef_lower_diagonal[,3] )
xUB_third_PC <- as.data.frame(xcoef_upper_diagonal[,3] )
x_third_PC <- cbind(xLB_third_PC,xUB_third_PC,seq(1:300))
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
  facet_wrap(~ PC, scales = "free_y",ncol = 1) + 
  ggtitle("Confidence Interval for first three canonical directions for B")+
  geom_hline(yintercept = 0,  color = "black") +# Create separate plots for each PC
  labs(x = "Principal Component", y = "Value", color = "CI Contains Zero") +  # Labels for axes
  theme_minimal()  # Use a minimal theme for the plot

ggsave("output/Figures/CI_3PC_B.png",plot=CI_3PC_B, width = 10, height = 6)

## Extracting First three Principal Components for Y
yLB_first_PC <- as.data.frame(ycoef_lower_diagonal[,1] )
yUB_first_PC <- as.data.frame(ycoef_upper_diagonal[,1] )
y_first_PC <- cbind(yLB_first_PC,yUB_first_PC,seq(1:123))
colnames(y_first_PC) <- c("LB","UB","Index")
y_first_PC$CI_contains_zero <- ifelse(y_first_PC[,1] <= 0 & y_first_PC[,2] >= 0, TRUE, FALSE)

yLB_second_PC <- as.data.frame(ycoef_lower_diagonal[,2] )
yUB_second_PC <- as.data.frame(ycoef_upper_diagonal[,2] )
y_second_PC <- cbind(yLB_second_PC,yUB_second_PC,seq(1:123))
colnames(y_second_PC) <- c("LB","UB","Index")
y_second_PC$CI_contains_zero <- ifelse(y_second_PC[,1] <= 0 & y_second_PC[,2] >= 0, TRUE, FALSE)

yLB_third_PC <- as.data.frame(ycoef_lower_diagonal[,3] )
yUB_third_PC <- as.data.frame(ycoef_upper_diagonal[,3] )
y_third_PC <- cbind(yLB_third_PC,yUB_third_PC,seq(1:123))
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
  facet_wrap(~ PC, scales = "free_y",ncol = 1) + 
  ggtitle("Confidence Interval for first three canonical directions for G")+ 
  geom_hline(yintercept = 0,  color = "black") +# Create separate plots for each PC
  labs(x = "Principal Component", y = "Value", color = "CI Contains Zero") +  # Labels for axes
  theme_minimal()  # Use a minimal theme for the plot

ggsave("output/Figures/CI_3PC_G.png",plot=CI_3PC_G, width = 10, height = 6)

##### Comparing the lengths of the confidence intervals #####
## X confidence intervals
# Calculate the length of each confidence interval
x_first_PC$CI_length <- x_first_PC$UB - x_first_PC$LB
x_second_PC$CI_length <- x_second_PC$UB - x_second_PC$LB
x_third_PC$CI_length <- x_third_PC$UB - x_third_PC$LB

# Compute the average length for each principal component
avg_CI_x <- data.frame(
  PC = c("B1", "B2", "B3"),
  Avg_CI_Length = c(
    mean(x_first_PC$CI_length),
    mean(x_second_PC$CI_length),
    mean(x_third_PC$CI_length)
  )
)

## Y confidence intervals
# Calculate the length of each confidence interval
y_first_PC$CI_length <- y_first_PC$UB - y_first_PC$LB
y_second_PC$CI_length <- y_second_PC$UB - y_second_PC$LB
y_third_PC$CI_length <- y_third_PC$UB - y_third_PC$LB

# Compute the average length for each principal component
avg_CI_y <- data.frame(
  PC = c("G1", "G2", "G3"),
  Avg_CI_Length = c(
    mean(y_first_PC$CI_length),
    mean(y_second_PC$CI_length),
    mean(y_third_PC$CI_length)
  )
)

# Combine the average CI lengths for x and y components
avg_CI_combined <- rbind(
  data.frame(PC = c("B1", "B2", "B3"), Avg_CI_Length = avg_CI_x$Avg_CI_Length, Type = "X"),
  data.frame(PC = c("G1", "G2", "G3"), Avg_CI_Length = avg_CI_y$Avg_CI_Length, Type = "Y")
)

# Print the combined results
print(avg_CI_combined)

##### Investigating canonical correlations #####
canonical_correlations <- ref_solution$cor
correlation_data <- data.frame(
  PC = paste("Canonical Correlation", 1:length(canonical_correlations)),
  Correlation = canonical_correlations
)
correlation_data$PC <- factor(correlation_data$PC, levels = paste("Canonical Correlation", 1:length(canonical_correlations)))

Can_Corr <- ggplot(correlation_data[c(1:30),], aes(x = PC, y = Correlation)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(x = "Principal Component", y = "Canonical Correlation", title = "Bar Plot of Canonical Correlations") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

ggsave("output/Figures/Can_Corr.png",plot=Can_Corr, width = 10, height = 6)

##### Transforming First Principal Component back to feature space #####

# Transform CI back onto original feature space
Xcoef_original <- Vx[,c(1:300)] %*% Dx[c(1:300),c(1:300)]^.5 %*% as.matrix(x_first_PC$LB+((x_first_PC$UB - x_first_PC$LB))/2)
Ycoef_original <- Vy[,c(1:123)] %*% Dy[c(1:123),c(1:123)]^.5 %*% as.matrix(((y_first_PC$UB - y_first_PC$LB))/2)

# Graph investigating category of traits
Ycoef_original_Traits <- rownames(Ycoef_original)
Ycoef_original_Traits  <- as.numeric(gsub("Trait_", "", Ycoef_original_Traits))
Ycoef_original_PC1Values <- Ycoef_original[,1]
Ycoef_original_Index <- seq(1:123)
Ycoef_original_TraitsCAT <-case_when(
      Ycoef_original_Traits %in% 1:45  ~ "Cognition", 
      Ycoef_original_Traits %in% 46:52  ~ "Motor",  
      Ycoef_original_Traits %in% 53:88 ~ "Substance Use",    
      Ycoef_original_Traits %in% 89:131 ~ "Psychiatric and Life Function",
      Ycoef_original_Traits %in% 132:142 ~ "Sensory",
      Ycoef_original_Traits %in% 143:166 ~ "Emotion",
      Ycoef_original_Traits %in% 167:171 ~ "Personality",
      Ycoef_original_Traits %in% 172:174 ~ "Health and Family History",
      TRUE ~ "Alertness"  
    )
  
Ycoef_original_PC1 <- cbind(Traits = as.data.frame(Ycoef_original_Index),Ycoef_original_Traits,Values = as.data.frame(Ycoef_original_PC1Values),Ycoef_original_TraitsCAT)

Trait_Category_FeatureSpace <- ggplot(Ycoef_original_PC1,aes(x=Ycoef_original_Index,y= Ycoef_original_PC1Values)) +
  geom_point(aes(colour = Ycoef_original_TraitsCAT)) +  # Add points to the plot
  scale_x_continuous() +  # Ensure x-axis is continuous
  scale_y_continuous() +  # Ensure y-axis is continuous
  labs(title = "CCA Direction 1 by Trait Category", x = "Trait Number", y = "CCA Direction 1 Weights (Transformed to feature space)",color = "Trait Category") +
  theme_minimal()

ggsave("output/Figures/Trait_Category_FeatureSpace.png",plot=Trait_Category_FeatureSpace, width = 10, height = 6)