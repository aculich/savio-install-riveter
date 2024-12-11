#!/bin/bash

# Variables
ENV_NAME="riveter_env"
REPO_URL="https://github.com/maartensap/riveter-nlp.git"
REPO_DIR="riveter-nlp"
LOG_FILE="install_riveter.log"
TEST_SCRIPT="test_riveter.py"

# Redirect output to log file
exec > >(tee "$LOG_FILE") 2>&1
echo "Starting installation process for Riveter..."
date

# Load required modules
echo "Loading required modules..."
module load anaconda3/2024.02-1-11.4 || { echo "Failed to load Anaconda module"; exit 1; }
module load python || { echo "Failed to load Python module"; exit 1; }

# Remove existing Conda environment if it exists
if conda info --envs | grep -q "$ENV_NAME"; then
    echo "Removing existing Conda environment '$ENV_NAME'..."
    conda remove -y --name "$ENV_NAME" --all || { echo "Failed to remove existing Conda environment"; exit 1; }
fi

# Create a new Conda environment
echo "Creating Conda environment '$ENV_NAME'..."
conda create -y -n "$ENV_NAME" || { echo "Failed to create Conda environment"; exit 1; }

# Activate the Conda environment
echo "Activating Conda environment '$ENV_NAME'..."
source activate "$ENV_NAME" || { echo "Failed to activate Conda environment"; exit 1; }

# Add conda-forge channel and install dependencies
echo "Adding conda-forge channel and installing dependencies..."
conda config --add channels conda-forge
conda install -y spacy pandas tqdm seaborn || { echo "Failed to install dependencies"; exit 1; }

# Use Mamba if available to speed up installations
if conda install -y mamba -c conda-forge; then
    echo "Mamba installed successfully. Using Mamba for faster installations..."
    mamba install -y neuralcoref || { echo "Failed to install neuralcoref"; exit 1; }
else
    echo "Mamba installation failed. Falling back to Conda for package installation..."
    conda install -y neuralcoref || { echo "Failed to install neuralcoref"; exit 1; }
fi

# Download SpaCy model
echo "Downloading SpaCy model..."
python -m spacy download en_core_web_sm || { echo "Failed to download SpaCy model"; exit 1; }

# Clone and install Riveter
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning Riveter repository..."
    git clone "$REPO_URL" || { echo "Failed to clone Riveter repository"; exit 1; }
fi

# Run test script
echo "Running test script..."
python "$TEST_SCRIPT" || { echo "Test script failed"; exit 1; }

echo "Installation process completed successfully."
