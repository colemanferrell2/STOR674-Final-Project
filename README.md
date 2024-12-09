# Canonical Correlation Analysis on Functional Connectivity of Human Connectome Project
## STOR 674 Final Project
## Coleman Ferrell and Malavika Mampally
Canonical Correlation Analysis (CCA) has been widely applied to the Human Connectome Project (HCP) data to explore relationships between functional connectivity (FC) patterns and behavioral or cognitive traits. By identifying linear combinations of brain-wide FC measures and individual-level traits, CCA reveals how large-scale connectivity networks are associated with complex human behaviors, such as cognitive and emotional traits. This approach leverages the rich HCP dataset to provide insights into individual differences, highlighting connections between functional brain networks and life outcomes. The methods were inspired from *Computational Inference for Directions in Canonical Correlation Analysis*, Authored by Daniel Kessler (UNC-Chapel Hill) and Elizaveta Levina (Michigan).
 
## Repository Structure

### `Project Background/`
This directory includes information regarding the project instructions and a background of the Human Connectome Project

### `Data/`

This directory holds all datasets used in the project.

Raw data from MRI is included alongside traits collected from the subjects. Also included is a file of the pairwise transformed correlation matricies.

### `code/`

Source code for the project's modules.

- `Data Formatting/`: Functions for data loading and preprocessing.
- `Analysis/`: Scripts used to perform combootcca. Steps of process are included in script comments

### `output/`
Graphs generated from the analysis.