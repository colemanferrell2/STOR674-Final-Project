# Scripts
This folder contains all the R scripts used for the data processing, implementation and analysis conducted in the project. All scripts are not reproducible since they require the untransformed data set, but selected files are included to promote transparency. Furthermore, we include a `renv` environment by creating an isolated environment with a snapshot of the specific package versions used in the project. This ensures reproducibility, making it easier to reproduce results without compatibility issues.

## File Structure

### `EDA.Rmd`
This markdown file was constructed to gain an initial understanding of the relationships within the dataset, we conducted a correlation analysis. This involved generating a heatmap to visualize the correlations among the traits and brain regional correlation. This analysis provided a foundation for selecting features and guided subsequent steps in the modeling process. Age and gender were identified as potential confounding variables, as they can influence both brain development and cognitive traits. To quantify their effects, a formal correlation analysis and ANOVA were performed to assess the significance of age and gender across traits and brain regions. This code is not reproducible because it involves preprocessing of the confidential data. Nonetheless, it shows the methods and code used in the EDA.

### `analysis.R`
This R script performs the CCA on functional connectivity principal components and synthetic subject traits to identify relationships between the two datasets. It begins by loading required data and functions, then runs CCA and extracts Confidence intervals for canonical directions. Based on this analysis and confidence intervals, appropriate figures are generated and saved into the `results/analysis/` folder. Details on precicely the details of the analysis and the types of graphs created can be found in the `results/` folder or in the final report.

### `functions.R`
This script contains all custom functions used throughout the analysis portion, organized for reusability and clarity. These functions include implementations for running `combootcca`, along with functions to produce and save results. By sourcing this file, the main script is more readable and can be executed more conveniently.

### `renv.lock`
Using the `renv` package in R, this file contains exact versions of all R packages used in the project, ensuring consistent and reproducible environments. By using this file, future runs of the project can restore the same package versions, avoiding discrepancies caused by updates or changes in dependencies.