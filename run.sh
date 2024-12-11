#!/bin/bash

# Define the specific R script to be run
R_SCRIPT="analysis.R"

# Define the base directory for the scripts
BASE_DIR="$HOME/scripts"

#!/bin/bash

# Navigate to the scripts directory
BASE_DIR="$HOME/scripts"
cd "$BASE_DIR" || { echo "Failed to change directory to $BASE_DIR"; exit 1; }

# Activate renv and restore environment
Rscript -e "renv::restore()"

# Run the analysis script
Rscript analysis.R || {
    echo "Error: analysis.R failed. Check the logs for details."
    exit 1
}

echo "Script executed successfully."
exit 0


