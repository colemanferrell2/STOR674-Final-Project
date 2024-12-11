# Canonical Correlation Analysis on Functional Connectivity of Human Connectome Project
## STOR 674 Final Project
## Coleman Ferrell and Malavika Mampally
Canonical Correlation Analysis (CCA) has been widely applied to the Human Connectome Project (HCP) data to explore relationships between functional connectivity (FC) patterns and behavioral or cognitive traits. By identifying linear combinations of brain-wide FC measures and individual-level traits, CCA reveals how large-scale connectivity networks are associated with complex human behaviors, such as cognitive and emotional traits. This approach leverages the rich HCP dataset to provide insights into individual differences, highlighting connections between functional brain networks and life outcomes. The methods were inspired from *Computational Inference for Directions in Canonical Correlation Analysis*, authored by Daniel Kessler (UNC-Chapel Hill) and Elizaveta Levina (Michigan).
 
Specifically, this project explores the relationship between FC and human traits using CCA on data from the Human Connectome Project. By analyzing FC matrices and 123 traits across cognition, motor skills, substance use, and psychiatric measures, the study identified significant correlations. Notably, the first canonical direction highlighted links between the caudal middle frontal gyrus and traits related to cognition and motor function, while the second canonical direction suggested potential associations with substance use.

 This repository is meticulously structured to promote reproduciblity. It includes annotated R scripts, a well-documented README, and synthetic sample data to address privacy concerns while ensuring transparency. The repository is designed to enable others to replicate the preprocessing and analysis of results in a seamless manner. 

## Repository Structure

### `data/`
This directory holds synthetic datasets and information on the variables used in the project. Specifically, this folder contains information about the labels used for the 68 brain regions and the behavioral traits included in the analysis. All scripts for the project will get the data from this folder.

### `report/`
This directory contains the final report submitted as part of the requirements for the STOR 674 final project. The figures and references correspoinding to the final report are also located here. Finally, information regarding the project instructions and a background of the Human Connectome Project are included.

### `results/`
A comprehensive collection of the visuals generated throughout the project are stored here. This folder is divided into two main categories, visuals created during the EDA portion of the project and visuals created during the analysis portion.

### `scripts/`
his folder is organized into subdirectories based on the purpose of the code. It includes scripts for EDA, scripts for performing the main analyses, and a collection of reusable functions. Additionally, the folder contains the renv environment configuration to ensure consistency in R package versions and dependencies across systems

## Running the script
To execute the analysis, simply run the `run.sh` file from the command line. More explicit details on what parts of the analysis are executed through this script can be seen in the `analysis.R` file in the `scripts/` folder.

This script automates the later portion of the workflow, begining with the analysis using `combootcca` on the sample data. It executes the R script and generates results based on the sample data, and it saves the outputs in their designated spot. Furthermore, the script uses `renv` to manage R package dependencies, ensuring a consistent computational environment before running the analysis. This is essentail to allow for our work because it repliaces the exact setip needed and allows for reproducable result.