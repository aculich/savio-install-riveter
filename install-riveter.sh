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

# Load Anaconda
module load anaconda3/2024.02-1-11.4 || { echo "Failed to load Anaconda module"; exit 1; }

# Create and activate Conda environment
if ! conda info --envs | grep -q "$ENV_NAME"; then
    conda create -y -n "$ENV_NAME" python=3.10
    echo "Conda environment '$ENV_NAME' created."
fi
source activate "$ENV_NAME" || { echo "Failed to activate Conda environment"; exit 1; }

# Install dependencies using Conda
conda install -y pandas tqdm seaborn spacy=3.7 -c conda-forge || { echo "Conda dependency installation failed"; exit 1; }

# Install spacy_experimental (using pip since not available on Conda)
pip install spacy_experimental || { echo "Failed to install spacy_experimental"; exit 1; }

# Install neuralcoref (requires compatibility fixes)
pip install git+https://github.com/huggingface/neuralcoref.git || { echo "Failed to install neuralcoref"; exit 1; }

# Download SpaCy model
python -m spacy download en_core_web_sm || { echo "Failed to download SpaCy model"; exit 1; }

# Clone and install Riveter
if [ ! -d "$REPO_DIR" ]; then
    git clone "$REPO_URL" || { echo "Failed to clone Riveter repository"; exit 1; }
    echo "Cloned Riveter repository"
fi
cd "$REPO_DIR" || { echo "Failed to access Riveter repository"; exit 1; }
pip install . || { echo "Failed to install Riveter"; exit 1; }

# Create test script
cat <<EOF > "../$TEST_SCRIPT"
import spacy

try:
    import neuralcoref
    nlp = spacy.load("en_core_web_sm")
    neuralcoref.add_to_pipe(nlp)
    doc = nlp("My sister has a dog. She loves him.")
    print("Coreferences:", doc._.coref_clusters)
except Exception as e:
    print(f"Test script error: {e}")
    raise
EOF

# Run test script
echo "Running test script..."
python "../$TEST_SCRIPT" || echo "Test script execution failed."

# Check for errors in the log
echo "Checking for errors in the log..."
if [ -f "$LOG_FILE" ]; then
    grep -B 5 -A 5 -i "error" "$LOG_FILE" || echo "No errors detected."
else
    echo "Log file not found."
fi

echo "Installation process completed."
date
