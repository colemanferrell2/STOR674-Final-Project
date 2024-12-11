# Results
This folder serves as the central repository for all figures generated during the project.  The folder is organized into two subfolders to distinguish between figures created during the initial exploration of the data and those produced from the final analysis.

## Subfolder Structure
### `EDA/`
 This subfolder contains figures generated during the EDA phase. These figures include visual summaries, such as distributions, correlations, and other initial insights into the dataset. They represent the starting point of our investigation into the data's structure and trends. These figures are created using the untransformed data, thus they are not reproducible in this repository. 

### `Analysis/`
 This subfolder contains figures generated from synthetic data after running the R scripts located in the `scripts/` folder. These figures represent the processed results and key findings derived from the synthetic dataset. These are further organized based on the nature off the finding. Note that figures based on the original, untransformed data that were used in the final report are not included here. Instead, they can be found in the `report/` folder, along with the final report and associated documentation.

 - ##### `Confidence Intervals/`
 Contains figures of the confidence intervals in the first two canonical directions. `CI_3PC_B.png` contains the confidence intervals for the brain region principal components, while `CI_3PC_G.png` contains the confidence intervals for the traits
 
 - ##### `PC Loadings/`
 Contains `.html` tables that shows the percent contribution of each brain regions loading values in the first and second canonical directions. This is calcualted by considering the loadings the brain regions have across the principal components that were found significant. `Region_Loadings_First_Direction.html` contains the first direction and `Region_Loadings_Second_Direction.html` contains the second direction.

 - ##### `Significant Variable Weights/`
 `.html` tables that list the trait numbers and PC numbers that were found to be significant from the `combootcca` confidence intervals. The significant variables are found for both of the first two directions, `Significant_X_PC.html` and `Significant_Y_Trait.html` contain the significant PC numbers and trait numbers respectively.