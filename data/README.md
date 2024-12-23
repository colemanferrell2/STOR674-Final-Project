# Data
The study involves the use of three main datasets:
- Traits: This contains 175 traits of about 1065 subjects that measure a person’s cognition, substance use, psychiatric and life function, sensory, emotion, health and family history.
- Functional Connectomes: This contains the connectomes for 68 brain regions based on the Desikan-Killiany Atlas. For each subject, a 68 X 68 matrix with functional connectivity (FC) for each pair. The extraction of FC was based on Zhang et al. [2019] Since this matrix is naturally symmetric. The upper (or lower) triangle data contains all the information needed for each subject.

Due to the sensitive nature of the data, we took deliberate steps to comply
with the terms of the restricted dataset provided by the HCP. More importantly, we carefully designed the analysis to protect the privacy of HCP subjects. Robust data transformations and filtering were performed during preprocessing, and these methods are detailed in Section 2 of the report. We specifically must avoid providing data that could lead to identifiability on the individual level. To ensure anonymity, we implemented various redaction and randomization techniques. For the trait data, sensitive behavioral traits, such as substance use and psychiatric well-being, are reported at the individual level. We used the synthpop package in R to create synthetic data based on the distributions of raw behavioral traits. Additionally, we removed the trait names, reordered them randomly, and assigned unidentifiable numbers. The
specific arguments and methods used in synthpop are not disclosed to prevent traceability. For the brain region data, identifiability is already reduced through PCA, requiring minimal additional anonymization. To further mitigate the risk of reverse engineering, we did not report specific loadings for each subject, rather we again created synthetic data. For both sample datasets, subject identifiers were removed, and the rows were arranged in a disclosed random order. 

## Subfolder Structure

### `Brain_Region_Name.xlsx`
TIndicies for the brain regions from from the Desikan Parcellation

### `Details_175_Traits.xlsx`
This file contains details of the 175 traits considered in the begninig of our analysis before preprocessing. Traits are measures of a person’s cognition, substance use, psychiatric and life function, sensory, emotion, health and family history.

### `Sample_Data.RData`
An `.RData` file that contains the synthetic data generated for the traits and PCA loadings, along with the true PCA matrix found during our analysis.